# API Documentation

Документ описывает актуальный backend-контракт для Flutter-приложения `Goida AI` после доработки сессии, загрузки пользовательских данных, выбора счета списания и подробного OCR-чека.

## 1. Base URL

По умолчанию клиент использует:

- Web / Desktop: `http://localhost:8080/api`
- Android Emulator: `http://10.0.2.2:8080/api`

Можно переопределить через:

```bash
--dart-define=API_BASE_URL=https://your-domain.com/api
```

## 2. Общие правила backend

### 2.1 Новый пользователь

Если пользователь впервые вошел через Google, backend должен:

1. создать пользователя
2. вернуть профиль
3. вернуть пустые данные по активам и истории

Ожидаемое поведение для нового пользователя:

- `GET /profile` -> профиль пользователя
- `GET /dashboard/overview` -> `assets: []`, `spent: 0`, `budget: 0`
- `GET /transactions` -> `items: []`

### 2.2 Сессия

Клиент поддерживает два варианта:

1. backend не выдает отдельный session token
   - тогда приложение восстанавливает Google-сессию через `signInSilently()`
   - затем снова синхронизируется через `POST /auth/google`
2. backend выдает отдельный session token
   - приложение сохранит его локально и будет слать в `Authorization: Bearer <token>`

Если backend выдает токен, используйте один из форматов:

```json
{
  "sessionToken": "token-value"
}
```

или

```json
{
  "token": "token-value"
}
```

или

```json
{
  "authToken": "token-value"
}
```

или

```json
{
  "session": {
    "token": "token-value",
    "expiresAt": "2026-03-30T12:00:00.000Z"
  }
}
```

## 3. Auth

### POST `/auth/google`

Синхронизация входа через Google с backend.

Request:

```json
{
  "idToken": "google-id-token",
  "accessToken": "google-access-token",
  "email": "ignat@example.com",
  "displayName": "Ignat",
  "photoUrl": "https://lh3.googleusercontent.com/example"
}
```

Recommended response:

```json
{
  "success": true,
  "user": {
    "id": "user_123",
    "displayName": "Ignat",
    "email": "ignat@example.com",
    "avatarUrl": "https://cdn.goida.ai/avatars/user_123.jpg"
  },
  "session": {
    "token": "session-token-123",
    "expiresAt": "2026-03-30T12:00:00.000Z"
  }
}
```

## 4. Profile

### GET `/profile`

Возвращает профиль текущего пользователя.

Response:

```json
{
  "id": "user_123",
  "displayName": "Ignat",
  "email": "ignat@example.com",
  "avatarUrl": "https://cdn.goida.ai/avatars/user_123.jpg"
}
```

### POST `/profile/avatar`

Content-Type:

- `multipart/form-data`

Form fields:

- `file`: изображение

Response:

```json
{
  "success": true,
  "avatarUrl": "https://cdn.goida.ai/avatars/user_123.jpg"
}
```

## 5. Dashboard

### GET `/dashboard/overview?period=month`

Главная сводка для домашнего экрана.

Response для пользователя с данными:

```json
{
  "baseCurrency": "USD",
  "periodLabel": "This month",
  "assets": [
    {
      "id": "asset_1",
      "name": "Main Card",
      "type": "bank_account",
      "currency": "USD",
      "amount": 2450.75
    },
    {
      "id": "asset_2",
      "name": "Cash Wallet",
      "type": "cash",
      "currency": "KZT",
      "amount": 72000
    }
  ],
  "spending": {
    "spent": 1240,
    "budget": 2200
  }
}
```

Response для нового пользователя:

```json
{
  "baseCurrency": "USD",
  "periodLabel": "This month",
  "assets": [],
  "spending": {
    "spent": 0,
    "budget": 0
  }
}
```

### Поля

- `baseCurrency`: базовая валюта обзора
- `periodLabel`: человекочитаемое название периода
- `assets`: счета / активы пользователя
- `spending.spent`: фактически потрачено
- `spending.budget`: бюджет периода

## 6. Assets

### POST `/assets`

Request:

```json
{
  "period": "month",
  "name": "Main Card",
  "type": "bank_account",
  "currency": "USD",
  "amount": 2450.75
}
```

### PUT `/assets/{assetId}`

Request:

```json
{
  "period": "month",
  "name": "Updated Card",
  "type": "bank_account",
  "currency": "USD",
  "amount": 2100.0
}
```

### DELETE `/assets/{assetId}`

Response:

```json
{
  "success": true,
  "deletedId": "asset_1"
}
```

## 7. Rates

### GET `/rates/fiat?base=USD`

```json
{
  "baseCurrency": "USD",
  "rates": {
    "USD": 1,
    "EUR": 0.92,
    "KZT": 503.7
  }
}
```

### GET `/rates/crypto?fiat=USD&symbols=BTC,ETH,SOL`

```json
{
  "quoteCurrency": "USD",
  "prices": {
    "BTC": 67250,
    "ETH": 3480,
    "SOL": 158
  }
}
```

## 8. Transactions

### GET `/transactions`

Optional query params:

- `category`
- `period`
- `limit`
- `cursor`

Response:

```json
{
  "items": [
    {
      "id": "tx_1",
      "title": "Magnum",
      "amount": 42.8,
      "currency": "USD",
      "category": "food",
      "type": "expense",
      "createdAt": "2026-03-25T17:10:00.000Z",
      "note": "Groceries and daily essentials",
      "sourceAssetId": "asset_1",
      "sourceAssetName": "Main Card",
      "receipt": {
        "id": "receipt_991",
        "confidence": 0.98
      }
    }
  ],
  "meta": {
    "total": 1,
    "nextCursor": null
  }
}
```

Response для нового пользователя:

```json
{
  "items": [],
  "meta": {
    "total": 0,
    "nextCursor": null
  }
}
```

### POST `/transactions`

Используется для ручной траты и для подтвержденного OCR-чека.

Request:

```json
{
  "title": "Coffee",
  "amount": 4.8,
  "currency": "USD",
  "category": "food",
  "type": "expense",
  "createdAt": "2026-03-25T18:40:00.000Z",
  "note": "Flat white",
  "sourceAssetId": "asset_1",
  "sourceAssetName": "Main Card",
  "receipt": {
    "id": "receipt_991",
    "merchant": "Costa Coffee",
    "total": 4.8,
    "currency": "USD",
    "purchasedAt": "2026-03-25T18:38:00.000Z",
    "confidence": 0.98,
    "category": "food",
    "items": [
      {
        "title": "Flat white",
        "price": 4.8,
        "quantity": 1
      }
    ]
  }
}
```

Recommended response:

```json
{
  "success": true,
  "transaction": {
    "id": "tx_120",
    "title": "Coffee",
    "amount": 4.8,
    "currency": "USD",
    "category": "food",
    "type": "expense",
    "createdAt": "2026-03-25T18:40:00.000Z",
    "note": "Flat white",
    "sourceAssetId": "asset_1",
    "sourceAssetName": "Main Card"
  }
}
```

### Поля транзакции

- `title`: название операции
- `amount`: сумма операции
- `currency`: валюта операции
- `category`: категория
- `type`: `expense | income | transfer`
- `createdAt`: дата и время
- `note`: необязательная заметка
- `sourceAssetId`: ID счета, с которого списали деньги
- `sourceAssetName`: название счета для быстрого отображения в UI
- `receipt`: необязательные метаданные OCR

### GET `/transactions/categories`

Поддерживается контрактно, но текущий клиент пока использует локальный enum категорий.

## 9. AI Chat

### POST `/chat`

Request:

```json
{
  "message": "How much did I spend on food this month?"
}
```

Response:

```json
{
  "text": "You spent approximately $420 on food this month.",
  "role": "assistant",
  "timestamp": "2026-03-25T16:20:00.000Z"
}
```

## 10. Receipt OCR

### POST `/receipt/process`

Загружает фото чека и возвращает OCR-разбор. Сам endpoint не обязан создавать транзакцию. Он только извлекает структуру чека.

Content-Type:

- `multipart/form-data`

Form fields:

- `file`: изображение чека

Recommended response:

```json
{
  "success": true,
  "receipt": {
    "id": "receipt_991",
    "merchant": "Magnum",
    "total": 450.0,
    "currency": "KZT",
    "purchasedAt": "2026-03-25T12:00:00.000Z",
    "confidence": 0.98,
    "suggestedCategory": "food",
    "note": "Detected by OCR",
    "rawText": "MAGNUM ...",
    "items": [
      {
        "title": "Milk",
        "price": 420.0,
        "quantity": 1
      },
      {
        "title": "Bread",
        "price": 30.0,
        "quantity": 1
      }
    ]
  }
}
```

### Что делает клиент с этим ответом

Клиент:

1. показывает экран подтверждения OCR
2. дает выбрать счет списания
3. дает исправить сумму / категорию / заметку
4. потом отправляет итоговую трату в `POST /transactions`

## 11. Минимальные backend-требования

Фронтенд реально использует:

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

## 12. Что backend должен отдавать особенно аккуратно

### Для успешного UX

- не возвращать demo-данные для настоящего пользователя
- не возвращать 500 для нового пользователя с пустой историей
- не требовать обязательного наличия активов перед первой транзакцией
- сохранять и возвращать `sourceAssetId/sourceAssetName`, если они пришли
- хранить receipt metadata, если они пришли в `receipt`

### Для восстановления сессии

Желательно вернуть session token в `POST /auth/google`, но это необязательно. Если его нет, приложение попытается восстановить Google-сессию и синхронизироваться заново.
