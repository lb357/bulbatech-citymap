# Protocol


Functions gets user_id by access_token from signed cookie
|method|endpoint|request url args| request json body | response json body | comment |
|-|-|-|-|-|-|
| POST | /api/signup |  | {email: str, password: str, lastname: str, firstname: str, patronymic:str, birthdate: str, snils: str} | {"success": bool} | datetime for birthdate in %d.%m.%Y; calls /api/login |
| POST | /api/login |  | {email: str, password: str} | {"success": bool} | set access_token in signed cookie |
| POST | /api/logout |  | | {"success": bool} | |
| GET | /api/status |  | | {"credits": {...}, "product": str, "repository": str, "version": int, timestamp: int} | for check app version |
| POST | /api/recover | | | | todo |
| GET | /api/feed | ?page=int&category=int | | {"page": int, "category": int, "tickets": [{"title": str, "icon": str, "ticket_id": int}, ...]} | |
| GET | /api/ticket | ?ticket_id=int | | {"ticket_id": int, "icon": str(UNICODE), "title": str, "category": int, "text": str, "files": [str(url), ...] "user_id": int, "lastname": str, "firstname": str, "patronymic": str, "likes": [int, ...] (user_id), "dislikes": [int, ...] (user_id), "official_comment": str, "comments": [ {"user_id": int, "text": str}, ... ], "point": [float, float], "pinned": bool, "timestamp": int, "archive": bool} | |
| GET | /api/points | | | {"points": [ ["point": [float, float], "ticket_id": int], ...]} | |
| GET | /api/tickets | ?page=int | | {"page": int, "user_id": int, "tickets": [{"title": str, "icon": str, "ticket_id": int}, ...]} | |
| POST | /api/user | | | {"email": str, "lastname": str, "firstname": str, "patronymic": str, "birthdate": str(date), "snils": int, "user_id": int} | |
| POST | /api/new | | {"title": str, "text": str, "category": int, "point": [float, float], "icon": str} | {"ticket_id": int, "success": bool, "uploaded": bool} | files can be added to request body |
| POST | /api/edit | | | | todo |
| POST | /api/comment | | {"ticket_id": int, "text": str} | {"success": bool} |  |
| GET | /api/like | ?ticket_id=int | | {"success": bool, "delta": int} | |
| GET | /api/dislike | ?ticket_id=int | | {"success": bool, "delta": int} | |
