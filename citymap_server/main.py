import logger
import logging
import config
from handlers import *
import tornado
import database


def make_app():
    config_data, cookie_secret = config.load_config()
    kwargs = {"database": database.DB()}|config_data
    handlers = {
        r"/": MainHandler,
        r"/legal": LegalHandler,
        r"/official": OfficialHandler,
        r"/official/login": OfficialLoginHandler,
        r"/api/signup": SignUpHandler,
        r"/api/login": LogInHandler,
        r"/api/logout": LogOutHandler,
        r"/api/recover": RecoverHandler,
        r"/api/status": StatusHandler,
        r"/api/feed": FeedHandler,
        r"/api/ticket": TicketHandler,
        r"/api/points": PointsHandler,
        r"/api/tickets": TicketsHandler,
        r"/api/user": UserHandler,
        r"/api/new": NewHandler,
        r"/api/edit": EditHandler,
        r"/api/comment": CommentHandler,
        r"/api/like": LikeHandler,
        r"/api/dislike": DislikeHandler,
        r"/api/official-comment": OfficialCommentHandler,
        r"/api/statistics": StatisticHandler,
        r"/api/pin": PinHandler,
        r"/api/delete": DeleteHandler,
        r"/api/archive": ArchiveHandler
    }
    path = os.path.dirname(__file__)
    static_handlers = [
        ("/uploads/(.*)", tornado.web.StaticFileHandler, {"path": os.path.join(path, "uploads")}),
        ("/static/(.*)", tornado.web.StaticFileHandler, {"path": os.path.join(path, "static")})
    ]
    return tornado.web.Application(
        [(url, handlers[url], kwargs) for url in handlers] + static_handlers,
        cookie_secret=cookie_secret)


if __name__ == "__main__":
    try:
        logger.init_logger("debug")
        logging.info("BulbaTech-citymap server starting...")
        app = make_app()
        logging.info("BulbaTech-citymap server started!")
        app.listen(8888)
        tornado.ioloop.IOLoop.current().start()
    except Exception as exception:
        logging.critical(f"{exception} / Server stopped!")