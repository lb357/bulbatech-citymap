import logging
import os
import time

logging_levels = {
    "info": logging.INFO,
    "warn": logging.WARN,
    "error": logging.ERROR,
    "critical": logging.CRITICAL,
    "debug": logging.DEBUG
}


def init_logger(logging_level: str):
    if not os.path.exists("logs"):
        os.makedirs("logs")
    logging.basicConfig(
        level=logging_levels[logging_level.lower()],
        format="[%(asctime)s] %(levelname)s / %(funcName)s (%(module)s): %(message)s",
        datefmt='%d.%m.%Y %H:%M:%S',
        handlers=(
            logging.FileHandler(filename=f"logs/{time.time()}.txt", mode="w"),
            logging.StreamHandler()
        )
    )
