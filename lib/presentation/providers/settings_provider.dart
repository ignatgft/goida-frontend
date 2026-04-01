import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../../data/models/user_settings.dart';
import '../../data/models/balance.dart';

/// Provider для управления настройками пользователя
class SettingsProvider extends ChangeNotifier {
  final ApiClient api;
  UserSettings? _settings;
  bool _isLoading = false;
  bool _isUploadingAvatar = false;

  SettingsProvider(this.api);

  UserSettings? get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isUploadingAvatar => _isUploadingAvatar;

  /// Загрузить настройки
  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await api.get(Endpoints.settingsFull);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        _settings = UserSettings(
          id: data['id'] as String?,
          email: data['email'] as String? ?? '',
          fullName: data['fullName'] as String? ?? '',
          language: data['language'] as String? ?? 'ru',
          theme: data['theme'] as String? ?? 'system',
          baseCurrency: SupportedCurrencyX.fromCode(
            data['baseCurrency'] as String? ?? 'USD',
          ),
          monthlyBudget: (data['monthlyBudget'] as num?)?.toDouble() ?? 0.0,
          avatarUrl: data['avatarUrl'] as String?,
          notificationsEnabled: data['emailNotifications'] as bool? ?? true,
          emailNotifications: data['emailNotifications'] as bool? ?? false,
          pushNotifications: data['pushNotifications'] as bool? ?? true,
          timezone: data['timezone'] as String? ?? 'UTC',
        );
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Обновить настройки
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
    try {
      final response = await api.put(
        Endpoints.settingsAll,
        {
          if (fullName != null) 'fullName': fullName,
          if (language != null) 'language': language,
          if (theme != null) 'theme': theme,
          if (baseCurrency != null) 'baseCurrency': baseCurrency.code,
          if (monthlyBudget != null) 'monthlyBudget': monthlyBudget,
          if (emailNotifications != null) 'emailNotifications': emailNotifications,
          if (pushNotifications != null) 'pushNotifications': pushNotifications,
          if (notificationsEnabled != null) 'notificationsEnabled': notificationsEnabled,
          if (timezone != null) 'timezone': timezone,
        },
      );

      if (response.statusCode == 200) {
        await loadSettings();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating settings: $e');
      return false;
    }
  }

  /// Загрузить аватар
  Future<bool> uploadAvatar(File file) async {
    _isUploadingAvatar = true;
    notifyListeners();

    try {
      final response = await api.postMultipart(
        Endpoints.settingsAvatar,
        files: {'file': await MultipartFile.fromFile(file.path)},
      );

      if (response.statusCode == 200) {
        await loadSettings();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      return false;
    } finally {
      _isUploadingAvatar = false;
      notifyListeners();
    }
  }

  /// Удалить аватар
  Future<bool> deleteAvatar() async {
    try {
      final response = await api.delete(Endpoints.settingsAvatar);

      if (response.statusCode == 204 || response.statusCode == 200) {
        await loadSettings();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting avatar: $e');
      return false;
    }
  }

  /// Сменить тему
  Future<bool> changeTheme(AppTheme theme) async {
    return updateSettings(theme: theme.value);
  }

  /// Сменить язык
  Future<bool> changeLanguage(AppLanguage language) async {
    return updateSettings(language: language.code);
  }

  /// Сменить базовую валюту
  Future<bool> changeBaseCurrency(SupportedCurrency currency) async {
    return updateSettings(baseCurrency: currency);
  }

  /// Очистить настройки
  void clear() {
    _settings = null;
    notifyListeners();
  }
}
