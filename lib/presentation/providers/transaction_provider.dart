import 'package:flutter/material.dart';
import '../../data/models/balance.dart';
import '../../data/models/receipt_scan.dart';
import '../../data/models/transaction.dart';
import '../../data/repositories/finance_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final FinanceRepository repo;
  final List<TransactionModel> _pendingLocalExpenses = [];
  bool _isDemoMode = false;

  TransactionProvider(this.repo);

  List<TransactionModel> list = [];
  bool loading = false;
  TransactionCategory? selectedCategory;

  Future<void> load({TransactionCategory? category}) async {
    if (_isDemoMode) {
      selectedCategory = category;
      list = TransactionModel.demoList().where((tx) {
        return category == null || tx.category == category;
      }).toList();
      notifyListeners();
      return;
    }

    loading = true;
    selectedCategory = category;
    notifyListeners();

    final remote = await repo.getTransactions(category: category);
    list = _mergePendingWithRemote(remote, category);

    loading = false;
    notifyListeners();
  }

  void loadDemoData() {
    _isDemoMode = true;
    loading = false;
    selectedCategory = null;
    list = TransactionModel.demoList();
    notifyListeners();
  }

  void clear() {
    _isDemoMode = false;
    loading = false;
    selectedCategory = null;
    list = [];
    _pendingLocalExpenses.clear();
    notifyListeners();
  }

  Future<bool> updateTransaction({
    required String transactionId,
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
    if (_isDemoMode) {
      final index = list.indexWhere((tx) => tx.id == transactionId);
      if (index != -1) {
        list[index] = list[index].copyWith(
          title: title,
          amount: amount,
          category: category,
          type: type,
          note: note,
          createdAt: createdAt ?? list[index].createdAt,
        );
        notifyListeners();
        return true;
      }
      return false;
    }

    final success = await repo.updateTransaction(
      transactionId,
      title: title,
      amount: amount,
      currency: currency,
      category: category,
      type: type,
      createdAt: createdAt,
      note: note,
      sourceAssetId: sourceAssetId,
      sourceAssetName: sourceAssetName,
    );

    if (success) {
      await load(category: selectedCategory);
    }
    return success;
  }

  Future<bool> deleteTransaction(String transactionId) async {
    if (_isDemoMode) {
      list.removeWhere((tx) => tx.id == transactionId);
      notifyListeners();
      return true;
    }

    final success = await repo.deleteTransaction(transactionId);
    if (success) {
      await load(category: selectedCategory);
    }
    return success;
  }

  Future<bool> addExpense({
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
    final localExpense = TransactionModel(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      amount: amount.abs(),
      currency: currency,
      category: category,
      type: TransactionType.expense,
      createdAt: createdAt ?? DateTime.now(),
      note: note,
      sourceAssetId: sourceAssetId,
      sourceAssetName: sourceAssetName,
      receiptId: receipt?.id,
      receiptConfidence: receipt?.confidence,
    );

    _pendingLocalExpenses.insert(0, localExpense);
    list = _mergePendingWithRemote(list, selectedCategory);
    notifyListeners();

    final success = await repo.createExpense(
      title: title,
      amount: amount.abs(),
      currency: currency,
      category: category,
      note: note,
      createdAt: createdAt,
      sourceAssetId: sourceAssetId,
      sourceAssetName: sourceAssetName,
      receipt: receipt,
    );

    if (success) {
      _pendingLocalExpenses.removeWhere((tx) => tx.id == localExpense.id);
      await load(category: selectedCategory);
    }

    return success;
  }

  List<TransactionCategory> get availableCategories =>
      TransactionCategory.values;

  List<TransactionModel> _mergePendingWithRemote(
    List<TransactionModel> remote,
    TransactionCategory? category,
  ) {
    final filteredPending = _pendingLocalExpenses.where((tx) {
      return category == null || tx.category == category;
    });

    final merged = <String, TransactionModel>{};
    for (final tx in [...filteredPending, ...remote]) {
      merged[tx.id] = tx;
    }

    final items = merged.values.toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }
}
