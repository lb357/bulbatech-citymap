# Bulbatech-citymap
Digital platform for collecting and visualizing citizens' ideas for the development of public spaces.

Цифровая платформа для сбора и визуализации предложений граждан по развитию общественных пространств.

## 🚀 Quick Start
A small guideline on how to setup the project / Краткое руководство по настройке проекта

### Requirements / Зависимости

- Flutter (3.38.7+)
- Android SDK 34+
- VScode Flutter package
- Python (3.10+)


Clone the repo / Скачать репозиторий
```bash
git clone https://github.com/lb357/bulbatech-citymap
```

### Сlient / Клиент

1. Setup the flutter / Настроить flutter
```bash
cd bulbatech-citymap/citymap_client
flutter clean
flutter create .
flutter pub get
```

2. Change connectUrl in `utils/server.dart` on **19 line** / Изменить connectUrl в `utils/server.dart` на **19 строке**

```dart
...
19. final String connectUrl = "<your-service-url>"
...
```

3. Run the project / Запустить проект
```bash
flutter run --release
```

### Server / Сервер

1. Install requirements / Установить зависимости
```bash
pip install tornado
```
Ubuntu Server
```bash
sudo apt update
sudo apt install python3-tornado
```

2. Place client release files in `citymap_server/static` directory / Поместить релизные клиентские файлы в `citymap_server/static`

3. Run the server / Запустить сервер
```bash
python main.py
```
optionally, systemd service can be used / опционально может использоваться systemd служба
(see / см. `citymap_server/bulbatech-citymap.service`)

## 👥 Authors / Авторы
BulbaTech team:
- **Leonid Briskindov** / **Леонид Брискиндов** - [Github](https://github.com/lb357)
- **Michail Daineko** / **Михаил Дайнеко** - [Github](https://github.com/WhatTheBear)
- **Danil Chex** / **Даниил Чех** - [Github](https://github.com/Danilka1234567)
- **Andrei Zheltov** / **Андрей Желтов** - [GitHub](https://github.com/Twoxkkkk)
