import 'package:flutter/material.dart';
import '../../core/utils/formatter.dart';
import '../../data/models/balance.dart';
import '../../data/repositories/finance_repository.dart';

/// Provider responsible for managing balance-related data and operations.
///
/// This provider handles:
/// - Loading and caching balance overview data
/// - Managing fiat and cryptocurrency rates
/// - Handling asset operations (add, update, delete)
/// - Currency and period selection
/// - Demo vs real mode switching
/// - Loading asset balance summary (total assets and spent balance)
class BalanceProvider extends ChangeNotifier {
  final FinanceRepository repo;

  /// Creates a BalanceProvider instance with the given repository
  BalanceProvider(this.repo);

  /// Current balance overview data including assets and spending
  BalanceOverview? overview;

  /// Сводка по активам: общий баланс и потраченный баланс
  AssetBalanceSummary? assetBalanceSummary;

  /// Fiat currency exchange rates
  FiatRates? fiatRates;

  /// Cryptocurrency market rates
  CryptoMarketRates? cryptoRates;

  /// Currently selected currency for display
  SupportedCurrency selectedCurrency = SupportedCurrency.usd;

  /// Currently selected time period for tracking
  TrackerPeriod selectedPeriod = TrackerPeriod.month;

  /// Loading state indicator
  bool loading = false;

  /// Internal flag to track demo mode
  bool _isDemoMode = false;

  Future<void> load() async {
    _isDemoMode = false;
    loading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        repo.getDashboardOverview(selectedPeriod),
        repo.getFiatRates(selectedCurrency),
        repo.getCryptoRates(selectedCurrency),
        repo.getAssetBalanceSummary(selectedPeriod),
      ], eagerError: true);

      overview = results[0] as BalanceOverview;
      fiatRates = results[1] as FiatRates;
      cryptoRates = results[2] as CryptoMarketRates;
      assetBalanceSummary = results[3] as AssetBalanceSummary;
      _syncSelectedCurrency();
    } catch (e) {
      debugPrint('Error loading balance data: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void loadDemoData() {
    _isDemoMode = true;
    overview = BalanceOverview.demo(selectedPeriod);
    assetBalanceSummary = AssetBalanceSummary(
      totalAssets: overview!.assets.fold<double>(0, (sum, asset) => 
        sum + (asset.currentValue > 0 ? asset.currentValue : asset.amount)
      ),
      spentBalance: overview!.spending.spent,
      baseCurrency: selectedCurrency,
      periodLabel: overview!.periodLabel,
    );
    fiatRates = FiatRates.demo(selectedCurrency);
    cryptoRates = CryptoMarketRates.demo(selectedCurrency);
    loading = false;
    notifyListeners();
  }

  void clear() {
    _isDemoMode = false;
    overview = null;
    assetBalanceSummary = null;
    fiatRates = null;
    cryptoRates = null;
    loading = false;
    notifyListeners();
  }

  void selectCurrency(SupportedCurrency currency) {
    if (!currency.isFiat) {
      return;
    }
    selectedCurrency = currency;
    if (_isDemoMode) {
      loadDemoData();
      return;
    }
    load();
  }

  void selectPeriod(TrackerPeriod period) {
    selectedPeriod = period;
    if (_isDemoMode) {
      loadDemoData();
      return;
    }
    load();
  }

  List<TrackedAsset> get assets => overview?.assets ?? const [];
  List<TrackedAsset> get spendingAccounts => assets;

  SpendingOverview? get spending => overview?.spending;

  String get periodLabel => overview?.periodLabel ?? '';

  double get totalTracked {
    final currentOverview = overview;
    if (currentOverview == null) {
      return 0;
    }

    // Используем currentValue из активов - это уже конвертированная сумма в базовой валюте
    // Если currentValue = 0, используем amount (для демо данных)
    return currentOverview.assets.fold<double>(0, (sum, asset) => 
      sum + (asset.currentValue > 0 ? asset.currentValue : asset.amount)
    );
  }

  double get spentAmount => spending?.spent ?? 0;

  double get budgetAmount => spending?.budget ?? 0;

  double get remainingAmount => spending?.remaining ?? 0;

  double get spendingProgress => spending?.progress ?? 0;

  String get formattedProgress {
    // Используем progressText который показывает spent даже без бюджета
    return spending?.progressText ?? Formatter.formatPercent(spendingProgress);
  }

  /// Геттеры для AssetBalanceSummary
  double get totalAssetsBalance => assetBalanceSummary?.totalAssets ?? 0;
  double get spentAssetsBalance => assetBalanceSummary?.spentBalance ?? 0;
  double get netAssetsBalance => assetBalanceSummary?.netBalance ?? 0;
  String get assetsPeriodLabel => assetBalanceSummary?.periodLabel ?? '';

  /// Adds a new asset to the user's portfolio
  ///
  /// Performs an optimistic update by adding the asset to the local state immediately,
  /// then attempts to save the asset to the backend. If the backend operation fails,
  /// the local change is rolled back.
  ///
  /// Returns true if the asset was successfully added to the backend, false otherwise.
  Future<bool> addAsset({
    required String name,
    required AssetType type,
    required SupportedCurrency currency,
    required double amount,
  }) async {
    final asset = TrackedAsset(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: type,
      currency: currency,
      amount: amount,
    );

    final currentOverview = overview ?? BalanceOverview.demo(selectedPeriod);
    final previousOverview = overview; // Store for potential rollback
    
    overview = currentOverview.copyWith(
      assets: [...currentOverview.assets, asset],
    );
    notifyListeners();

    final success = await repo.saveAsset(
      period: selectedPeriod,
      name: name,
      type: type,
      currency: currency,
      amount: amount,
    );

    if (success) {
      await load();
    } else {
      // Rollback the optimistic update if saving failed
      overview = previousOverview;
      notifyListeners();
    }

    return success;
  }

  /// Updates an existing asset in the user's portfolio
  ///
  /// Performs an optimistic update by modifying the asset in the local state immediately,
  /// then attempts to update the asset on the backend. If the backend operation fails,
  /// the local change is rolled back to the original state.
  ///
  /// Returns true if the asset was successfully updated on the backend, false otherwise.
  Future<bool> updateAsset({
    required String assetId,
    required String name,
    required AssetType type,
    required SupportedCurrency currency,
    required double amount,
  }) async {
    final currentOverview = overview;
    if (currentOverview == null) {
      return false;
    }

    // Store original state for potential rollback
    final originalOverview = currentOverview;
    
    // Create updated asset list
    final updatedAssets = currentOverview.assets.map((asset) {
      if (asset.id == assetId) {
        return asset.copyWith(
          name: name,
          type: type,
          currency: currency,
          amount: amount,
        );
      }
      return asset;
    }).toList();

    // Optimistically update the UI
    overview = currentOverview.copyWith(assets: updatedAssets);
    notifyListeners();

    final success = await repo.updateAsset(
      assetId: assetId,
      period: selectedPeriod,
      name: name,
      type: type,
      currency: currency,
      amount: amount,
    );

    if (!success) {
      // Rollback the optimistic update if saving failed
      overview = originalOverview;
      notifyListeners();
    } else {
      await load(); // Reload to get fresh data from server
    }

    return success;
  }

  /// Deletes an asset from the user's portfolio
  ///
  /// Performs an optimistic update by removing the asset from the local state immediately,
  /// then attempts to delete the asset from the backend. If the backend operation fails,
  /// the local change is rolled back to restore the asset.
  ///
  /// Returns true if the asset was successfully deleted from the backend, false otherwise.
  Future<bool> deleteAsset(String assetId) async {
    final currentOverview = overview;
    if (currentOverview == null) {
      return false;
    }

    // Store original state for potential rollback
    final originalOverview = currentOverview;
    
    // Remove the asset optimistically
    final updatedAssets = currentOverview.assets
        .where((asset) => asset.id != assetId)
        .toList();
    
    overview = currentOverview.copyWith(assets: updatedAssets);
    notifyListeners();

    final success = await repo.deleteAsset(assetId);
    
    if (!success) {
      // Rollback the optimistic update if deletion failed
      overview = originalOverview;
      notifyListeners();
    } else {
      await load(); // Reload to get fresh data from server
    }
    
    return success;
  }

  void registerExpenseLocally({
    required double amount,
    required SupportedCurrency currency,
    String? assetId,
  }) {
    final currentOverview = overview;
    final currentSpending = spending;
    final currentRates = fiatRates;
    final currentCryptoRates = cryptoRates;

    if (currentOverview == null ||
        currentSpending == null ||
        currentRates == null ||
        currentCryptoRates == null) {
      return;
    }

    final amountInSelectedFiat = currency == selectedCurrency
        ? amount
        : amount / currentRates.rateFor(currency);

    overview = currentOverview.copyWith(
      spending: currentSpending.copyWith(
        spent: currentSpending.spent + amountInSelectedFiat,
      ),
      assets: currentOverview.assets.map((asset) {
        if (assetId == null || asset.id != assetId) {
          return asset;
        }

        final amountInAssetCurrency = _convertAmount(
          amount: amount,
          from: currency,
          to: asset.currency,
          fiatRates: currentRates,
          cryptoRates: currentCryptoRates,
        );

        return asset.copyWith(amount: (asset.amount - amountInAssetCurrency));
      }).toList(),
    );
    notifyListeners();
  }

  void _syncSelectedCurrency() {
    if (!selectedCurrency.isFiat) {
      selectedCurrency = SupportedCurrency.usd;
    }
    if (!SupportedCurrencyX.fiatValues.contains(selectedCurrency)) {
      selectedCurrency = SupportedCurrency.usd;
    }
    final currentOverview = overview;
    if (currentOverview == null || currentOverview.assets.isEmpty) {
      return;
    }
  }

  double _convertAmount({
    required double amount,
    required SupportedCurrency from,
    required SupportedCurrency to,
    required FiatRates fiatRates,
    required CryptoMarketRates cryptoRates,
  }) {
    if (from == to) {
      return amount;
    }

    final amountInUsd = _toUsd(
      amount: amount,
      currency: from,
      fiatRates: fiatRates,
      cryptoRates: cryptoRates,
    );

    return _fromUsd(
      amount: amountInUsd,
      currency: to,
      fiatRates: fiatRates,
      cryptoRates: cryptoRates,
    );
  }

  double _toUsd({
    required double amount,
    required SupportedCurrency currency,
    required FiatRates fiatRates,
    required CryptoMarketRates cryptoRates,
  }) {
    if (currency == SupportedCurrency.usd) {
      return amount;
    }
    final selectedToUsd = _selectedFiatToUsd(fiatRates);
    if (currency.isCrypto) {
      final priceInSelectedFiat = cryptoRates.priceFor(currency);
      if (priceInSelectedFiat <= 0) {
        return amount;
      }
      return amount * priceInSelectedFiat * selectedToUsd;
    }

    final baseToCurrencyRate = fiatRates.rateFor(currency);
    if (baseToCurrencyRate <= 0) {
      return amount;
    }
    return (amount / baseToCurrencyRate) * selectedToUsd;
  }

  double _fromUsd({
    required double amount,
    required SupportedCurrency currency,
    required FiatRates fiatRates,
    required CryptoMarketRates cryptoRates,
  }) {
    if (currency == SupportedCurrency.usd) {
      return amount;
    }
    final selectedToUsd = _selectedFiatToUsd(fiatRates);
    if (currency.isCrypto) {
      final priceInSelectedFiat = cryptoRates.priceFor(currency);
      final priceInUsd = priceInSelectedFiat * selectedToUsd;
      if (priceInUsd <= 0) {
        return amount;
      }
      return amount / priceInUsd;
    }

    if (selectedToUsd <= 0) {
      return amount;
    }
    final amountInSelectedFiat = amount / selectedToUsd;
    return amountInSelectedFiat * fiatRates.rateFor(currency);
  }

  double _selectedFiatToUsd(FiatRates fiatRates) {
    final selectedRate = fiatRates.rateFor(SupportedCurrency.usd);
    if (selectedRate <= 0) {
      return 1;
    }
    return selectedRate;
  }
}
