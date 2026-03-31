# PROJECT DOCUMENTATION

## 1. Кратко о проекте

`Goida AI` это Flutter-клиент для финансового трекинга, который работает с backend API и поддерживает:

- авторизацию через Google
- восстановление сессии при повторном запуске
- профиль пользователя
- учет активов и счетов
- историю транзакций
- ручной ввод трат
- OCR-сканирование чеков с подтверждением результата
- AI-чат
- темы и локализацию
- отдельный demo mode

## 2. Что изменено в этой итерации

### 2.1 Сессия и bootstrap

Раньше вход через Google был одноразовым UI-сценарием.
Теперь реализовано:

- `AuthProvider.initialize()`
- восстановление локальных настроек и кэша профиля
- поддержка сохраненного backend session token, если backend его отдает
- `GoogleSignIn.signInSilently()` на старте приложения
- автоматическая загрузка данных после восстановления сессии

### 2.2 Загрузка реальных данных после входа

После успешной авторизации `GoidaApp` отслеживает изменение auth state и выполняет bootstrap:

- `BalanceProvider.load()`
- `TransactionProvider.load()`
- очистка временных данных чата и OCR

Для demo mode запускаются:

- `BalanceProvider.loadDemoData()`
- `TransactionProvider.loadDemoData()`

## 3. Архитектура

### Core

- `lib/core/api/api_client.dart`
  - обертка над `Dio`
  - поддержка `Authorization: Bearer <token>`
  - методы `get/post/put/delete`
- `lib/core/api/endpoints.dart`
  - все пути API
  - поддержка `API_BASE_URL` через `dart-define`
- `lib/core/config/google_auth_config.dart`
  - Google OAuth client ids через `dart-define`

### Data

- `lib/data/models/user.dart`
  - профиль пользователя
- `lib/data/models/balance.dart`
  - активы, spending overview, rates
- `lib/data/models/transaction.dart`
  - транзакция, включая `sourceAssetId/sourceAssetName`
- `lib/data/models/receipt_scan.dart`
  - OCR-модель чека и позиции чека
- `lib/data/repositories/finance_repository.dart`
  - слой backend-обращений для dashboard, assets, rates, transactions

### Presentation

#### Providers

- `AuthProvider`
  - логин
  - восстановление сессии
  - кэш профиля
  - сохранение темы и языка
- `BalanceProvider`
  - обзор активов и spending
  - demo mode / real mode
  - локальная корректировка счета после траты
- `TransactionProvider`
  - история транзакций
  - optimistic add expense
  - demo mode / real mode
- `ReceiptProvider`
  - загрузка фото чека
  - получение OCR-ответа с backend
  - хранение последнего результата сканирования
- `ChatProvider`
  - AI-чат

#### Screens / Widgets

- `LoginScreen`
- `HomeScreen`
- `HistoryScreen`
- `SettingsScreen`
- `ExpenseEntrySheet`
- `AssetSnapshotSheet`
- `ReceiptReviewSheet`
- `AccountPickerSheet`

## 4. Детали по потокам данных

### 4.1 Поток входа через Google

1. Пользователь нажимает кнопку входа.
2. `AuthProvider.signInWithGoogle()` получает `GoogleSignInAccount`.
3. Отправляется `POST /auth/google`.
4. Профиль и session token сохраняются локально.
5. Выполняется `GET /profile`.
6. `GoidaApp` видит новую auth session и загружает dashboard/history.

### 4.2 Поток старта приложения

1. `main()` вызывает `AuthProvider.initialize()` до `runApp()`.
2. Читаются локальные настройки и session cache.
3. Пытается восстановиться Google session.
4. Если пользователь найден, загружаются профиль, баланс и история.
5. Если пользователь новый, backend должен вернуть нули и пустые коллекции.

### 4.3 Ручная трата

1. Пользователь открывает `ExpenseEntrySheet`.
2. Выбирает категорию, валюту, сумму и счет списания.
3. `TransactionProvider.addExpense()` сразу добавляет локальную optimistic запись.
4. `FinanceRepository.createExpense()` вызывает `POST /transactions`.
5. Если backend ответил успешно:
   - pending local запись убирается
   - история перечитывается с backend
   - баланс перечитывается с backend
6. Если backend недоступен:
   - запись остается локально
   - `BalanceProvider.registerExpenseLocally()` уменьшает выбранный счет

### 4.4 OCR-чек

1. Пользователь нажимает `Чек`.
2. `ReceiptProvider.scanAndUploadReceipt()` открывает камеру.
3. Изображение уходит в `POST /receipt/process`.
4. Backend возвращает структуру чека.
5. Открывается `ReceiptReviewSheet`.
6. Пользователь проверяет:
   - магазин
   - сумму
   - категорию
   - счет списания
   - заметку
   - позиции чека
7. После подтверждения создается итоговая транзакция через `POST /transactions`.

## 5. Почему разделены demo mode и real mode

В прошлой версии fallback demo-данные могли подменять данные реального пользователя, если backend не отвечал.
Это плохо для финансового приложения.

Теперь логика такая:

- реальный пользователь получает реальные данные или пустые данные
- demo-данные показываются только если пользователь явно вошел в demo mode

## 6. Что backend должен поддержать обязательно

### 6.1 Для корректной первой авторизации

- создание пользователя по Google-логину
- отсутствие ошибок при пустом профиле активов и истории

### 6.2 Для транзакций

`POST /transactions` должен принимать:

- стандартные поля транзакции
- `sourceAssetId`
- `sourceAssetName`
- `receipt`

### 6.3 Для OCR

`POST /receipt/process` должен возвращать не просто success-флаг, а структурированные поля:

- `merchant`
- `total`
- `currency`
- `purchasedAt`
- `confidence`
- `items`
- желательно `suggestedCategory`, `note`, `rawText`, `id`

## 7. Проверка состояния проекта

На текущем состоянии в рабочем каталоге подтверждено:

```bash
flutter analyze
```

Ошибок анализатора нет.

`flutter test` запустить нельзя, потому что директории `test/` в проекте пока нет.

## 8. Полезные файлы

- `README.md` — общее описание приложения и запуска
- `API_DOCUMENTATION.md` — backend-контракт
- `lib/presentation/providers/auth_provider.dart` — восстановление сессии
- `lib/presentation/widgets/receipt_review_sheet.dart` — подтверждение OCR
- `lib/presentation/widgets/expense_entry_sheet.dart` — ручной ввод траты со счетом
