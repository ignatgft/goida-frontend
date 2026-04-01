# Goida AI - Frontend

📱 Мобильное приложение для управления личными финансами с AI-ассистентом

[![Flutter](https://img.shields.io/badge/Flutter-3.11+-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue?logo=dart)](https://dart.dev)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green)](https://flutter.dev)

## 🚀 Возможности

### 💰 Управление финансами
- Учет активов и транзакций
- Множественные счета (банк, наличные, крипто)
- Категории расходов и доходов
- Месячный бюджет и отслеживание трат

### 🤖 AI-ассистент
- Умный чат для финансовых консультаций
- Анализ расходов и рекомендации
- Распознавание чеков (OCR)
- Контекстная память разговоров

### 💬 Мессенджер
- Общение с другими пользователями
- Поддержка изображений и файлов
- Ответы на сообщения (как в Telegram)
- Real-time уведомления

### ⚙️ Настройки
- Персонализация профиля
- Выбор валюты и языка (RU/EN)
- Темная/Светлая тема
- Управление уведомлениями

## 📦 Установка

### Требования
- Flutter 3.11 или выше
- Dart 3.0 или выше
- Android Studio / Xcode

### 1. Клонирование репозитория

```bash
git clone https://github.com/ignatgft/goida-frontend.git
cd goida-frontend
```

### 2. Установка зависимостей

```bash
flutter pub get
```

### 3. Настройка API

Откройте файл `lib/core/api/endpoints.dart` и укажите URL вашего backend:

```dart
static const String _serverIp = "http://YOUR_BACKEND_IP:8080/api";
```

Или используйте `--dart-define`:

```bash
flutter run --dart-define=API_BASE_URL=http://YOUR_IP:8080/api
```

### 4. Запуск приложения

```bash
# Android
flutter run

# iOS
flutter run

# Web
flutter run -d chrome

# Release build
flutter build apk --release
flutter build ios --release
```

## 🏗️ Архитектура

```
lib/
├── core/                    # Ядро приложения
│   ├── api/                 # API клиент и endpoints
│   ├── config/              # Конфигурация (Google Auth и т.д.)
│   ├── theme/               # Темы оформления
│   └── utils/               # Утилиты и formatter
│
├── data/                    # Слой данных
│   ├── models/              # Модели данных
│   └── repositories/        # Репозитории для работы с API
│
├── presentation/            # UI слой
│   ├── providers/           # State management (Provider)
│   ├── screens/             # Экраны приложения
│   └── widgets/             # Переиспользуемые виджеты
│
├── l10n/                    # Локализация (RU/EN)
├── app.dart                 # Главный виджет
└── main.dart                # Точка входа
```

## 📱 Основные экраны

| Экран | Описание |
|-------|----------|
| **Home** | Баланс, активы, быстрые действия |
| **Messenger** | Чат с пользователями |
| **AI Chat** | Чат с AI-ассистентом |
| **Statistics** | Графики и аналитика |
| **Settings** | Настройки профиля и приложения |

## 🛠️ State Management

Приложение использует **Provider** для управления состоянием:

- `AuthProvider` - Аутентификация и сессия
- `BalanceProvider` - Балансы и активы
- `TransactionProvider` - Транзакции
- `ChatProvider` - AI чат
- `MessengerProvider` - Мессенджер
- `SettingsProvider` - Настройки пользователя

## 🔧 Конфигурация

### Google Sign-In

Настройте Google OAuth в `lib/core/config/google_auth_config.dart`:

```dart
webClientId: 'YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com',
```

### Backend API

| Переменная | Описание | Пример |
|------------|----------|--------|
| `API_BASE_URL` | URL backend API | `http://192.168.1.100:8080/api` |

## 📚 Зависимости

Основные пакеты:

```yaml
dependencies:
  provider: ^6.1.2          # State management
  dio: ^5.4.1               # HTTP client
  google_sign_in: ^6.2.1    # Google authentication
  image_picker: ^1.0.7      # Image selection
  shared_preferences: ^2.5.3 # Local storage
  web_socket_channel: ^2.4.0 # WebSocket support
  flutter_localizations:    # i18n support
  intl: ^0.20.2            # Internationalization
```

## 🌐 Локализация

Приложение поддерживает два языка:

- 🇷🇺 Русский (по умолчанию)
- 🇺🇸 English

Файлы локализации:
- `lib/l10n/app_ru.arb` - Русский
- `lib/l10n/app_en.arb` - English

## 🧪 Тестирование

```bash
# Запустить тесты
flutter test

# Анализ кода
flutter analyze

# Форматирование
dart format .
```

## 📱 Сборка

### Android

```bash
# Debug APK
flutter build apk

# Release APK
flutter build apk --release

# App Bundle (для Google Play)
flutter build appbundle --release
```

### iOS

```bash
# Build for iOS
flutter build ios --release

# Archive для App Store Connect
# Открыть ios/Runner.xcworkspace в Xcode
# Product → Archive
```

## 🤝 Вклад в проект

1. Fork репозиторий
2. Создайте feature branch (`git checkout -b feature/amazing-feature`)
3. Commit изменения (`git commit -m 'Add amazing feature'`)
4. Push в branch (`git push origin feature/amazing-feature`)
5. Откройте Pull Request

## 📄 Лицензия

Этот проект распространяется под лицензией MIT.

## 📞 Контакты

- **Email**: support@goida.ai
- **Telegram**: @goida_support
- **Backend**: [goida-backend](https://github.com/ignatgft/goida-backend)

## 🙏 Благодарности

- [Flutter](https://flutter.dev) - Кроссплатформенный фреймворк
- [Provider](https://pub.dev/packages/provider) - State management
- [Dio](https://pub.dev/packages/dio) - HTTP клиент
- [Google Sign In](https://pub.dev/packages/google_sign_in) - OAuth аутентификация

---

**Goida AI** © 2024. Все права защищены.
