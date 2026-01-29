import logger
import logging
import config
from handlers import *
import tornado
import database


def make_app(config_data_, cookie_secret_):
    kwargs = {"database": database.DB()}|config_data_
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
        r"/api/statistic": StatisticHandler,
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
        cookie_secret=cookie_secret_)


if __name__ == "__main__":
    try:
        logger.init_logger("debug")
        logging.info("BulbaTech-citymap server starting...")
        config_data, cookie_secret, address, port = config.load_config()
        app = make_app(config_data, cookie_secret)
        logging.info("BulbaTech-citymap server started!")
        app.listen(port=port, address=address)
        tornado.ioloop.IOLoop.current().start()
    except Exception as exception:
        logging.critical(f"{exception} / Server stopped!")
