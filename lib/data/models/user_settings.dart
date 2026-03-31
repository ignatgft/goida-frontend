import 'package:flutter/material.dart';
import 'balance.dart';

/// Модель настроек пользователя
class UserSettings {
  final String language;
  final String theme;
  final SupportedCurrency baseCurrency;
  final double monthlyBudget;
  final String? avatarUrl;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;

  const UserSettings({
    required this.language,
    required this.theme,
    required this.baseCurrency,
    required this.monthlyBudget,
    this.avatarUrl,
    this.notificationsEnabled = true,
    this.emailNotifications = false,
    this.pushNotifications = true,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      language: json['language'] as String? ?? 'ru',
      theme: json['theme'] as String? ?? 'system',
      baseCurrency: SupportedCurrencyX.fromCode(
        json['baseCurrency'] as String? ?? 'USD',
      ),
      monthlyBudget: (json['monthlyBudget'] as num?)?.toDouble() ?? 0.0,
      avatarUrl: json['avatarUrl'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? false,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'language': language,
        'theme': theme,
        'baseCurrency': baseCurrency.code,
        'monthlyBudget': monthlyBudget,
        'avatarUrl': avatarUrl,
        'notificationsEnabled': notificationsEnabled,
        'emailNotifications': emailNotifications,
        'pushNotifications': pushNotifications,
      };

  UserSettings copyWith({
    String? language,
    String? theme,
    SupportedCurrency? baseCurrency,
    double? monthlyBudget,
    String? avatarUrl,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
  }) {
    return UserSettings(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
    );
  }
}

/// Тема приложения
enum AppTheme {
  system,
  light,
  dark,
}

extension AppThemeX on AppTheme {
  String get value => switch (this) {
        AppTheme.system => 'system',
        AppTheme.light => 'light',
        AppTheme.dark => 'dark',
      };

  static AppTheme fromString(String value) {
    return switch (value.toLowerCase()) {
      'light' => AppTheme.light,
      'dark' => AppTheme.dark,
      _ => AppTheme.system,
    };
  }

  String get displayName => switch (this) {
        AppTheme.system => 'Системная',
        AppTheme.light => 'Светлая',
        AppTheme.dark => 'Темная',
      };

  IconData get icon => switch (this) {
        AppTheme.system => Icons.phone_android_rounded,
        AppTheme.light => Icons.light_mode_rounded,
        AppTheme.dark => Icons.dark_mode_rounded,
      };
}

/// Язык приложения
enum AppLanguage {
  russian,
  english,
}

extension AppLanguageX on AppLanguage {
  String get code => switch (this) {
        AppLanguage.russian => 'ru',
        AppLanguage.english => 'en',
      };

  String get displayName => switch (this) {
        AppLanguage.russian => 'Русский',
        AppLanguage.english => 'English',
      };

  IconData get icon => switch (this) {
        AppLanguage.russian => Icons.language_rounded,
        AppLanguage.english => Icons.translate_rounded,
      };

  static AppLanguage fromCode(String code) {
    return switch (code.toLowerCase()) {
      'en' => AppLanguage.english,
      'ru' => AppLanguage.russian,
      _ => AppLanguage.russian,
    };
  }
}
