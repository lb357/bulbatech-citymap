import time
from database import DB
import tornado.escape
from tornado.web import RequestHandler
import hasher
import os




class Handler(RequestHandler):
    database: DB = None
    upload_extensions: list = []
    upload_max_size: int = 0
    official_token: str = ""
    official_name: str = ""
    official_place: str = ""
    version: int = 0
    def initialize(self, database, upload_extensions, upload_max_size, official_token, official_name, official_place, version):
        self.database = database
        self.upload_extensions = upload_extensions
        self.upload_max_size = upload_max_size
        self.official_token = official_token
        self.official_name = official_name
        self.official_place = official_place
        self.version = version

    def get_user(self):
        access_token_bytes = self.get_signed_cookie("access_token")
        if not access_token_bytes:
            self.send_error(401)
            return None
        access_token = access_token_bytes.decode("UTF-8")
        ret, user_id = self.database.check_token(access_token)
        if ret:
            return user_id
        else:
            self.send_error(403)
            return None

    def check_official(self):
        official_token = dict(tornado.escape.json_decode(self.request.body)).get("official_token")
        if official_token == self.official_token:
            return True
        else:
            self.send_error(403)
            return False

    def login(self):
        ret, access_token = self.database.login(**self.parse_data(email=str, password=str))
        if ret:
            self.set_signed_cookie("access_token", access_token.encode("UTF-8"), expires_days=7)
            self.finish({"success": True})
        else:
            self.finish({"success": False})

    @staticmethod
    def point(map_point) -> list[float]:
        return [float(map_point[0]), float(map_point[1])]

    def parse_data(self, **scheme) -> dict:
        data: dict = tornado.escape.json_decode(self.request.body)
        out = {}
        arg: str
        for arg in scheme:
            if arg in data:
                out[arg] = scheme[arg](data[arg])
            else:
                self.send_error(400)
                return {}
        return out

    def parse_url(self, **scheme) -> dict:
        out = {}
        for arg in scheme:
            out[arg] = scheme[arg](self.get_argument(arg))
        return out


class MainHandler(Handler):
    async def get(self):
        await self.render("templates/home.html",
                          official_place=self.official_place, version=self.version)

class LegalHandler(Handler):
    async def get(self):
        await self.render("templates/legal.html",
                          official_place=self.official_place, official_name=self.official_name)


class OfficialHandler(Handler):
    async def get(self):
        await self.render("templates/official/login.html",
                          official_place=self.official_place, official_name=self.official_name)


class OfficialLoginHandler(Handler):
    async def post(self):
        if self.check_official():
            await self.render("templates/official/panel.html",
                              official_place=self.official_place, official_name=self.official_name)


class SignUpHandler(Handler):
    async def post(self):
        if self.database.signup(**self.parse_data(
            email=str,
            password=str,
            lastname=str,
            firstname=str,
            patronymic=str,
            birthdate=str,
            snils=str
        )):
            self.login()
        else:
            await self.finish({"success": False})


class LogInHandler(Handler):
    async def post(self):
        self.login()


class LogOutHandler(Handler):
    async def post(self):
        access_token = self.get_signed_cookie("access_token").decode("UTF-8")
        ret = self.database.logout(access_token)
        await self.finish({"success": ret})


class StatusHandler(Handler):
    async def get(self):
        await self.finish({
            "credits": {
                "team": "BulbaTech",
                "members": ["Брискиндов Леонид", "Дайнейко Михаил", "Желтов Андрей", "Чех Даниил"],
                "university": "ФГАОУ ВО РУТ (МИИТ)",
                "year": 2026
            },
            "product": "BulbaTech-citymap",
            "repository": "https://github.com/lb357/bulbatech-citymap",
            "version": self.version,
            "official_place": self.official_place,
            "official_name": self.official_name,
            "timestamp": int(time.time())
        })


class RecoverHandler(Handler):
    async def post(self):
        self.send_error(405)


class FeedHandler(Handler):
    async def get(self):
        feed = self.database.get_feed(**self.parse_url(page=int, category=int))
        await self.finish(feed)


class TicketHandler(Handler):
    async def get(self):
        ticket = self.database.get_ticket(**self.parse_url(ticket_id=int))
        user_data = self.database.get_user_data(user_id=ticket["user_id"])
        ticket["fullname"] = f"{user_data['firstname']} {user_data['lastname'][0]}."
        ticket["likes"] = len(ticket["likes"])
        ticket["dislikes"] = len(ticket["dislikes"])
        await self.finish(ticket)


class PointsHandler(Handler):
    async def get(self):
        points = self.database.get_points()
        await self.finish(points)


class TicketsHandler(Handler):
    async def get(self):
        user_id = self.get_user()
        if user_id:
            tickets = self.database.get_tickets(user_id=user_id, **self.parse_url(page=int))
            await self.finish(tickets)


class UserHandler(Handler):
    async def post(self):
        user_id = self.get_user()
        if user_id:
            user_data = self.database.get_user_data(user_id=user_id)
            user_data["user_id"] = user_id
            await self.finish(user_data)


class NewHandler(Handler):
    async def post(self):
        user_id = self.get_user()
        if user_id:
            files = self.request.files
            if not os.path.exists("uploads"):
                os.makedirs("uploads")
            uploads = {}
            uploaded = True
            for field in files:
                if uploaded:
                    for file in files[field]:
                        filename = file["filename"]
                        filedata = file["body"]
                        file_name, file_extension = os.path.splitext(filename)
                        if file_extension in self.upload_extensions and len(filedata) <= self.upload_max_size:
                            generated_name = hasher.md5(file_name) + "-" + hasher.md5(str(int(time.time() * 1000)))
                            uploads[f"uploads/{generated_name}{file_extension}"] = filedata
                        else:
                            uploaded = False
                            break
            if uploaded:
                for filename in uploads:
                    with open(filename, "wb") as file:
                        file.write(uploads[filename])
            else:
                await self.finish({"ticket_id": -1, "success": False, "uploaded": False})
            ret, ticket_id = self.database.create_ticket(user_id=user_id, files=list(uploads.keys()),
                                        **self.parse_data(
                                            title=str,
                                            text=str,
                                            category=int,
                                            point=self.point,
                                            icon=str
                                        ))
            if ret:
                await self.finish({"ticket_id": ticket_id, "success": True, "uploaded": True})
            else:
                await self.finish({"ticket_id": -1, "success": False, "uploaded": True})


class EditHandler(Handler):
    async def post(self):
        self.send_error(405)


class CommentHandler(Handler):
    async def post(self):
        user_id = self.get_user()
        if user_id:
            ret = self.database.comment(user_id=user_id,  **self.parse_data(ticket_id=int, text=str))
            await self.finish({"success": ret})


class LikeHandler(Handler):
    async def get(self):
        user_id = self.get_user()
        if user_id:
            ret, delta = self.database.like(user_id=user_id, **self.parse_url(ticket_id=int))
            await self.finish({"success": ret, "delta": delta})


class DislikeHandler(Handler):
    async def get(self):
        user_id = self.get_user()
        if user_id:
            ret, delta = self.database.dislike(user_id=user_id, **self.parse_url(ticket_id=int))
            await self.finish({"success": ret, "delta": delta})


class OfficialCommentHandler(Handler):
    async def post(self):
        if self.check_official():
            ret = self.database.comment(**self.parse_data(ticket_id=int, text=str))
            await self.finish({"success": ret})


class StatisticHandler(Handler):
    async def get(self):
        statistic = self.database.get_statistic()
        await self.finish(statistic)


class PinHandler(Handler):
    async def post(self):
        if self.check_official():
            ret, pinned = self.database.pin(**self.parse_data(ticket_id=int))
            await self.finish({"success": ret, "pinned": pinned})


class DeleteHandler(Handler):
    async def post(self):
        if self.check_official():
            ret = self.database.delete_ticket(**self.parse_data(ticket_id=int))
            await self.finish({"success": ret})


class ArchiveHandler(Handler):
    async def post(self):
        if self.check_official():
            ret = self.database.archive_ticket(**self.parse_data(ticket_id=int))
            await self.finish({"success": ret})

