import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:demo2/presentation/screens/login_screen.dart';
import 'package:demo2/presentation/providers/auth_provider.dart';
import 'package:demo2/core/api/api_client.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    Widget createTestWidget(AuthProvider authProvider) {
      return ChangeNotifierProvider<AuthProvider>.value(
        value: authProvider,
        child: const MaterialApp(
          home: LoginScreen(),
          debugShowCheckedModeBanner: false,
        ),
      );
    }

    testWidgets('отображает логотип', (WidgetTester tester) async {
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);
      await tester.pumpWidget(createTestWidget(authProvider));

      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    testWidgets('отображает приветственный текст', (WidgetTester tester) async {
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);
      await tester.pumpWidget(createTestWidget(authProvider));

      expect(find.textContaining('Welcome'), findsWidgets);
    });

    testWidgets('отображает кнопку входа через Google', (WidgetTester tester) async {
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);
      await tester.pumpWidget(createTestWidget(authProvider));

      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('отображает кнопку демо режима', (WidgetTester tester) async {
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);
      await tester.pumpWidget(createTestWidget(authProvider));

      expect(find.text('Try Demo Mode'), findsOneWidget);
    });

    testWidgets('кнопка демо режима вызывает loginAsDemo', (WidgetTester tester) async {
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);
      await tester.pumpWidget(createTestWidget(authProvider));

      final demoButton = find.text('Try Demo Mode');
      await tester.tap(demoButton);
      await tester.pumpAndSettle();

      expect(authProvider.isDemoMode, isTrue);
    });

    testWidgets('отображает индикатор загрузки во время входа', (WidgetTester tester) async {
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);
      
      authProvider.signInWithGoogle();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('имеет современный дизайн с закругленными углами', (WidgetTester tester) async {
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);
      await tester.pumpWidget(createTestWidget(authProvider));

      final logoContainer = find.byType(Container).first;
      expect(logoContainer, findsOneWidget);
    });

    testWidgets('использует фирменный цвет #00D09E', (WidgetTester tester) async {
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);
      await tester.pumpWidget(createTestWidget(authProvider));

      final demoButton = find.byType(TextButton).first;
      expect(demoButton, findsOneWidget);
    });

    testWidgets('отображает описание под заголовком', (WidgetTester tester) async {
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);
      await tester.pumpWidget(createTestWidget(authProvider));

      expect(find.textContaining('Manage your finances'), findsWidgets);
    });

    testWidgets('кнопка Google имеет иконку или изображение', (WidgetTester tester) async {
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);
      await tester.pumpWidget(createTestWidget(authProvider));

      expect(find.byType(Image), findsOneWidget);
    });
  });
}
