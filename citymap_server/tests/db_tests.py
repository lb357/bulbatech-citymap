from utils.database import DB
import json

def print_res(method_name, result):
    """Вспомогательная функция для красивого вывода результата."""
    print(f"--- [Метод: {method_name}] ---")
    if isinstance(result, (dict, list)):
        # Выводим словари и списки в удобном JSON-виде
        print(json.dumps(result, indent=4, ensure_ascii=False))
    else:
        print(f"Результат: {result}")
    print("-" * 40 + "\n")

def run_verbose_tests():
    db = DB()
    print("🔔 НАЧАЛО ТЕСТИРОВАНИЯ С ВЫВОДОМ ДАННЫХ\n")

    # 1. Регистрация
    res = db.signup(
        email="dev@test.ru",
        password="pass",
        firstname="Алексей",
        lastname="Петров",
        birthdate="1995-05-20",
        snils=999888777
    )
    print_res("signup", res)

    # 2. Логин (получаем токен)
    token = db.login("dev@test.ru", "pass")
    print_res("login (token)", token)

    # 3. Проверка токена
    check = db.check_token(token)
    print_res("check_token", check)
    user_id = check[1]

    # 4. Создание тикета
    ticket_res = db.create_ticket(
        user_id=user_id,
        title="Проблема с освещением",
        text="Не горит фонарь во дворе уже неделю.",
        category=2,
        files=["photo1.jpg", "photo2.png"],
        point=(59.93, 30.36)
    )
    print_res("create_ticket", ticket_res)
    ticket_id = ticket_res[1]

    # 5. Лайк и Дизлайк
    # Ставим лайк
    like_res = db.like(user_id, ticket_id)
    print_res("like (первое нажатие)", like_res)

    # Ставим дизлайк (должен заменить лайк)
    dislike_res = db.dislike(user_id, ticket_id)
    print_res("dislike (замена лайка)", dislike_res)

    # 6. Комментарии
    db.comment(user_id, ticket_id, "Поддерживаю, очень темно!")
    db.official_comment(ticket_id, "Заявка передана в Горсвет. Срок — 2 дня.")
    print("...Добавлены комментарии...\n")

    # 7. Получение полной информации о тикете (Самый важный вывод)
    full_ticket = db.get_ticket(ticket_id)
    print_res("get_ticket (полные данные)", full_ticket)

    # 8. Получение ленты (Feed)
    feed = db.get_feed(page=1, category=2)
    print_res("get_feed", feed)

    # 9. Точки на карте
    points = db.get_points()
    print_res("get_points", points)

    # 10. Статистика
    stats = db.get_statistic()
    print_res("get_statistic", stats)

if __name__ == "__main__":
    # Если папка data не пустая, тесты могут выдать False на signup (т.к. email занят)
    # Это нормально.
    run_verbose_tests()
