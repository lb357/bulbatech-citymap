import json
import logging
import random
import hasher
import time


VERSION = 26011

def load_config():
    logging.info(f"Config loading...")
    try:
        config: dict = {}
        with open("config.json", "r", encoding="UTF-8") as file:
            config = json.loads(file.read())
        with open(".OFFICIAL_TOKEN", "r", encoding="UTF-8") as file:
            config["official_token"] = file.read()
        with open(".COOKIE_SECRET", "r", encoding="UTF-8") as file:
            cookie_secret = file.read()
        config["version"] = VERSION
        address, port = config.pop("address"), config.pop("port")
        logging.info(f"Config loaded!")
        return config, cookie_secret, address, port
    except Exception as exception:
        logging.warning(f"{exception} / Using default config...")
        return save_default_config()

def save_default_config():
    config = {
        "official_place": "<REGION>",
        "official_name": "<DEPARTMENT>",
        "upload_max_size": 10485760,
        "upload_extensions": [".jpg", ".jpeg", ".png", ".fbx", ".mp3", ".mp4", ".doc", ".docx", ".pdf"],
        "address": "0.0.0.0",
        "port": 8888
    }
    with open("config.json", "w", encoding="UTF-8") as file:
        file.write(json.dumps(config, indent=4))
    with open(".OFFICIAL_TOKEN", "w", encoding="UTF-8") as file:
        config["official_token"] = hasher.sha256(str(random.random()))+hasher.sha256(str(time.time()))
        file.write(config["official_token"])
    with open(".COOKIE_SECRET", "w", encoding="UTF-8") as file:
        cookie_secret = hasher.sha256(str(random.random()))+hasher.sha256(str(time.time()/2))
        file.write(cookie_secret)
    config["version"] = VERSION
    address, port = config.pop("address"), config.pop("port")
    logging.info(f"Default config loaded!")
    return config, cookie_secret, address, port
