import 'package:flutter/material.dart';
import 'balance.dart';

/// Модель настроек пользователя
class UserSettings {
  final String? id;
  final String email;
  final String fullName;
  final String language;
  final String theme;
  final SupportedCurrency baseCurrency;
  final double monthlyBudget;
  final String? avatarUrl;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final String timezone;

  const UserSettings({
    this.id,
    required this.email,
    required this.fullName,
    required this.language,
    required this.theme,
    required this.baseCurrency,
    required this.monthlyBudget,
    this.avatarUrl,
    this.notificationsEnabled = true,
    this.emailNotifications = false,
    this.pushNotifications = true,
    this.timezone = 'UTC',
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      id: json['id'] as String?,
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
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
      timezone: json['timezone'] as String? ?? 'UTC',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'fullName': fullName,
        'language': language,
        'theme': theme,
        'baseCurrency': baseCurrency.code,
        'monthlyBudget': monthlyBudget,
        'avatarUrl': avatarUrl,
        'notificationsEnabled': notificationsEnabled,
        'emailNotifications': emailNotifications,
        'pushNotifications': pushNotifications,
        'timezone': timezone,
      };

  UserSettings copyWith({
    String? id,
    String? email,
    String? fullName,
    String? language,
    String? theme,
    SupportedCurrency? baseCurrency,
    double? monthlyBudget,
    String? avatarUrl,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? pushNotifications,
    String? timezone,
  }) {
    return UserSettings(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      timezone: timezone ?? this.timezone,
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
