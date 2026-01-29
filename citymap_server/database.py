import os
import sqlite3
import secrets
import json
from time import time
import logging
import hasher


db_paths: dict = {
    'users': 'data/users.db',
    'sessions': 'data/users.db',
    'content': 'data/tickets.db',
    'stats': 'data/stats.db',
}

class DB:
    def __init__(self):
        """Инициализация класса и запуск создания таблиц."""
        self.connections = {}
        self.initialize_system()

    def get_connection(self, db_name):
        """Устанавливает и возвращает соединение с конкретной БД."""
        if db_name not in self.connections:
            conn = sqlite3.connect(db_paths[db_name], check_same_thread=False)
            conn.execute("PRAGMA foreign_keys = 1")
            conn.row_factory = self.dict_factory
            self.connections[db_name] = conn
        return self.connections[db_name]

    @staticmethod
    def dict_factory(cursor, row):
        """Преобразует строку из БД в словарь и парсит JSON поля."""
        d = {}
        for idx, col in enumerate(cursor.description):
            column_name = col[0]
            value = row[idx]

            if column_name in ['files_json', 'point'] and isinstance(value, str):
                try:
                    d[column_name] = json.loads(value)
                except (json.JSONDecodeError, TypeError):
                    d[column_name] = []
            else:
                d[column_name] = value
        return d

    def initialize_system(self):
        """Создает структуру папок и таблиц при первом запуске."""
        logging.info("Database initializing...")
        os.makedirs('data', exist_ok=True)

        # --- Таблицы пользователей и сессий ---
        with self.get_connection('users') as conn:
            conn.execute("""
                CREATE TABLE IF NOT EXISTS users (
                    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
                    email TEXT UNIQUE NOT NULL,
                    password_hash TEXT NOT NULL,
                    firstname TEXT NOT NULL,
                    lastname TEXT NOT NULL,
                    patronymic TEXT,
                    birthdate TEXT NOT NULL,
                    snils INTEGER UNIQUE NOT NULL
                )
            """)
            conn.execute("""
                CREATE TABLE IF NOT EXISTS sessions (
                    session_id INTEGER PRIMARY KEY AUTOINCREMENT,
                    user_id INTEGER NOT NULL,
                    access_token TEXT UNIQUE NOT NULL,
                    created_at INTEGER NOT NULL,
                    expires_at INTEGER NOT NULL,
                    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
                )
            """)

        # --- Таблицы контента (тикеты, реакции, комментарии) ---
        with self.get_connection('content') as conn:
            conn.execute("""
            CREATE TABLE IF NOT EXISTS tickets (
                ticket_id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER NOT NULL,
                title TEXT,
                text TEXT,
                category INTEGER,
                point TEXT DEFAULT '[0, 0]',
                timestamp INTEGER,
                pinned INTEGER DEFAULT 0,
                archived INTEGER DEFAULT 0,
                official_comment TEXT DEFAULT '',
                files_json TEXT DEFAULT '[]'
            )
            """)
            conn.execute("""
            CREATE TABLE IF NOT EXISTS ticket_reactions (
                user_id INTEGER,
                ticket_id INTEGER,
                reaction_type INTEGER,
                PRIMARY KEY (user_id, ticket_id)
            )
            """)
            conn.execute("""
            CREATE TABLE IF NOT EXISTS comments (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                ticket_id INTEGER,
                user_id INTEGER,
                text TEXT,
                is_official INTEGER DEFAULT 0
            )
            """)

        # --- Таблицы статистики ---
        with self.get_connection('stats') as conn:
            conn.execute("CREATE TABLE IF NOT EXISTS logs (id INTEGER PRIMARY KEY AUTOINCREMENT, action TEXT, timestamp INTEGER)")

        logging.info("Database initialization is completed!")

    # --- МЕТОДЫ АВТОРИЗАЦИИ ---

    def signup(self, email, password, **kwargs) -> bool:
        """
        Регистрация нового пользователя.
        Возвращает True при успехе, False если email/СНИЛС заняты.
        """
        try:
            password = hasher.sha256(password)
            with self.get_connection('users') as conn:
                conn.execute("""INSERT INTO users
                    (email, password_hash, firstname, lastname, patronymic, birthdate, snils)
                    VALUES (?, ?, ?, ?, ?, ?, ?)""",
                    (email, password, kwargs.get('firstname'), kwargs.get('lastname'),
                     kwargs.get('patronymic'), kwargs.get('birthdate'), kwargs.get('snils')))
            return True
        except sqlite3.IntegrityError:
            return False

    def login(self, email, password):
        """
        Проверка логина и пароля.
        При успехе генерирует и возвращает access_token (str), иначе пустую строку.
        """
        password = hasher.sha256(password)
        with self.get_connection('users') as conn:
            user = conn.execute("SELECT user_id FROM users WHERE email = ? AND password_hash = ?",
                                (email, password)).fetchone()
            if not user: return False, ""

            token = secrets.token_hex(32)
            now = int(time())
            # Токен живет 7 дней (604800 секунд)
            conn.execute("INSERT INTO sessions (user_id, access_token, created_at, expires_at) VALUES (?, ?, ?, ?)",
                         (user['user_id'], token, now, now + 604800))
        return True, token

    def check_token(self, token: str):
        """
        Проверка валидности токена.
        Удаляет старые сессии и возвращает [True, user_id] или [False, -1].
        """
        now = int(time())
        with self.get_connection('users') as conn:
            conn.execute("DELETE FROM sessions WHERE expires_at < ?", (now,))
            res = conn.execute("SELECT user_id FROM sessions WHERE access_token = ? AND expires_at > ?",
                               (token, now)).fetchone()
            if res:
                return [True, res['user_id']]
            return [False, -1]

    def logout(self, token: str) -> bool:
        """Удаляет сессию (деавторизация)."""
        try:
            with self.get_connection('users') as conn:
                conn.execute("DELETE FROM sessions WHERE access_token = ?", (token,))
            return True
        except Exception:
            return False

    def recover(self, *args) -> None:
        """Заглушка для функции восстановления (согласно ТЗ)."""
        return None

    # --- МЕТОДЫ ТИКЕТОВ ---

    def create_ticket(self, user_id, title, text, category, files, point: tuple) -> list:
        """
        Создание новой заявки (тикета).
        Возвращает [True, ticket_id] при успехе.
        """
        try:
            with self.get_connection('content') as conn:
                cur = conn.cursor()
                cur.execute("""INSERT INTO tickets
                    (user_id, title, text, category, point, files_json, timestamp)
                    VALUES (?, ?, ?, ?, ?, ?, ?)""",
                    (user_id, title, text, category,
                        json.dumps(point), # Сериализуем список [lat, lon]
                        json.dumps(files), int(time())))
                return [True, cur.lastrowid]
        except Exception:
            return [False, -1]

    def edit_ticket(self, *args) -> None:
        """Заглушка для редактирования (согласно ТЗ)."""
        return None

    def get_feed(self, page: int, category: int) -> dict:
        """
        Получение ленты тикетов.
        Фильтрация: категория, только неархивные.
        Сортировка: сначала закрепленные, затем по рейтингу (лайки - дизлайки).
        """
        limit, offset = 30, (page - 1) * 30
        with self.get_connection('content') as conn:
            sql = """
                SELECT t.*,
                (SELECT COUNT(*) FROM ticket_reactions WHERE ticket_id = t.ticket_id AND reaction_type = 1) -
                (SELECT COUNT(*) FROM ticket_reactions WHERE ticket_id = t.ticket_id AND reaction_type = -1) as rating
                FROM tickets t
                WHERE (category = ? OR ? = -1) AND archived = 0
                ORDER BY pinned DESC, rating DESC LIMIT ? OFFSET ?
            """
            tickets = conn.execute(sql, (category, category, limit, offset)).fetchall()
            return {"page": page, "category": category, "tickets": tickets}

    def get_ticket(self, ticket_id: int) -> dict:
        """
        Получение полной информации о тикете, включая списки лайков, дизлайков и комментарии.
        """
        with self.get_connection('content') as conn:
            ticket = conn.execute("SELECT * FROM tickets WHERE ticket_id = ?", (ticket_id,)).fetchone()
            if not ticket: return {}

            # Десериализация данных
            ticket['likes'] = [r['user_id'] for r in conn.execute("SELECT user_id FROM ticket_reactions WHERE ticket_id = ? AND reaction_type = 1", (ticket_id,)).fetchall()]
            ticket['dislikes'] = [r['user_id'] for r in conn.execute("SELECT user_id FROM ticket_reactions WHERE ticket_id = ? AND reaction_type = -1", (ticket_id,)).fetchall()]
            ticket['comments'] = conn.execute("SELECT user_id, text, is_official FROM comments WHERE ticket_id = ?", (ticket_id,)).fetchall()
            return ticket

    def get_tickets(self, user_id: int, page: int = 1) -> dict:
        """Получение всех тикетов конкретного пользователя (включая архивные)."""
        limit, offset = 30, (page - 1) * 30
        with self.get_connection('content') as conn:
            sql = "SELECT * FROM tickets WHERE user_id = ? ORDER BY timestamp DESC LIMIT ? OFFSET ?"
            rows = conn.execute(sql, (user_id, limit, offset)).fetchall()
            return {"page": page, "user_id": user_id, "tickets": rows}

    def get_points(self) -> dict:
        """Возвращает координаты всех активных тикетов."""
        with self.get_connection('content') as conn:
            rows = conn.execute("SELECT point, ticket_id FROM tickets WHERE archived = 0").fetchall()
            return {"points": [[ r['point'], r['ticket_id'] ] for r in rows]}

    # --- РЕАКЦИИ И КОММЕНТАРИИ ---

    def _handle_reaction(self, user_id, ticket_id, r_type):
        """
        Внутренняя логика реакций:
        - Если реакции нет -> ставим.
        - Если такая же реакция уже есть -> убираем (0).
        - Если реакция другая -> меняем.
        """
        with self.get_connection('content') as conn:
            cur = conn.execute("SELECT reaction_type FROM ticket_reactions WHERE user_id = ? AND ticket_id = ?", (user_id, ticket_id)).fetchone()

            if not cur:
                conn.execute("INSERT INTO ticket_reactions (user_id, ticket_id, reaction_type) VALUES (?, ?, ?)", (user_id, ticket_id, r_type))
                conn.commit()
                return [True, r_type]

            if cur['reaction_type'] == r_type:
                conn.execute("DELETE FROM ticket_reactions WHERE user_id = ? AND ticket_id = ?", (user_id, ticket_id))
                conn.commit()
                return [True, 0]

            conn.execute("UPDATE ticket_reactions SET reaction_type = ? WHERE user_id = ? AND ticket_id = ?", (r_type, user_id, ticket_id))
            conn.commit()
            return [True, r_type]

    def like(self, user_id, ticket_id):
        """Поставить/убрать лайк."""
        return self._handle_reaction(user_id, ticket_id, 1)

    def dislike(self, user_id, ticket_id):
        """Поставить/убрать дизлайк."""
        return self._handle_reaction(user_id, ticket_id, -1)

    def comment(self, user_id, ticket_id, text) -> bool:
        """Добавить пользовательский комментарий к тикету."""
        with self.get_connection('content') as conn:
            conn.execute("INSERT INTO comments (user_id, ticket_id, text) VALUES (?, ?, ?)", (user_id, ticket_id, text))
            return True

    def official_comment(self, ticket_id, text) -> bool:
        """
        Установить официальный ответ от администрации.
        Дублирует текст в саму карточку тикета и в список комментариев.
        """
        with self.get_connection('content') as conn:
            conn.execute("UPDATE tickets SET official_comment = ? WHERE ticket_id = ?", (text, ticket_id))
            return True

    # --- УПРАВЛЕНИЕ ---

    def pin(self, ticket_id) -> list:
        """Закрепить или открепить тикет (переключатель)."""
        with self.get_connection('content') as conn:
            current = conn.execute("SELECT pinned FROM tickets WHERE ticket_id = ?", (ticket_id,)).fetchone()
            if not current: return [False, False]
            new_val = 1 if current['pinned'] == 0 else 0
            conn.execute("UPDATE tickets SET pinned = ? WHERE ticket_id = ?", (new_val, ticket_id))
            return [True, bool(new_val)]

    def archive_ticket(self, ticket_id) -> bool:
        """Переместить тикет в архив (скрыть из ленты)."""
        with self.get_connection('content') as conn:
            conn.execute("UPDATE tickets SET archived = 1 WHERE ticket_id = ?", (ticket_id,))
            return True

    def delete_ticket(self, ticket_id: int) -> bool:
        """Полное удаление тикета и связанных с ним данных (комментарии, реакции)."""
        try:
            with self.get_connection('content') as conn:
                conn.execute("DELETE FROM tickets WHERE ticket_id = ?", (ticket_id,))
                conn.execute("DELETE FROM comments WHERE ticket_id = ?", (ticket_id,))
                conn.execute("DELETE FROM ticket_reactions WHERE ticket_id = ?", (ticket_id,))
            return True
        except Exception:
            return False

    def get_statistic(self) -> dict:
        """Возвращает общую статистику: кол-во тикетов, ответов и пользователей."""
        stats = {}
        with self.get_connection('content') as conn:
            stats['tickets'] = conn.execute("SELECT COUNT(*) as c FROM tickets").fetchone()['c']
            stats['official_comments'] = conn.execute("SELECT COUNT(*) as c FROM tickets WHERE official_comment != ''").fetchone()['c']
        with self.get_connection('users') as conn:
            stats['users'] = conn.execute("SELECT COUNT(*) as c FROM users").fetchone()['c']
        return stats

    def get_user_data(self, user_id: int) -> dict:
        """Получение профиля пользователя по ID."""
        with self.get_connection('users') as conn:
            user = conn.execute("SELECT email, firstname, lastname, patronymic, birthdate, snils FROM users WHERE user_id = ?", (user_id,)).fetchone()
            return user if user else {}
