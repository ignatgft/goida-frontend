import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../models/balance.dart';
import '../models/receipt_scan.dart';
import '../models/transaction.dart';

class FinanceRepository {
  final ApiClient api;

  FinanceRepository(this.api);

  Future<BalanceOverview> getDashboardOverview(TrackerPeriod period) async {
    try {
      final res = await api.get(
        Endpoints.dashboardOverview,
        // queryParameters: {'period': period.apiValue},
      );
      if (res.statusCode != null && (res.statusCode! < 200 || res.statusCode! >= 300)) {
        debugPrint('getDashboardOverview returned status code: ${res.statusCode}');
        return BalanceOverview.empty(period);
      }
      final data = _extractMap(
        res.data,
        preferredKeys: const ['overview', 'data'],
      );
      return BalanceOverview.fromJson(data).copyWith(
        periodLabel: data['periodLabel'] as String? ?? _periodLabel(period),
      );
    } on DioException catch (e) {
      debugPrint('DioException in getDashboardOverview: ${e.message}');
      return BalanceOverview.empty(period);
    } catch (e) {
      debugPrint('Error in getDashboardOverview: $e');
      return BalanceOverview.empty(period);
    }
  }

  Future<AssetBalanceSummary> getAssetBalanceSummary(TrackerPeriod period) async {
    try {
      final res = await api.get(
        Endpoints.assetBalanceSummary,
        queryParameters: {'period': period.apiValue},
      );
      if (res.statusCode != null && (res.statusCode! < 200 || res.statusCode! >= 300)) {
        debugPrint('getAssetBalanceSummary returned status code: ${res.statusCode}');
        return AssetBalanceSummary.empty(
          baseCurrency: SupportedCurrency.usd,
          periodLabel: _periodLabel(period),
        );
      }
      final data = _extractMap(res.data, preferredKeys: const ['data']);
      return AssetBalanceSummary.fromJson(data);
    } on DioException catch (e) {
      debugPrint('DioException in getAssetBalanceSummary: ${e.message}');
      return AssetBalanceSummary.empty(
        baseCurrency: SupportedCurrency.usd,
        periodLabel: _periodLabel(period),
      );
    } catch (e) {
      debugPrint('Error in getAssetBalanceSummary: $e');
      return AssetBalanceSummary.empty(
        baseCurrency: SupportedCurrency.usd,
        periodLabel: _periodLabel(period),
      );
    }
  }

  Future<FiatRates> getFiatRates(SupportedCurrency baseCurrency) async {
    try {
      final res = await api.get(
        Endpoints.fiatRates,
        // queryParameters: {'base': baseCurrency.code},
      );
      if (res.statusCode != null && (res.statusCode! < 200 || res.statusCode! >= 300)) {
        debugPrint('getFiatRates returned status code: ${res.statusCode}');
        return FiatRates.identity(baseCurrency);
      }
      final root = _extractMap(res.data, preferredKeys: const ['data']);
      final rates = root['rates'] is Map<String, dynamic>
          ? root['rates'] as Map<String, dynamic>
          : root;
      return FiatRates.fromJson({
        'baseCurrency': root['baseCurrency'] ?? baseCurrency.code,
        'rates': rates,
      });
    } on DioException catch (e) {
      debugPrint('DioException in getFiatRates: ${e.message}');
      return FiatRates.identity(baseCurrency);
    } catch (e) {
      debugPrint('Error in getFiatRates: $e');
      return FiatRates.identity(baseCurrency);
    }
  }

  Future<CryptoMarketRates> getCryptoRates(
    SupportedCurrency quoteCurrency,
  ) async {
    try {
      final res = await api.get(
        Endpoints.cryptoRates,
        /*
        queryParameters: {
          'fiat': quoteCurrency.code,
          'symbols': SupportedCurrencyX.cryptoValues
              .map((e) => e.code)
              .join(','),
        },
        */
      );
      if (res.statusCode != null && (res.statusCode! < 200 || res.statusCode! >= 300)) {
        debugPrint('getCryptoRates returned status code: ${res.statusCode}');
        return CryptoMarketRates.empty(quoteCurrency);
      }
      final root = _extractMap(res.data, preferredKeys: const ['data']);
      final prices = root['prices'] is Map<String, dynamic>
          ? root['prices'] as Map<String, dynamic>
          : root;
      return CryptoMarketRates.fromJson({
        'quoteCurrency': root['quoteCurrency'] ?? quoteCurrency.code,
        'prices': prices,
      });
    } on DioException catch (e) {
      debugPrint('DioException in getCryptoRates: ${e.message}');
      return CryptoMarketRates.empty(quoteCurrency);
    } catch (e) {
      debugPrint('Error in getCryptoRates: $e');
      return CryptoMarketRates.empty(quoteCurrency);
    }
  }

  Future<List<TransactionModel>> getTransactions({
    TransactionCategory? category,
    TrackerPeriod? period,
  }) async {
    try {
      final res = await api.get(
        Endpoints.transactions,
        /*
        queryParameters: {
          if (category != null) 'category': category.apiValue,
          if (period != null) 'period': period.apiValue,
        },
        */
      );

      final items = _extractList(
        res.data,
        preferredKeys: const ['items', 'transactions', 'data'],
      );
      return items
          .whereType<Map<String, dynamic>>()
          .map(TransactionModel.fromJson)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } on DioException {
      return [];
    } catch (_) {
      return [];
    }
  }

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
    try {
      // Форматируем дату в ISO8601 без микросекунд и с Z в конце для Spring Boot
      final dateStr = (createdAt ?? DateTime.now()).toUtc().toIso8601String().split('.').first + 'Z';

      final response = await api.post(Endpoints.transactions, {
        'title': title,
        'amount': amount.abs(),
        'currency': currency.code,
        'category': category.apiValue,
        'type': TransactionType.expense.apiValue,
        'createdAt': dateStr,
        if (note != null && note.isNotEmpty) 'note': note,
        if (sourceAssetId != null && sourceAssetId.isNotEmpty)
          'sourceAssetId': sourceAssetId,
        if (sourceAssetName != null && sourceAssetName.isNotEmpty)
          'sourceAssetName': sourceAssetName,
        if (receipt != null) 'receipt': receipt.toJson(),
      });
      
      if (response.statusCode != null && (response.statusCode! < 200 || response.statusCode! >= 300)) {
        debugPrint('createExpense returned status code: ${response.statusCode}');
        return false;
      }
      
      return true;
    } on DioException catch (e) {
      debugPrint('DioException in createExpense: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Error in createExpense: $e');
      return false;
    }
  }

  Future<bool> sendMoney({
    required String recipient,
    required double amount,
  }) async {
    try {
      await api.post(Endpoints.send, {
        'recipient': recipient,
        'amount': amount,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> topUp({
    required double amount,
  }) async {
    try {
      await api.post(Endpoints.topup, {
        'amount': amount,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> saveAsset({
    required TrackerPeriod period,
    String? assetId,
    required String name,
    required AssetType type,
    required SupportedCurrency currency,
    required double amount,
  }) async {
    try {
      final data = {
        'name': name,
        'type': type.apiValue,
        'symbol': currency.code,
        'balance': amount,
      };
      
      if (assetId != null && assetId.isNotEmpty) {
        await api.put('${Endpoints.assets}/$assetId', data);
      } else {
        await api.post(Endpoints.assets, data);
      }
      return true;
    } catch (e) {
      debugPrint('Error in saveAsset: $e');
      return false;
    }
  }

  Future<bool> updateAsset({
    required String assetId,
    required TrackerPeriod period,
    required String name,
    required AssetType type,
    required SupportedCurrency currency,
    required double amount,
  }) async {
    try {
      await api.put('${Endpoints.assets}/$assetId', {
        'name': name,
        'type': type.apiValue,
        'symbol': currency.code,
        'balance': amount,
      });
      return true;
    } catch (e) {
      debugPrint('Error in updateAsset: $e');
      return false;
    }
  }

  Future<bool> deleteAsset(String assetId) async {
    try {
      await api.delete('${Endpoints.assets}/$assetId');
      return true;
    } catch (_) {
      return false;
    }
  }

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
    try {
      final dateStr = (createdAt ?? DateTime.now()).toUtc().toIso8601String().split('.').first + 'Z';
      
      final response = await api.put('${Endpoints.transactions}/$transactionId', {
        'title': title,
        'amount': amount.abs(),
        'currency': currency.code,
        'category': category.apiValue,
        'type': type.apiValue,
        'createdAt': dateStr,
        if (note != null && note.isNotEmpty) 'note': note,
        if (sourceAssetId != null && sourceAssetId.isNotEmpty)
          'sourceAssetId': sourceAssetId,
        if (sourceAssetName != null && sourceAssetName.isNotEmpty)
          'sourceAssetName': sourceAssetName,
      });

      return response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300;
    } catch (e) {
      debugPrint('Error in updateTransaction: $e');
      return false;
    }
  }

  Future<bool> deleteTransaction(String transactionId) async {
    try {
      final response = await api.delete('${Endpoints.transactions}/$transactionId');
      return response.statusCode != null && response.statusCode! == 204;
    } catch (e) {
      debugPrint('Error in deleteTransaction: $e');
      return false;
    }
  }

  String _periodLabel(TrackerPeriod period) {
    return switch (period) {
      TrackerPeriod.week => 'This week',
      TrackerPeriod.month => 'This month',
      TrackerPeriod.year => 'This year',
    };
  }

  Map<String, dynamic> _extractMap(
    dynamic raw, {
    List<String> preferredKeys = const [],
  }) {
    if (raw is Map<String, dynamic>) {
      for (final key in preferredKeys) {
        final candidate = raw[key];
        if (candidate is Map<String, dynamic>) {
          return candidate;
        }
      }
      return raw;
    }
    return const {};
  }

  List<dynamic> _extractList(
    dynamic raw, {
    List<String> preferredKeys = const [],
  }) {
    if (raw is List<dynamic>) {
      return raw;
    }
    if (raw is Map<String, dynamic>) {
      for (final key in preferredKeys) {
        final candidate = raw[key];
        if (candidate is List<dynamic>) {
          return candidate;
        }
      }
    }
    return const [];
  }
}
