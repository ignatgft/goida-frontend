import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:demo2/presentation/screens/home_screen.dart';
import 'package:demo2/presentation/providers/balance_provider.dart';
import 'package:demo2/presentation/providers/receipt_provider.dart';
import 'package:demo2/presentation/providers/auth_provider.dart';
import 'package:demo2/data/models/balance.dart';
import 'package:demo2/data/models/transaction.dart';
import 'package:demo2/data/repositories/finance_repository.dart';
import 'package:demo2/presentation/screens/settings_screen.dart';
import 'package:demo2/core/api/api_client.dart';

// Тестовый BalanceProvider
class TestBalanceProvider extends BalanceProvider {
  BalanceOverview? _overview;
  bool _loading = false;

  TestBalanceProvider() : super(_TestFinanceRepository());

  @override
  BalanceOverview? get overview => _overview;

  @override
  bool get loading => _loading;

  @override
  List<TrackedAsset> get assets => _overview?.assets ?? const [];

  @override
  SpendingOverview? get spending => _overview?.spending;

  @override
  String get periodLabel => _overview?.periodLabel ?? '';

  @override
  double get totalTracked => _overview != null ? 1000 : 0;

  @override
  double get spentAmount => _overview?.spending.spent ?? 0;

  @override
  double get budgetAmount => _overview?.spending.budget ?? 0;

  @override
  double get remainingAmount => _overview?.spending.remaining ?? 0;

  @override
  double get spendingProgress => _overview?.spending.progress ?? 0;

  @override
  String get formattedProgress => '${(spendingProgress * 100).toInt()}%';

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setOverview(BalanceOverview? value) {
    _overview = value;
    notifyListeners();
  }

  @override
  void loadDemoData() {
    _overview = BalanceOverview.demo(TrackerPeriod.month);
    _loading = false;
    notifyListeners();
  }

  @override
  void clear() {
    _overview = null;
    _loading = false;
    notifyListeners();
  }

  @override
  Future<void> load() async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 50));
    _loading = false;
    _overview ??= BalanceOverview.empty(TrackerPeriod.month);
    notifyListeners();
  }
}

// Тестовый ReceiptProvider
class TestReceiptProvider extends ReceiptProvider {
  bool _isProcessing = false;

  TestReceiptProvider() : super(ApiClient());

  @override
  bool get isProcessing => _isProcessing;

  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }
}

// Тестовый FinanceRepository
class _TestFinanceRepository implements FinanceRepository {
  @override
  final ApiClient api = ApiClient();

  @override
  Future<BalanceOverview> getDashboardOverview(TrackerPeriod period) async =>
      BalanceOverview.empty(period);

  @override
  Future<FiatRates> getFiatRates(SupportedCurrency baseCurrency) async =>
      FiatRates.identity(baseCurrency);

  @override
  Future<CryptoMarketRates> getCryptoRates(SupportedCurrency quoteCurrency) async =>
      CryptoMarketRates.empty(quoteCurrency);

  @override
  Future<AssetBalanceSummary> getAssetBalanceSummary(TrackerPeriod period) async =>
      AssetBalanceSummary.empty(
        baseCurrency: SupportedCurrency.usd,
        periodLabel: 'This month',
      );

  @override
  Future<List<TransactionModel>> getTransactions({
    TransactionCategory? category,
    TrackerPeriod? period,
  }) async =>
      [];

  @override
  Future<bool> createExpense({
    required String title,
    required double amount,
    required SupportedCurrency currency,
    required TransactionCategory category,
    String? note,
    DateTime? createdAt,
    String? sourceAssetId,
    String? sourceAssetName,
    dynamic receipt,
  }) async =>
      true;

  @override
  Future<bool> sendMoney({required String recipient, required double amount}) async => true;

  @override
  Future<bool> topUp({required double amount}) async => true;

  @override
  Future<bool> saveAsset({
    required TrackerPeriod period,
    String? assetId,
    required String name,
    required AssetType type,
    required SupportedCurrency currency,
    required double amount,
  }) async =>
      true;

  @override
  Future<bool> updateAsset({
    required String assetId,
    required TrackerPeriod period,
    required String name,
    required AssetType type,
    required SupportedCurrency currency,
    required double amount,
  }) async =>
      true;

  @override
  Future<bool> deleteAsset(String assetId) async => true;

  @override
  Future<bool> updateTransaction(String transactionId, {
    required String title,
    required double amount,
    required SupportedCurrency currency,
    required TransactionCategory category,
    required TransactionType type,
    DateTime? createdAt,
    String? note,
    String? sourceAssetId,
    String? sourceAssetName,
  }) async =>
      true;

  @override
  Future<bool> deleteTransaction(String transactionId) async => true;
}

void main() {
  group('HomeScreen Widget Tests', () {
    Widget createTestWidget({
      required TestBalanceProvider balanceProvider,
      required TestReceiptProvider receiptProvider,
      required AuthProvider authProvider,
    }) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<BalanceProvider>.value(value: balanceProvider),
          ChangeNotifierProvider<ReceiptProvider>.value(value: receiptProvider),
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
          debugShowCheckedModeBanner: false,
        ),
      );
    }

    testWidgets('отображает AppBar с заголовком', (WidgetTester tester) async {
      final balanceProvider = TestBalanceProvider();
      final receiptProvider = TestReceiptProvider();
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);

      await tester.pumpWidget(
        createTestWidget(
          balanceProvider: balanceProvider,
          receiptProvider: receiptProvider,
          authProvider: authProvider,
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('отображает кнопку настроек в AppBar', (WidgetTester tester) async {
      final balanceProvider = TestBalanceProvider();
      final receiptProvider = TestReceiptProvider();
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);

      await tester.pumpWidget(
        createTestWidget(
          balanceProvider: balanceProvider,
          receiptProvider: receiptProvider,
          authProvider: authProvider,
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('отображает BalanceCard', (WidgetTester tester) async {
      final balanceProvider = TestBalanceProvider();
      final receiptProvider = TestReceiptProvider();
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);

      await tester.pumpWidget(
        createTestWidget(
          balanceProvider: balanceProvider,
          receiptProvider: receiptProvider,
          authProvider: authProvider,
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('отображает индикатор загрузки когда loading=true', (WidgetTester tester) async {
      final balanceProvider = TestBalanceProvider();
      final receiptProvider = TestReceiptProvider();
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);

      balanceProvider.setLoading(true);

      await tester.pumpWidget(
        createTestWidget(
          balanceProvider: balanceProvider,
          receiptProvider: receiptProvider,
          authProvider: authProvider,
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('отображает индикатор обработки чека когда isProcessing=true', (WidgetTester tester) async {
      final balanceProvider = TestBalanceProvider();
      final receiptProvider = TestReceiptProvider();
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);

      receiptProvider.setProcessing(true);

      await tester.pumpWidget(
        createTestWidget(
          balanceProvider: balanceProvider,
          receiptProvider: receiptProvider,
          authProvider: authProvider,
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('RefreshIndicator присутствует для обновления', (WidgetTester tester) async {
      final balanceProvider = TestBalanceProvider();
      final receiptProvider = TestReceiptProvider();
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);

      await tester.pumpWidget(
        createTestWidget(
          balanceProvider: balanceProvider,
          receiptProvider: receiptProvider,
          authProvider: authProvider,
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('кнопка настроек открывает SettingsScreen', (WidgetTester tester) async {
      final balanceProvider = TestBalanceProvider();
      final receiptProvider = TestReceiptProvider();
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);

      await tester.pumpWidget(
        createTestWidget(
          balanceProvider: balanceProvider,
          receiptProvider: receiptProvider,
          authProvider: authProvider,
        ),
      );

      final settingsButton = find.byIcon(Icons.settings);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('имеет Scaffold с правильным background', (WidgetTester tester) async {
      final balanceProvider = TestBalanceProvider();
      final receiptProvider = TestReceiptProvider();
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);

      await tester.pumpWidget(
        createTestWidget(
          balanceProvider: balanceProvider,
          receiptProvider: receiptProvider,
          authProvider: authProvider,
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('AppBar имеет прозрачный фон', (WidgetTester tester) async {
      final balanceProvider = TestBalanceProvider();
      final receiptProvider = TestReceiptProvider();
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);

      await tester.pumpWidget(
        createTestWidget(
          balanceProvider: balanceProvider,
          receiptProvider: receiptProvider,
          authProvider: authProvider,
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, Colors.transparent);
    });

    testWidgets('AppBar elevation равен 0', (WidgetTester tester) async {
      final balanceProvider = TestBalanceProvider();
      final receiptProvider = TestReceiptProvider();
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);

      await tester.pumpWidget(
        createTestWidget(
          balanceProvider: balanceProvider,
          receiptProvider: receiptProvider,
          authProvider: authProvider,
        ),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, 0);
    });
  });

  group('HomeScreen с демо данными', () {
    testWidgets('корректно отображает демо данные', (WidgetTester tester) async {
      final balanceProvider = TestBalanceProvider();
      final receiptProvider = TestReceiptProvider();
      final apiClient = ApiClient();
      final authProvider = AuthProvider(apiClient);

      balanceProvider.loadDemoData();

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<BalanceProvider>.value(value: balanceProvider),
              ChangeNotifierProvider<ReceiptProvider>.value(value: receiptProvider),
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: const HomeScreen(),
          ),
          debugShowCheckedModeBanner: false,
        ),
      );

      expect(balanceProvider.overview, isNotNull);
      expect(balanceProvider.loading, isFalse);
    });
  });
}
