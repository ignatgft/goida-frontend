import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo2/presentation/providers/auth_provider.dart';
import 'package:demo2/core/api/api_client.dart';

void main() {
  group('AuthProvider', () {
    late ApiClient apiClient;
    late AuthProvider authProvider;

    setUp(() {
      apiClient = ApiClient();
      authProvider = AuthProvider(apiClient);
    });

    tearDown(() {
      authProvider.dispose();
    });

    test('начальное состояние корректное', () {
      expect(authProvider.isInitialized, isFalse);
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.isLoading, isFalse);
      expect(authProvider.isDemoMode, isFalse);
      expect(authProvider.user, isNull);
      expect(authProvider.profile, isNull);
    });

    test('displayName возвращает значение по умолчанию', () {
      expect(authProvider.displayName, 'User');
    });

    test('email возвращает пустую строку по умолчанию', () {
      expect(authProvider.email, '');
    });

    test('sessionKey возвращает null когда не аутентифицирован', () {
      expect(authProvider.sessionKey, isNull);
    });

    test('loginAsDemo устанавливает demo режим', () {
      authProvider.loginAsDemo();

      expect(authProvider.isDemoMode, isTrue);
      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.sessionKey, 'demo');
      expect(authProvider.displayName, 'Demo User');
      expect(authProvider.email, 'demo@goida.ai');
    });

    test('setThemeMode сохраняет тему', () {
      authProvider.setThemeMode(ThemeMode.dark);

      expect(authProvider.themeMode, ThemeMode.dark);
    });

    test('setThemeMode уведомляет слушателей', () {
      var notifyCount = 0;
      authProvider.addListener(() => notifyCount++);

      authProvider.setThemeMode(ThemeMode.light);

      expect(notifyCount, 1);
    });

    test('setLocale сохраняет локаль', () {
      authProvider.setLocale(const Locale('ru'));

      expect(authProvider.locale, const Locale('ru'));
    });

    test('setLocale(null) сбрасывает локаль', () {
      authProvider.setLocale(const Locale('en'));
      authProvider.setLocale(null);

      expect(authProvider.locale, isNull);
    });

    test('signOut сбрасывает все состояния', () async {
      authProvider.loginAsDemo();
      expect(authProvider.isAuthenticated, isTrue);

      await authProvider.signOut();

      expect(authProvider.isDemoMode, isFalse);
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.user, isNull);
      expect(authProvider.profile, isNull);
    });

    test('avatarImageProvider возвращает null если нет аватара', () {
      expect(authProvider.avatarImageProvider, isNull);
    });

    test('isDemoMode false после инициализации без демо входа', () {
      expect(authProvider.isDemoMode, isFalse);
    });

    group('sessionKey', () {
      test('возвращает demo когда demo mode', () {
        authProvider.loginAsDemo();
        expect(authProvider.sessionKey, 'demo');
      });

      test('возвращает null когда не аутентифицирован', () {
        expect(authProvider.sessionKey, isNull);
      });
    });

    group('ThemeMode', () {
      test('по умолчанию system', () {
        expect(authProvider.themeMode, ThemeMode.system);
      });

      test('можно установить light', () {
        authProvider.setThemeMode(ThemeMode.light);
        expect(authProvider.themeMode, ThemeMode.light);
      });

      test('можно установить dark', () {
        authProvider.setThemeMode(ThemeMode.dark);
        expect(authProvider.themeMode, ThemeMode.dark);
      });

      test('можно установить system', () {
        authProvider.setThemeMode(ThemeMode.system);
        expect(authProvider.themeMode, ThemeMode.system);
      });
    });
  });
}
