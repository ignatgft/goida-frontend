import 'package:flutter_test/flutter_test.dart';
import 'package:demo2/data/models/balance.dart';
import 'package:demo2/data/models/transaction.dart';
import 'package:demo2/data/models/receipt_scan.dart';
import 'package:demo2/data/repositories/finance_repository.dart';
import 'package:demo2/presentation/providers/transaction_provider.dart';
import 'package:demo2/core/api/api_client.dart';

// Простая тестовая реализация FinanceRepository
class TestFinanceRepository implements FinanceRepository {
  @override
  final ApiClient api;

  final List<TransactionModel> _transactions;
  bool shouldFail = false;

  TestFinanceRepository({
    required this.api,
    List<TransactionModel>? transactions,
    this.shouldFail = false,
  }) : _transactions = transactions ?? [];

  @override
  Future<BalanceOverview> getDashboardOverview(TrackerPeriod period) async {
    if (shouldFail) throw Exception('Network error');
    return BalanceOverview.empty(period);
  }

  @override
  Future<FiatRates> getFiatRates(SupportedCurrency baseCurrency) async {
    if (shouldFail) throw Exception('Network error');
    return FiatRates.identity(baseCurrency);
  }

  @override
  Future<CryptoMarketRates> getCryptoRates(SupportedCurrency quoteCurrency) async {
    if (shouldFail) throw Exception('Network error');
    return CryptoMarketRates.empty(quoteCurrency);
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
  group('TransactionProvider', () {
    late ApiClient apiClient;
    late TransactionProvider provider;

    setUp(() {
      apiClient = ApiClient();
    });

    tearDown(() {
      provider.dispose();
    });

    group('начальное состояние', () {
      test('поля инициализированы корректно', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = TransactionProvider(repo);

        expect(provider.list, isEmpty);
        expect(provider.loading, isFalse);
      });
    });

    group('load', () {
      test('загружает транзакции из репозитория', () async {
        final transactions = [
          TransactionModel(
            id: '1',
            title: 'Test',
            amount: 100,
            currency: SupportedCurrency.usd,
            category: TransactionCategory.food,
            type: TransactionType.expense,
            createdAt: DateTime.now(),
          ),
        ];
        final repo = TestFinanceRepository(
          api: apiClient,
          transactions: transactions,
        );
        provider = TransactionProvider(repo);

        await provider.load();

        expect(provider.list, equals(transactions));
        expect(provider.loading, isFalse);
      });

      test('устанавливает loading в false после загрузки', () async {
        final repo = TestFinanceRepository(api: apiClient);
        provider = TransactionProvider(repo);

        await provider.load();

        expect(provider.loading, isFalse);
      });
    });

    group('clear', () {
      test('очищает список транзакций', () {
        final repo = TestFinanceRepository(
          api: apiClient,
          transactions: [
            TransactionModel(
              id: '1',
              title: 'Test',
              amount: 100,
              currency: SupportedCurrency.usd,
              category: TransactionCategory.food,
              type: TransactionType.expense,
              createdAt: DateTime.now(),
            ),
          ],
        );
        provider = TransactionProvider(repo);
        provider.loadDemoData();

        provider.clear();

        expect(provider.list, isEmpty);
      });
    });

    group('loadDemoData', () {
      test('загружает демо данные', () {
        final repo = TestFinanceRepository(api: apiClient);
        provider = TransactionProvider(repo);

        provider.loadDemoData();

        expect(provider.list, isNotEmpty);
        expect(provider.loading, isFalse);
      });
    });
  });
}
