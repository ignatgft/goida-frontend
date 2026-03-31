import 'package:flutter_test/flutter_test.dart';
import 'package:demo2/data/models/balance.dart';
import 'package:demo2/data/models/transaction.dart';
import 'package:demo2/data/models/receipt_scan.dart';
import 'package:demo2/data/repositories/finance_repository.dart';
import 'package:demo2/presentation/providers/balance_provider.dart';
import 'package:demo2/core/api/api_client.dart';

// Простая тестовая реализация FinanceRepository
class TestFinanceRepository implements FinanceRepository {
  @override
  final ApiClient api;

  BalanceOverview? _overviewToReturn;
  FiatRates? _fiatRatesToReturn;
  CryptoMarketRates? _cryptoRatesToReturn;
  List<TransactionModel> _transactions = [];
  bool shouldFail = false;

  TestFinanceRepository({
    required this.api,
    BalanceOverview? overviewToReturn,
    FiatRates? fiatRatesToReturn,
    CryptoMarketRates? cryptoRatesToReturn,
    List<TransactionModel>? transactions,
    this.shouldFail = false,
  })  : _overviewToReturn = overviewToReturn,
        _fiatRatesToReturn = fiatRatesToReturn,
        _cryptoRatesToReturn = cryptoRatesToReturn,
        _transactions = transactions ?? [];

  @override
  Future<BalanceOverview> getDashboardOverview(TrackerPeriod period) async {
    if (shouldFail) throw Exception('Network error');
    return _overviewToReturn ?? BalanceOverview.empty(period);
  }

  @override
  Future<FiatRates> getFiatRates(SupportedCurrency baseCurrency) async {
    if (shouldFail) throw Exception('Network error');
    return _fiatRatesToReturn ?? FiatRates.identity(baseCurrency);
  }

  @override
  Future<CryptoMarketRates> getCryptoRates(SupportedCurrency quoteCurrency) async {
    if (shouldFail) throw Exception('Network error');
    return _cryptoRatesToReturn ?? CryptoMarketRates.empty(quoteCurrency);
  }

  @override
  Future<AssetBalanceSummary> getAssetBalanceSummary(TrackerPeriod period) async {
    if (shouldFail) throw Exception('Network error');
    return AssetBalanceSummary.empty(
      baseCurrency: SupportedCurrency.usd,
      periodLabel: 'This month',
    );
  }

  @override
  Future<List<TransactionModel>> getTransactions({
    TransactionCategory? category,
    TrackerPeriod? period,
  }) async {
    if (shouldFail) throw Exception('Network error');
    return _transactions;
  }

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
    ReceiptScanResult? receipt,
  }) async {
    if (shouldFail) return false;
    return true;
  }

  @override
  Future<bool> sendMoney({required String recipient, required double amount}) async {
    if (shouldFail) return false;
    return true;
  }

  @override
  Future<bool> topUp({required double amount}) async {
    if (shouldFail) return false;
    return true;
  }

  @override
  Future<bool> saveAsset({
    required TrackerPeriod period,
    String? assetId,
    required String name,
    required AssetType type,
    required SupportedCurrency currency,
    required double amount,
  }) async {
    if (shouldFail) return false;
    return true;
  }

  @override
  Future<bool> updateAsset({
    required String assetId,
    required TrackerPeriod period,
    required String name,
    required AssetType type,
    required SupportedCurrency currency,
    required double amount,
  }) async {
    if (shouldFail) return false;
    return true;
  }

  @override
  Future<bool> deleteAsset(String assetId) async {
    if (shouldFail) return false;
    return true;
  }

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
  }) async {
    if (shouldFail) return false;
    return true;
  }

  @override
  Future<bool> deleteTransaction(String transactionId) async {
    if (shouldFail) return false;
    return true;
  }
}

void main() {
  group('BalanceProvider', () {
    late ApiClient apiClient;
    late BalanceProvider provider;

    setUp(() {
      apiClient = ApiClient();
    });

    tearDown(() {
      provider.dispose();
    });

    group('начальное состояние', () {
      test('поля инициализированы корректно', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);

        expect(provider.overview, isNull);
        expect(provider.fiatRates, isNull);
        expect(provider.cryptoRates, isNull);
        expect(provider.selectedCurrency, SupportedCurrency.usd);
        expect(provider.selectedPeriod, TrackerPeriod.month);
        expect(provider.loading, isFalse);
      });
    });

    group('loadDemoData', () {
      test('загружает демо данные', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);

        provider.loadDemoData();

        expect(provider.overview, isNotNull);
        expect(provider.fiatRates, isNotNull);
        expect(provider.cryptoRates, isNotNull);
        expect(provider.assets.isNotEmpty, isTrue);
        expect(provider.spentAmount, greaterThan(0));
      });

      test('устанавливает loading в false', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);

        provider.loadDemoData();

        expect(provider.loading, isFalse);
      });
    });

    group('clear', () {
      test('очищает все данные', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);
        provider.loadDemoData();

        provider.clear();

        expect(provider.overview, isNull);
        expect(provider.fiatRates, isNull);
        expect(provider.cryptoRates, isNull);
        expect(provider.assets, isEmpty);
      });
    });

    group('геттеры', () {
      test('assets возвращает пустой список если overview null', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);

        expect(provider.assets, isEmpty);
      });

      test('assets возвращает список активов', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);
        provider.loadDemoData();

        expect(provider.assets, isNotEmpty);
      });

      test('spending возвращает null если overview null', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);

        expect(provider.spending, isNull);
      });

      test('spending возвращает SpendingOverview', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);
        provider.loadDemoData();

        expect(provider.spending, isNotNull);
      });

      test('periodLabel возвращает пустую строку если overview null', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);

        expect(provider.periodLabel, isEmpty);
      });

      test('totalTracked возвращает 0 если данные не загружены', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);

        expect(provider.totalTracked, 0);
      });

      test('spentAmount возвращает 0 если spending null', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);

        expect(provider.spentAmount, 0);
      });

      test('budgetAmount возвращает 0 если spending null', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);

        expect(provider.budgetAmount, 0);
      });

      test('remainingAmount возвращает 0 если spending null', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);

        expect(provider.remainingAmount, 0);
      });

      test('spendingProgress возвращает 0 если spending null', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);

        expect(provider.spendingProgress, 0);
      });

      test('formattedProgress возвращает форматированный процент', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = BalanceProvider(repo);
        provider.loadDemoData();

        expect(provider.formattedProgress, isNotEmpty);
        expect(provider.formattedProgress, contains('%'));
      });
    });

    group('loadData', () {
      test('загружает данные', () async {
        final overview = BalanceOverview.demo(TrackerPeriod.month);
        final repo = TestFinanceRepository(
          api: apiClient,
          overviewToReturn: overview,
        );
        provider = BalanceProvider(repo);

        provider.loadDemoData();

        expect(provider.overview, isNotNull);
        expect(provider.loading, isFalse);
      });
    });

    group('loadFiatRates', () {
      test('загружает курсы валют', () async {
        final rates = FiatRates.demo(SupportedCurrency.usd);
        final repo = TestFinanceRepository(
          api: apiClient,
          fiatRatesToReturn: rates,
        );
        provider = BalanceProvider(repo);

        provider.loadDemoData();

        expect(provider.fiatRates, isNotNull);
        expect(provider.fiatRates?.baseCurrency, SupportedCurrency.usd);
      });
    });

    group('loadCryptoRates', () {
      test('загружает крипто курсы', () async {
        final rates = CryptoMarketRates.demo(SupportedCurrency.usd);
        final repo = TestFinanceRepository(
          api: apiClient,
          cryptoRatesToReturn: rates,
        );
        provider = BalanceProvider(repo);

        provider.loadDemoData();

        expect(provider.cryptoRates, isNotNull);
      });
    });
  });
}
