# Локализация и Тема — Документация

## 📋 Обзор изменений

Приложение поддерживает **единую систему управления темой и локализацией** через `AppSettingsProvider`.

**Важно:** Все настройки сохраняются **локально** в SharedPreferences и не синхронизируются с сервером.

---

## 🔄 Что изменилось

### До изменений:
- `AuthProvider` управлял темой и локализацией
- `SettingsProvider` управлял настройками пользователя
- Данные не синхронизировались между провайдерами
- Настройки сохранялись на сервере

### После изменений:
- ✅ **Единый провайдер** `AppSettingsProvider` для всего
- ✅ **Локальное сохранение** в SharedPreferences
- ✅ **Мгновенное применение** изменений
- ✅ **iOS HIG** тема по умолчанию
- ✅ **Нет зависимости от сервера** для настроек

---

## 🏗️ Архитектура

### AppSettingsProvider

```
AppSettingsProvider
├── Аутентификация (Google, Demo)
├── Профиль пользователя (локально)
├── Настройки (UserSettings)
│   ├── Тема (AppTheme: light/dark/system)
│   ├── Язык (AppLanguage: russian/english)
│   ├── Валюта (SupportedCurrency)
│   └── Уведомления (email/push)
├── ThemeMode (для MaterialApp)
└── Locale (для локализации)
```

### Хранение данных:

```dart
// SharedPreferences keys
static const String _themeModeKey = 'settings.theme_mode';
static const String _localeKey = 'settings.locale';
static const String _settingsKey = 'user.settings';
static const String _profileKey = 'auth.profile';
```

### Структура файлов

```
lib/
├── presentation/
│   ├── providers/
│   │   ├── app_settings_provider.dart  ← НОВЫЙ (единый)
│   │   └── settings_provider.dart      ← Старый (для совместимости)
│   └── screens/
│       └── ios_settings_screen.dart    ← Обновлённый
├── data/models/
│   └── user_settings.dart              ← Модели (AppTheme, AppLanguage)
└── l10n/
    ├── app_ru.arb                      ← Русский язык
    └── app_en.arb                      ← English
```

---

## 🎨 Управление темой

### Варианты темы:
- **System** (по умолчанию) — следует системной теме устройства
- **Light** — светлая тема
- **Dark** — тёмная тема (iOS HIG)

### Как работает:

```dart
// В AppSettingsProvider
ThemeMode get themeMode => _themeMode;

void setThemeMode(ThemeMode mode) {
  _themeMode = mode;
  _prefs?.setString(_themeModeKey, mode.name);
  notifyListeners();
}

Future<bool> changeTheme(AppTheme theme) async {
  ThemeMode mode;
  switch (theme) {
    case AppTheme.light: mode = ThemeMode.light; break;
    case AppTheme.dark: mode = ThemeMode.dark; break;
    case AppTheme.system: mode = ThemeMode.system; break;
  }
  setThemeMode(mode);
  return updateSettings(theme: theme.value); // Синхронизация с сервером
}
```

### Использование в UI:

```dart
// В ios_settings_screen.dart
void _showThemeDialog(BuildContext context, AppSettingsProvider appSettings) {
  final currentTheme = appSettings.appTheme;
  
  showModalBottomSheet(
    builder: (context) => Column(
      children: [
        ...AppTheme.values.map((theme) => RadioListTile<AppTheme>(
          value: theme,
          groupValue: currentTheme,
          onChanged: (value) {
            appSettings.changeTheme(value); // ← Смена темы
            Navigator.pop(context);
          },
        )),
      ],
    ),
  );
}
```

---

## 🌐 Управление локализацией

### Поддерживаемые языки:
- **Русский** (по умолчанию)
- **English**

### Как работает:

```dart
// В AppSettingsProvider
Locale get locale => _locale;

void setLocale(Locale locale) {
  _locale = locale;
  _prefs?.setString(_localeKey, locale.languageCode);
  notifyListeners();
}

Future<bool> changeLanguage(AppLanguage language) async {
  final locale = Locale(language.code);
  setLocale(locale);
  return updateSettings(language: language.code); // Синхронизация с сервером
}
```

### Файлы локализации:

#### `lib/l10n/app_ru.arb`
```json
{
  "appTitle": "Goida AI",
  "settings": "Настройки",
  "theme": "Тема",
  "language": "Язык",
  "light": "Светлая",
  "dark": "Тёмная",
  "system": "Системная"
}
```

#### `lib/l10n/app_en.arb`
```json
{
  "appTitle": "Goida AI",
  "settings": "Settings",
  "theme": "Theme",
  "language": "Language",
  "light": "Light",
  "dark": "Dark",
  "system": "System"
}
```

### Использование в UI:

```dart
// В app.dart
MaterialApp(
  locale: appSettings.locale,              // ← Текущая локаль
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  // ...
)
```

---

## 📱 Экран настроек

### Структура:

```
Настройки
├── Профиль (карточка)
│   ├── Аватар (80pt)
│   ├── Имя
│   ├── Email
│   └── Бейджи (валюта, бюджет)
├── Account
│   ├── Полное имя
│   └── Email (read-only)
├── Finance
│   ├── Базовая валюта
│   └── Месячный бюджет
├── Appearance
│   ├── Тема → Modal Bottom Sheet
│   └── Язык → Modal Bottom Sheet
├── Notifications
│   ├── Включить уведомления (toggle)
│   ├── Email-уведомления (toggle)
│   └── Push-уведомления (toggle)
└── О приложении
    └── Версия
```

### Переключатель языка:

```dart
void _showLanguageDialog(BuildContext context, AppSettingsProvider appSettings) {
  final currentLanguage = appSettings.appLanguage;
  
  showModalBottomSheet(
    builder: (context) => Column(
      children: [
        ...AppLanguage.values.map((language) => RadioListTile<AppLanguage>(
          value: language,
          groupValue: currentLanguage,
          title: Text(language.displayName),
          secondary: Icon(language.icon),
          onChanged: (value) {
            appSettings.changeLanguage(value); // ← Смена языка
            Navigator.pop(context);
          },
        )),
      ],
    ),
  );
}
```

---

## 💾 Хранение данных

### SharedPreferences:
```dart
static const String _themeModeKey = 'settings.theme_mode';
static const String _localeKey = 'settings.locale';
static const String _settingsKey = 'user.settings';
```

### Сервер (API):
```dart
// GET /api/settings/full
{
  "theme": "system",
  "language": "ru",
  "baseCurrency": "USD",
  "monthlyBudget": 0.0,
  "emailNotifications": false,
  "pushNotifications": true
}

// PUT /api/settings
{
  "theme": "dark",
  "language": "en"
}
```

---

## 🚀 Как использовать

### 1. Смена темы:
```dart
// В любом месте через context
final appSettings = context.read<AppSettingsProvider>();
appSettings.changeTheme(AppTheme.dark);
```

### 2. Смена языка:
```dart
final appSettings = context.read<AppSettingsProvider>();
appSettings.changeLanguage(AppLanguage.english);
```

### 3. Смена валюты:
```dart
final appSettings = context.read<AppSettingsProvider>();
appSettings.changeBaseCurrency(SupportedCurrency.eur);
```

### 4. Обновление уведомлений:
```dart
final appSettings = context.read<AppSettingsProvider>();
appSettings.updateNotifications(
  notificationsEnabled: true,
  emailNotifications: false,
  pushNotifications: true,
);
```

---

## ✅ Проверка работы

### 1. Тема:
- [ ] Открыть Настройки → Appearance → Theme
- [ ] Выбрать Light → тема должна стать светлой
- [ ] Выбрать Dark → тема должна стать тёмной (iOS HIG)
- [ ] Выбрать System → тема следует системе
- [ ] Перезапустить приложение → выбранная тема сохраняется

### 2. Язык:
- [ ] Открыть Настройки → Appearance → Language
- [ ] Выбрать English → все тексты на английском
- [ ] Выбрать Русский → все тексты на русском
- [ ] Перезапустить приложение → выбранный язык сохраняется

### 3. Синхронизация:
- [ ] Изменить тему/язык на устройстве 1
- [ ] Войти на устройстве 2 → настройки должны синхронизироваться

---

## 🐛 Возможные проблемы

### Тема не применяется:
```dart
// Проверить в app.dart:
themeMode: appSettings.themeMode, // ← Должно быть так
```

### Язык не меняется:
```dart
// Проверить в app.dart:
locale: appSettings.locale, // ← Должно быть так
```

### Локализация не работает:
```bash
# Перегенерировать локализацию
flutter gen-l10n

# Проверить файлы
lib/l10n/app_ru.arb
lib/l10n/app_en.arb
```

---

## 📚 Связанные файлы

| Файл | Описание |
|------|----------|
| `lib/app.dart` | Точка входа, настройка MaterialApp |
| `lib/presentation/providers/app_settings_provider.dart` | Единый провайдер |
| `lib/presentation/screens/ios_settings_screen.dart` | Экран настроек |
| `lib/data/models/user_settings.dart` | Модели (AppTheme, AppLanguage) |
| `lib/l10n/app_ru.arb` | Русский язык |
| `lib/l10n/app_en.arb` | English |
| `lib/core/theme/ios_theme.dart` | iOS HIG тема |

---

**Обновлено:** 01 апреля 2026  
**Версия:** 2.0
