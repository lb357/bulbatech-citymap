import hashlib


def sha256(s: str):
    return hashlib.sha256(s.encode("ascii")).hexdigest()


def md5(s: str):
    return hashlib.md5(s.encode("ascii")).hexdigest()