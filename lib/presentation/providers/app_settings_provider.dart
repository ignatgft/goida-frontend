import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/google_auth_config.dart';
import '../../data/models/user.dart';
import '../../data/models/user_settings.dart';
import '../../data/models/balance.dart';

/// Провайдер настроек приложения - ТОЛЬКО ЛОКАЛЬНОЕ ХРАНЕНИЕ
/// Без запросов к серверу
class AppSettingsProvider extends ChangeNotifier {
  // Keys для SharedPreferences
  static const String _profileKey = 'auth.profile';
  static const String _themeModeKey = 'settings.theme_mode';
  static const String _localeKey = 'settings.locale';
  static const String _settingsKey = 'user.settings';

  final GoogleSignIn _googleSignIn = GoogleAuthConfig.createGoogleSignIn();
  final ImagePicker _picker = ImagePicker();

  SharedPreferences? _prefs;
  GoogleSignInAccount? _user;
  AppUser? _profile;
  UserSettings? _settings;
  bool _isDemoMode = false;
  bool _isLoading = false;
  bool _isUploadingAvatar = false;
  bool _isInitialized = false;

  Uint8List? _avatarBytes;
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('ru'); // По умолчанию русский

  AppSettingsProvider();

  // MARK: - Getters
  GoogleSignInAccount? get user => _user;
  AppUser? get profile => _profile;
  UserSettings? get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isUploadingAvatar => _isUploadingAvatar;
  bool get isDemoMode => _isDemoMode;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _user != null || _profile != null || _isDemoMode;
  String? get sessionKey => _isDemoMode ? 'demo' : (_profile?.id ?? _user?.id);
  String? get avatarUrl => _profile?.avatarUrl ?? _user?.photoUrl;

  ImageProvider<Object>? get avatarImageProvider {
    if (_avatarBytes != null) {
      return MemoryImage(_avatarBytes!);
    }
    final url = avatarUrl;
    if (url != null && url.isNotEmpty) {
      return NetworkImage(url);
    }
    return null;
  }

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  AppLanguage get appLanguage => AppLanguageX.fromCode(_locale.languageCode);
  AppTheme get appTheme {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppTheme.light;
      case ThemeMode.dark:
        return AppTheme.dark;
      case ThemeMode.system:
        return AppTheme.system;
    }
  }

  String get displayName => _isDemoMode
      ? "Demo User"
      : (_profile?.displayName ?? _user?.displayName ?? "User");

  String get email =>
      _isDemoMode ? "demo@goida.ai" : (_profile?.email ?? _user?.email ?? "");

  // MARK: - Initialization
  Future<void> initialize() async {
    if (_isInitialized) return;

    _prefs = await SharedPreferences.getInstance();
    _restoreLocalSettings();
    _restorePersistedSession();
    _isInitialized = true;
    notifyListeners();
  }

  // MARK: - Theme Management
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _prefs?.setString(_themeModeKey, mode.name);
    notifyListeners();
  }

  Future<bool> changeTheme(AppTheme theme) async {
    ThemeMode mode;
    switch (theme) {
      case AppTheme.light:
        mode = ThemeMode.light;
        break;
      case AppTheme.dark:
        mode = ThemeMode.dark;
        break;
      case AppTheme.system:
        mode = ThemeMode.system;
        break;
    }
    setThemeMode(mode);
    await updateSettings(theme: theme.value);
    return true;
  }

  // MARK: - Locale Management
  void setLocale(Locale locale) {
    _locale = locale;
    _prefs?.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  Future<bool> changeLanguage(AppLanguage language) async {
    final locale = Locale(language.code);
    setLocale(locale);
    await updateSettings(language: language.code);
    return true;
  }

  // MARK: - Settings Management
  Future<void> _loadSettings() async {
    // Загружаем настройки ТОЛЬКО локально
    final settingsJson = _prefs?.getString(_settingsKey);
    if (settingsJson != null) {
      try {
        final data = jsonDecode(settingsJson) as Map<String, dynamic>;
        _settings = UserSettings(
          id: _profile?.id,
          email: email,
          fullName: displayName,
          language: data['language'] as String? ?? 'ru',
          theme: data['theme'] as String? ?? 'system',
          baseCurrency: SupportedCurrencyX.fromCode(
            data['baseCurrency'] as String? ?? 'USD',
          ),
          monthlyBudget: (data['monthlyBudget'] as num?)?.toDouble() ?? 0.0,
          avatarUrl: data['avatarUrl'] as String?,
          notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
          emailNotifications: data['emailNotifications'] as bool? ?? false,
          pushNotifications: data['pushNotifications'] as bool? ?? true,
          timezone: data['timezone'] as String? ?? 'UTC',
        );

        // Применяем локальные настройки
        final themeStr = _settings!.theme;
        final theme = AppThemeX.fromString(themeStr);
        setThemeMode(_themeModeFromAppTheme(theme));

        final languageStr = _settings!.language;
        setLocale(Locale(languageStr));
      } catch (e) {
        debugPrint('Error parsing settings: $e');
        _createDefaultSettings();
      }
    } else {
      _createDefaultSettings();
    }
  }

  void _createDefaultSettings() {
    _settings = UserSettings(
      id: _profile?.id,
      email: email,
      fullName: displayName,
      language: 'ru',
      theme: 'system',
      baseCurrency: SupportedCurrency.usd,
      monthlyBudget: 0.0,
      avatarUrl: _profile?.avatarUrl,
      notificationsEnabled: true,
      emailNotifications: false,
      pushNotifications: true,
      timezone: 'UTC',
    );
    _saveSettings();
  }

  Future<void> _saveSettings() async {
    if (_settings == null) return;

    final data = {
      'language': _settings!.language,
      'theme': _settings!.theme,
      'baseCurrency': _settings!.baseCurrency.code,
      'monthlyBudget': _settings!.monthlyBudget,
      'avatarUrl': _settings!.avatarUrl ?? _profile?.avatarUrl,
      'notificationsEnabled': _settings!.notificationsEnabled,
      'emailNotifications': _settings!.emailNotifications,
      'pushNotifications': _settings!.pushNotifications,
      'timezone': _settings!.timezone,
    };

    await _prefs?.setString(_settingsKey, jsonEncode(data));
    notifyListeners();
  }

  ThemeMode _themeModeFromAppTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.system:
        return ThemeMode.system;
    }
  }

  Future<bool> updateSettings({
    String? fullName,
    String? language,
    String? theme,
    SupportedCurrency? baseCurrency,
    double? monthlyBudget,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? notificationsEnabled,
    String? timezone,
  }) async {
    if (_settings == null) return false;

    _settings = UserSettings(
      id: _settings!.id,
      email: _settings!.email,
      fullName: fullName ?? _settings!.fullName,
      language: language ?? _settings!.language,
      theme: theme ?? _settings!.theme,
      baseCurrency: baseCurrency ?? _settings!.baseCurrency,
      monthlyBudget: monthlyBudget ?? _settings!.monthlyBudget,
      avatarUrl: _settings!.avatarUrl,
      notificationsEnabled: notificationsEnabled ?? _settings!.notificationsEnabled,
      emailNotifications: emailNotifications ?? _settings!.emailNotifications,
      pushNotifications: pushNotifications ?? _settings!.pushNotifications,
      timezone: timezone ?? _settings!.timezone,
    );

    // Сохраняем ТОЛЬКО локально
    await _saveSettings();
    return true;
  }

  // MARK: - Currency Management
  Future<bool> changeBaseCurrency(SupportedCurrency currency) async {
    return updateSettings(baseCurrency: currency);
  }

  // MARK: - Notifications Management
  Future<bool> updateNotifications({
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
  }) async {
    return updateSettings(
      notificationsEnabled: notificationsEnabled,
      emailNotifications: emailNotifications,
      pushNotifications: pushNotifications,
    );
  }

  // MARK: - Avatar Management
  Future<bool> uploadAvatar(File file) async {
    _isUploadingAvatar = true;
    notifyListeners();

    try {
      _avatarBytes = await file.readAsBytes();

      // Сохраняем локально путь к аватару
      final avatarPath = 'local_avatar_${DateTime.now().millisecondsSinceEpoch}';
      if (_profile != null) {
        _profile = _profile!.copyWith(avatarUrl: avatarPath);
        await _persistProfile();
      }

      if (_settings != null) {
        _settings = _settings!.copyWith(avatarUrl: avatarPath);
        await _saveSettings();
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      return false;
    } finally {
      _isUploadingAvatar = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAvatar() async {
    if (_profile != null) {
      _profile = _profile!.copyWith(avatarUrl: null);
      await _persistProfile();
    }
    if (_settings != null) {
      _settings = _settings!.copyWith(avatarUrl: null);
      await _saveSettings();
    }
    _avatarBytes = null;
    notifyListeners();
    return true;
  }

  // MARK: - Authentication
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        await _applyGoogleUser(googleUser);
      }
    } catch (e) {
      debugPrint("Error Google Sign In: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInAsDev() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Создаем локальный профиль для dev-режима
      _profile = const AppUser(
        id: 'dev_user',
        displayName: 'Dev User',
        email: 'test@goida.ai',
      );
      await _persistProfile();
      await _loadSettings();
    } catch (e) {
      debugPrint("Error dev sign in: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> pickAndUploadAvatar() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (image == null) return false;

    _avatarBytes = await image.readAsBytes();
    _isUploadingAvatar = true;
    notifyListeners();

    try {
      // Сохраняем локально
      final avatarPath = 'local_avatar_${DateTime.now().millisecondsSinceEpoch}';
      
      if (_profile != null) {
        _profile = _profile!.copyWith(avatarUrl: avatarPath);
        await _persistProfile();
      } else if (_user != null) {
        _profile = AppUser(
          id: _user!.id,
          displayName: _user!.displayName ?? "User",
          email: _user!.email,
          avatarUrl: avatarPath,
        );
        await _persistProfile();
      }

      if (_settings != null) {
        _settings = _settings!.copyWith(avatarUrl: avatarPath);
        await _saveSettings();
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error uploading avatar: $e");
      return false;
    } finally {
      _isUploadingAvatar = false;
      notifyListeners();
    }
  }

  void loginAsDemo() {
    _clearPersistedSession();
    _isDemoMode = true;
    _user = null;
    _profile = const AppUser(id: 'demo', displayName: 'Demo User', email: 'demo@goida.ai');
    _loadSettings();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _clearPersistedSession();
    _user = null;
    _profile = null;
    _settings = null;
    _isDemoMode = false;
    _avatarBytes = null;
    notifyListeners();
  }

  // MARK: - Private Methods
  Future<void> _applyGoogleUser(GoogleSignInAccount googleUser) async {
    _user = googleUser;
    _isDemoMode = false;
    // Создаем локальный профиль без запросов к серверу
    _profile = AppUser(
      id: googleUser.id,
      displayName: googleUser.displayName ?? "User",
      email: googleUser.email,
      avatarUrl: googleUser.photoUrl,
    );
    await _persistProfile();
    await _loadSettings();
    notifyListeners();
  }

  void _restorePersistedSession() {
    final profileJson = _prefs?.getString(_profileKey);
    if (profileJson != null) {
      try {
        _profile = AppUser.fromJson(jsonDecode(profileJson));
      } catch (_) {}
    }
    _loadSettings();
  }

  Future<void> _persistProfile() async {
    if (_profile == null) {
      await _prefs?.remove(_profileKey);
    } else {
      await _prefs?.setString(_profileKey, jsonEncode(_profile!.toJson()));
    }
  }

  void _clearPersistedSession() {
    _prefs?.remove(_profileKey);
  }

  void _restoreLocalSettings() {
    // Восстанавливаем тему
    final savedTheme = _prefs?.getString(_themeModeKey);
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (m) => m.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }

    // Восстанавливаем локаль
    final savedLocale = _prefs?.getString(_localeKey);
    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    }
  }

  void clear() {
    _settings = null;
    notifyListeners();
  }
}
