# Frontend Documentation - Goida AI

## Обзор

Frontend приложения Goida AI реализован на Flutter 3.11+. Это кроссплатформенное мобильное приложение для управления личными финансами с поддержкой iOS, Android и Web.

## Технологии

- **Flutter** 3.11+
- **Dart** 3.0+
- **Provider** для управления состоянием
- **Dio** для HTTP запросов
- **Google Sign In** для аутентификации
- **Image Picker** для работы с изображениями
- **Shared Preferences** для локального хранения
- **Flutter Intl** для локализации

## Структура проекта

```
lib/
├── core/                   # Базовые компоненты
│   ├── api/
│   │   ├── api_client.dart
│   │   └── endpoints.dart
│   ├── config/
│   │   └── google_auth_config.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── formatter.dart
├── data/
│   ├── models/
│   │   ├── balance.dart
│   │   ├── transaction.dart
│   │   ├── user.dart
│   │   └── receipt_scan.dart
│   └── repositories/
│       └── finance_repository.dart
├── presentation/
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── balance_provider.dart
│   │   ├── transaction_provider.dart
│   │   ├── chat_provider.dart
│   │   └── receipt_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── history_screen.dart
│   │   ├── chat_screen.dart
│   │   ├── settings_screen.dart
│   │   └── login_screen.dart
│   ├── widgets/
│   │   ├── balance_card.dart
│   │   ├── transaction_item.dart
│   │   ├── action_chip.dart
│   │   └── ...
│   └── l10n/
│       └── app_localizations.dart
├── l10n/
│   ├── app_localizations.dart
│   ├── app_localizations_ru.dart
│   └── app_localizations_en.dart
├── app.dart
└── main.dart
```

## Конфигурация

### pubspec.yaml

```yaml
name: demo2
description: "Goida AI - Financial Management"
version: 0.1.0+1

environment:
  sdk: ^3.11.3

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2
  dio: ^5.4.1
  provider: ^6.1.2
  google_sign_in: ^6.2.1
  image_picker: ^1.0.7
  shared_preferences: ^2.5.3
```

### API Конфигурация

```dart
// lib/core/api/endpoints.dart
class Endpoints {
  static const String _serverIp = "http://57.151.105.173:8080/api";
  
  static const String dashboardOverview = "/dashboard/overview";
  static const String assets = "/assets";
  static const String assetBalanceSummary = "/assets/balance-summary";
  static const String transactions = "/transactions";
  // ... другие эндпоинты
}
```

## Модели данных

### SupportedCurrency

Перечисление всех поддерживаемых валют (60+ фиатных, 250+ криптовалют).

```dart
enum SupportedCurrency {
  usd, eur, rub, kzt, gbp, jpy, cny,
  btc, eth, usdt, usdc, bnb, xrp, sol,
  // ... еще 250+ криптовалют
}
```

### TrackedAsset

Модель актива пользователя.

```dart
class TrackedAsset {
  final String id;
  final String name;
  final AssetType type;
  final SupportedCurrency currency;
  final double amount;
  final double currentValue;
  
  // Методы fromJson, toJson, copyWith
}
```

### BalanceOverview

Общая сводка баланса.

```dart
class BalanceOverview {
  final SupportedCurrency baseCurrency;
  final String periodLabel;
  final List<TrackedAsset> assets;
  final SpendingOverview spending;
  
  double get netBalance;  // Активы - расходы
}
```

### AssetBalanceSummary

Сводка по активам (новый функционал).

```dart
class AssetBalanceSummary {
  final double totalAssets;      // Общий баланс активов
  final double spentBalance;     // Потраченный баланс
  final SupportedCurrency baseCurrency;
  final String periodLabel;
  
  double get netBalance;         // Чистый баланс
  double get spendingPercent;    // Процент расходов
}
```

## Providers (State Management)

### BalanceProvider

Управляет состоянием баланса, активов и курсов валют.

```dart
class BalanceProvider extends ChangeNotifier {
  final FinanceRepository repo;
  
  BalanceOverview? overview;
  AssetBalanceSummary? assetBalanceSummary;
  FiatRates? fiatRates;
  CryptoMarketRates? cryptoRates;
  
  Future<void> load();
  void selectCurrency(SupportedCurrency currency);
  void selectPeriod(TrackerPeriod period);
  Future<bool> addAsset({...});
  Future<bool> updateAsset({...});
  Future<bool> deleteAsset(String assetId);
  
  // Геттеры для UI
  double get totalAssetsBalance;
  double get spentAssetsBalance;
  double get netAssetsBalance;
}
```

### TransactionProvider

Управляет состоянием транзакций.

```dart
class TransactionProvider extends ChangeNotifier {
  final FinanceRepository repo;
  
  List<TransactionModel> transactions;
  TransactionCategory? selectedCategory;
  
  Future<void> load();
  Future<bool> createExpense({...});
  Future<bool> updateTransaction({...});
  Future<bool> deleteTransaction(String id);
}
```

### AuthProvider

Управляет аутентификацией пользователя.

```dart
class AuthProvider extends ChangeNotifier {
  final AuthService authService;
  
  User? user;
  bool isAuthenticated;
  
  Future<bool> signInWithGoogle();
  Future<void> signOut();
}
```

### ReceiptProvider

Обрабатывает сканирование и загрузку чеков.

```dart
class ReceiptProvider extends ChangeNotifier {
  final FinanceRepository repo;
  
  bool isProcessing;
  ReceiptScanResult? currentReceipt;
  
  Future<ReceiptScanResult?> scanAndUploadReceipt(context);
}
```

## Экраны

### HomeScreen

Главный экран с балансом и быстрыми действиями.

**Компоненты:**
- BalanceCard - карточка с балансом
- ActionChip - кнопки быстрых действий
- Asset list - список активов

### HistoryScreen

Экран истории транзакций.

**Функции:**
- Список транзакций с пагинацией
- Фильтрация по категориям
- Поиск по транзакциям

### ChatScreen

Экран ИИ-чата для финансовых консультаций.

**Функции:**
- Отправка сообщений
- Получение ответов от ИИ
- История чата

### SettingsScreen

Экран настроек приложения.

**Настройки:**
- Язык (RU/EN)
- Тема (светлая/темная/системная)
- Профиль пользователя
- Выход из аккаунта

### LoginScreen

Экран входа в приложение.

**Методы входа:**
- Google Sign-In
- Демо-режим

## Виджеты

### BalanceCard

Карточка с отображением баланса и активов.

**Отображает:**
- Общий баланс активов
- Потраченный баланс
- Чистый баланс (выделен цветом)
- Процентное кольцо расходов
- Список активов (первые 4)
- Выбор периода (week/month/year)
- Выбор валюты

### TransactionItem

Элемент списка транзакций.

**Отображает:**
- Иконку категории
- Название транзакции
- Сумму с валютой
- Дату и время
- Индикатор типа (expense/income)

### ActionChip

Кнопка быстрого действия.

**Использование:**
- Добавить трату
- Добавить актив
- Сканировать чек
- Открыть историю

## Локализация

### Поддерживаемые языки

- Русский (ru)
- Английский (en)

### Добавление новых строк

1. Добавить геттер в `lib/l10n/app_localizations.dart`
2. Реализовать в `lib/l10n/app_localizations_ru.dart`
3. Реализовать в `lib/l10n/app_localizations_en.dart`

Пример:
```dart
// app_localizations.dart
String get totalAssetsBalance;

// app_localizations_ru.dart
@override
String get totalAssetsBalance => 'Общий баланс активов';

// app_localizations_en.dart
@override
String get totalAssetsBalance => 'Total assets balance';
```

## API Клиент

### Dio настройка

```dart
class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Endpoints.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  
  // Интерцептор для добавления токена
  void setAuthToken(String token);
  
  // HTTP методы
  Future<Response> get(String path, {Map<String, dynamic>? params});
  Future<Response> post(String path, dynamic data);
  Future<Response> put(String path, dynamic data);
  Future<Response> delete(String path);
}
```

## Форматирование

### Formatter

Утилиты для форматирования значений.

```dart
class Formatter {
  static String formatCurrency(double amount, SupportedCurrency currency);
  static String formatPercent(double value);
  static String formatDateTime(DateTime dateTime);
  static String formatCompactRate(SupportedCurrency from, SupportedCurrency to, double rate);
}
```

## Темы

### AppTheme

Настройка светлой и темной темы.

```dart
class AppTheme {
  static ThemeData get lightTheme { ... }
  static ThemeData get darkTheme { ... }
  
  // Цветовая палитра
  static const Color primary = Color(0xFF6366F1);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
}
```

## Тестирование

### Unit тесты

```dart
test('BalanceOverview calculates net balance correctly', () {
  final overview = BalanceOverview(
    baseCurrency: SupportedCurrency.usd,
    periodLabel: 'This month',
    assets: const [
      TrackedAsset(id: '1', name: 'Cash', type: AssetType.cash, 
                   currency: SupportedCurrency.usd, amount: 1000),
    ],
    spending: const SpendingOverview(spent: 200, budget: 500),
  );
  
  expect(overview.netBalance, 800);
});
```

### Widget тесты

```dart
testWidgets('BalanceCard displays total assets', (tester) async {
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => BalanceProvider(),
      child: const MaterialApp(home: BalanceCard()),
    ),
  );
  
  expect(find.text('\$1,000.00'), findsOneWidget);
});
```

## Развертывание

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

### Переменные окружения

```bash
# API Base URL
flutter run --dart-define=API_BASE_URL=http://localhost:8080/api

# Для production
flutter build apk --dart-define=API_BASE_URL=http://57.151.105.173:8080/api
```

## Производительность

### Рекомендации

1. **Избегать лишних rebuild**: Использовать `Consumer` вместо `context.watch`
2. **Ленивая загрузка**: Использовать `ListView.builder` для списков
3. **Кэширование изображений**: Использовать `cached_network_image`
4. **Оптимизация анимаций**: Использовать `AnimatedBuilder` для сложных анимаций

### DevTools

Использовать Flutter DevTools для:
- Анализа производительности
- Отладки памяти
- Инспекции виджетов

## Безопасность

### Хранение токенов

Токены хранятся в `SharedPreferences` с шифрованием.

### HTTPS

Все API запросы используют HTTPS.

### OAuth2

Google Sign-In использует OAuth2 flow.

## Зависимости

### Основные

| Пакет | Версия | Назначение |
|-------|--------|------------|
| provider | ^6.1.2 | State management |
| dio | ^5.4.1 | HTTP client |
| google_sign_in | ^6.2.1 | Google аутентификация |
| image_picker | ^1.0.7 | Выбор изображений |
| shared_preferences | ^2.5.3 | Локальное хранение |

### Dev зависимости

| Пакет | Версия | Назначение |
|-------|--------|------------|
| flutter_test | sdk | Тестирование |
| flutter_lints | ^3.0.0 | Линтеры |
| mockito | ^5.4.4 | Моки для тестов |
| build_runner | ^2.4.8 | Генерация кода |

## Лицензия

MIT
