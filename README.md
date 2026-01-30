# Bulbatech-citymap

A small guideline on how to setup the project

## 🚀 Quick Start

### Requirements

- Flutter (3.38.7+)
- Android SDK 34+
- VScode Flutter package
- Python (3.11+)



### Installation

### Server


1. Clone the repo:
```bash
git clone https://github.com/lb357/bulbatech-citymap
cd citymap_server
```

2. Install requirements:
```bash
pip install tornado
```

3. Run the project:
```bash
python main.py
```

### Сlient


1. Clone the repo:
```bash
git clone https://github.com/lb357/bulbatech-citymap
cd citymap_client
```

2. Setup the flutter:
```bash
flutter clean
flutter create .
flutter pub get
```

3. Change connectUrl in utils/server.dart on **19 line**

```dart
...
19. final String coonectUrl = "<your-service-url>"
...
```

5. Run the project:
```bash
flutter run --release
```

## 👥 Authors

- **Leonid Briskindov** - [Github](https://github.com/lb357)
- **Michail Daineko** - [Github](https://github.com/WhatTheBear)
- **Danil Chex** - [Github](https://github.com/Danilka1234567)
- **Andrei Zheltov** - [GitHub](https://github.com/Twoxkkkk)
