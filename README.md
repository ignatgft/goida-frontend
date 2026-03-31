# Goida AI

`Goida AI` это Flutter-приложение для учета личных финансов с Google-авторизацией, backend-синхронизацией, AI-чатом и подробным OCR-сканированием чеков.

## Что приложение умеет сейчас

- вход через Google с автоматическим восстановлением сессии после перезапуска приложения
- синхронизация профиля пользователя с backend
- загрузка профиля, активов, баланса и истории транзакций с backend после входа
- корректное поведение для нового пользователя: нулевой баланс, пустая история, пустой список активов
- ручное добавление трат с выбором счета списания
- создание, редактирование и удаление активов
- сканирование чека через камеру с отправкой в OCR backend
- экран подтверждения результата OCR перед созданием траты
- отображение позиций чека, точности OCR и даты покупки
- AI-чат через backend
- выбор темы и языка
- отдельный demo mode, не смешанный с реальными backend-данными

## Основные пользовательские сценарии

### 1. Вход через Google и восстановление сессии

1. Пользователь входит через Google.
2. Приложение отправляет Google-токены в `POST /auth/google`.
3. Backend возвращает профиль пользователя и при необходимости session token.
4. Приложение сохраняет локально:
   - профиль пользователя
   - optional session token
   - выбранную тему
   - выбранный язык
5. При следующем запуске приложение:
   - восстанавливает локальные настройки
   - пытается восстановить Google-сессию через `signInSilently()`
   - обновляет профиль через `/profile`
   - автоматически загружает баланс и историю транзакций

### 2. Новый пользователь

Если пользователь входит впервые, backend должен автоматически создать запись пользователя.
Клиент ожидает:

- `GET /profile` -> профиль пользователя
- `GET /dashboard/overview` -> пустые активы и нулевые расходы
- `GET /transactions` -> пустой массив

Для настоящих авторизованных пользователей приложение больше не подставляет demo-финансы вместо backend-данных.

### 3. Ручное добавление траты

Форма добавления траты теперь содержит:

- название
- категорию
- валюту
- сумму
- заметку
- счет, с которого была потрачена сумма

При сохранении трата отправляется в `POST /transactions`.
Если backend недоступен, запись остается в локальном UI и выбранный счет корректируется локально.

### 4. Сканирование чека

Теперь это двухшаговый процесс:

1. Фото чека отправляется в `POST /receipt/process`
2. Результат OCR показывается в отдельном окне подтверждения

На экране подтверждения можно проверить и изменить:

- магазин / заголовок траты
- сумму
- категорию
- валюту
- заметку
- счет списания
- позиции из чека

После подтверждения создается обычная транзакция через `POST /transactions`, а данные OCR при необходимости прикладываются к ней как metadata.

## Какие backend-endpoint'ы реально используются

- `POST /auth/google`
- `GET /profile`
- `POST /profile/avatar`
- `GET /dashboard/overview`
- `GET /rates/fiat`
- `GET /rates/crypto`
- `POST /assets`
- `PUT /assets/{assetId}`
- `DELETE /assets/{assetId}`
- `GET /transactions`
- `POST /transactions`
- `POST /chat`
- `POST /receipt/process`

## Важные правила для backend

- при первом входе через Google backend должен создавать пользователя автоматически
- для нового пользователя backend должен возвращать пустые коллекции и нули, а не ошибку
- если backend выдает отдельный session token, клиент умеет сохранить его локально
- `POST /transactions` должен принимать optional поля:
  - `sourceAssetId`
  - `sourceAssetName`
  - `receipt`
- `POST /receipt/process` должен возвращать структурированный OCR-ответ, а не только `success: true`

## Переменные окружения

### Базовый URL backend

```bash
flutter run --dart-define=API_BASE_URL=https://your-domain.com/api
```

Если `API_BASE_URL` не передан, используются значения по умолчанию:

- Web/Desktop: `http://localhost:8080/api`
- Android emulator: `http://10.0.2.2:8080/api`

### Google OAuth

```bash
flutter run \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
```

Для Flutter web:

```bash
flutter run -d chrome \
  --dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
```

## Локальный запуск

```bash
flutter pub get
flutter run
```

## Что проверено в рабочем каталоге

Проверено командой:

```bash
flutter analyze
```

Анализатор ошибок не нашел.

`flutter test` сейчас не запускается, потому что в проекте пока нет директории `test/`.

## Структура проекта

```text
lib/
  core/
    api/
    config/
    theme/
    utils/
  data/
    models/
    repositories/
  presentation/
    providers/
    screens/
    widgets/
```

## Ключевые точки реализации

- `AuthProvider` отвечает за восстановление сессии, кэш профиля и локальные настройки
- `GoidaApp` автоматически подгружает данные при смене auth state
- `BalanceProvider` разделяет real mode и demo mode
- `TransactionProvider` поддерживает optimistic UI для трат
- `ReceiptProvider` возвращает структурированный OCR-результат
- `ReceiptReviewSheet` подтверждает чек перед финальным сохранением в историю

## Дополнительная документация

- `API_DOCUMENTATION.md` — подробный backend-контракт
- `PROJECT_DOCUMENTATION.md` — архитектура и внутренние детали реализации
- `APP_PRESENTATION.md` — краткая презентация приложения
