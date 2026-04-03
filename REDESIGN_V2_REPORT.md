# Goida AI v2.0 — iOS HIG Redesign Report

**Версия:** 2.0  
**Дата:** 01 апреля 2026  
**Статус:** ✅ В процессе (7/10 этапов завершено)

---

## 📋 Обзор

Полный редизайн приложения Goida AI в классическом стиле Apple iOS Human Interface Guidelines с использованием:
- **Cupertino widgets** для нативного iOS вида
- **iOS Design System** с цветами #6B4EFF (акцент) и #00D1A2 (успех)
- **Поддержка светлой и тёмной темы**
- **Локализация RU/EN**

---

## ✅ Выполненные этапы

### Этап 1: Зависимости и версия ✅
- **Версия приложения:** 0.2.0+2
- **Добавленные зависимости:**
  - `cupertino_icons: ^1.0.8` — iOS иконки
  - `qr_flutter: ^4.1.0` — QR-коды для WalletConnect
  - `walletconnect_dart: ^0.0.11` — WalletConnect интеграция

### Этап 2: iOS Design System ✅
**Файл:** `lib/core/theme/ios_design_system.dart`

**Цветовая палитра:**
```dart
// Акцентные цвета
primaryAccent: #6B4EFF      // Фиолетовый
successGreen: #00D1A2       // Зелёный
errorRed: #FF3B30           // Красный iOS
warningOrange: #FF9500      // Оранжевый iOS

// Системные цвета (Light/Dark)
systemBackground: #FFFFFF / #000000
secondarySystemBackground: #F2F2F7 / #1C1C1E
tertiarySystemBackground: #FFFFFF / #2C2C2E
```

**Типографика (SF Pro):**
- Large Title: 34pt Bold
- Title 1/2/3: 28/22/20pt Bold/Semibold
- Body: 17pt Regular
- Subheadline: 15pt Medium
- Caption: 12/11pt

**Радиусы:**
- Small: 8pt (кнопки, чипсы)
- Medium: 10pt (карточки в списках)
- Large: 12pt (большие карточки)
- XLarge: 16pt (профиль, модалки)

### Этап 3: Локализация ✅
**Файлы:**
- `lib/l10n/app_ru.arb` — русский язык
- `lib/l10n/app_en.arb` — английский

**Добавленные строки:**
- usageAndBilling, billingHistory
- appearanceSection, notificationsSection, systemSection
- privacyPolicy, signOut
- walletConnect, connectWallet, selectWallet
- scanQRCode, qrCodeDescription
- tonkeeper, metamask, trustWallet, phantom, rainbow, argent, braavos, coinbaseWallet, ledger, safePal, imToken

### Этап 4: Навигация ✅
**Файл:** `lib/presentation/screens/ios_app_wrapper.dart`

**4 вкладки (CupertinoTabBar):**
1. **Главная** — `CupertinoIcons.house`
2. **Мессенджер** — `CupertinoIcons.bubble_left_bubble_right`
3. **ИИ Чат** — `CupertinoIcons.sparkles`
4. **Статистика** — `CupertinoIcons.chart_bar`

### Этап 5: Экран Настройки ✅
**Файл:** `lib/presentation/screens/ios_settings_screen.dart`

**Референс:** Alex Sterling Settings Screen

**Структура:**
```
┌─────────────────────────────┐
│   [Круглый аватар 80pt]     │
│      Имя пользователя       │
│          email              │
└─────────────────────────────┘

USAGE & BILLING
┌─────────────────────────────┐
│ 💳 Monthly Budget    $0     │
│ 📄 Billing History         ›│
└─────────────────────────────┘

APPEARANCE
┌─────────────────────────────┐
│ 🎨 Theme          Light    ›│
│ 🌐 Language      Русский   ›│
└─────────────────────────────┘

NOTIFICATIONS
┌─────────────────────────────┐
│ ✉️ Email Notifications   [✓]│
│ 🔔 Push Notifications    [✓]│
└─────────────────────────────┘

SYSTEM
┌─────────────────────────────┐
│ ℹ️ About          Version  │
│ 🔒 Privacy Policy          ›│
└─────────────────────────────┘

    ┌─────────────────┐
    │   Sign Out      │  ← Красная кнопка
    └─────────────────┘
```

### Этап 6: Главная страница (Dashboard) ✅
**Файл:** `lib/presentation/screens/ios_home_screen.dart`

**Референс:** Total Net Worth $142,850.42

**Компоненты:**
1. **Total Net Worth карточка:**
   - Большое число: $142,850.42
   - Индикатор: +12.4% this month (зелёный)
   - График за 30 дней (fl_chart с градиентом)

2. **Smart Insights:**
   - Горизонтальный скролл карточек
   - Акцентный фиолетовый цвет
   - Кнопки действий (+, →)

3. **Quick Actions:**
   - 4 кнопки: Expense, Add Asset, Scan, History
   - Цветные иконки с подписями

4. **Assets список:**
   - До 5 активов с иконками
   - Отображение баланса

### Этап 7: WalletConnect ✅
**Файлы:**
- `lib/data/models/wallet_connection.dart`
- `lib/presentation/screens/wallet_connect_screen.dart`

**Поддерживаемые кошельки:**
- **Популярные:** Tonkeeper, MetaMask, Trust Wallet, Phantom
- **Остальные:** Rainbow, Argent, Braavos, Coinbase Wallet, Ledger, SafePal, imToken

**UI:**
- Список кошельков с иконками
- QR-код для подключения (qr_flutter)
- Deep link для открытия кошелька

---

## 📁 Структура файлов

```
lib/
├── core/
│   └── theme/
│       ├── app_theme.dart              # Старая тема
│       ├── ios_theme.dart              # iOS тема (Material)
│       └── ios_design_system.dart      # ✅ iOS Design System (Cupertino)
├── data/
│   └── models/
│       ├── balance.dart
│       ├── user_settings.dart
│       └── wallet_connection.dart      # ✅ WalletConnect модели
├── presentation/
│   ├── providers/
│   │   └── app_settings_provider.dart  # ✅ Единый провайдер
│   └── screens/
│       ├── ios_app_wrapper.dart        # ✅ Навигация
│       ├── ios_settings_screen.dart    # ✅ Настройки
│       ├── ios_home_screen.dart        # ✅ Главная
│       ├── ios_messenger_screen.dart   # Заглушка
│       ├── ios_chat_screen.dart        # Заглушка
│       ├── ios_statistics_screen.dart  # Заглушка
│       └── wallet_connect_screen.dart  # ✅ WalletConnect UI
├── l10n/
│   ├── app_ru.arb                      # ✅ Русский
│   └── app_en.arb                      # ✅ English
├── main.dart                           # ✅ CupertinoApp
└── app.dart                            # (старый, можно удалить)
```

---

## 🎨 Темы

### Светлая тема
- Фон: #F2F2F7 (systemGroupedBackground)
- Карточки: #FFFFFF
- Текст: #000000 (primary), #3C3C4399 (secondary)

### Тёмная тема
- Фон: #000000 (systemGroupedBackground)
- Карточки: #1C1C1E
- Текст: #FFFFFF (primary), #EBEBF599 (secondary)

**Переключение:** Автоматически по системе + ручное в настройках

---

## 🚀 Как запустить

```bash
# 1. Установка зависимостей
flutter pub get

# 2. Генерация локализации
flutter gen-l10n

# 3. Запуск
flutter run

# 4. Сборка
flutter build apk --debug      # Android
flutter build ios --release    # iOS
```

---

## 📊 Метрики

| Метрика | Значение |
|---------|----------|
| **Создано файлов** | 10 |
| **Обновлено файлов** | 5 |
| **Строк кода добавлено** | ~2500 |
| **Этапов завершено** | 7/10 |
| **Время разработки** | 1 день |

---

## 🔄 Осталось сделать

### Этап 8: ИИ Чат и Мессенджер (в процессе)
- [ ] IosChatScreen — пузыри сообщений как в Messages.app
- [ ] IosMessengerScreen — список чатов
- [ ] Поле ввода с круглой кнопкой отправки

### Этап 9: Статистика (в процессе)
- [ ] IosStatisticsScreen — графики и карточки
- [ ] Portfolio Mix
- [ ] Market Snapshot
- [ ] Spending Velocity

### Этап 10: Тестирование (финал)
- [ ] Тестирование на реальных iPhone
- [ ] Проверка светлой/тёмной темы
- [ ] Accessibility (VoiceOver, Dynamic Type)
- [ ] Финальная полировка

---

## 📞 Контакты

**Исполнитель:** Qwen Code  
**Заказчик:** Игнат Горборуков  
**Email:** gorborukovignst@gmail.com

---

**Goida AI v2.0 iOS Redesign** © 2026. Все права защищены.
