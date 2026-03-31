import 'balance.dart';

enum TransactionType { expense, income, transfer }

extension TransactionTypeX on TransactionType {
  String get apiValue => switch (this) {
    TransactionType.expense => 'expense',
    TransactionType.income => 'income',
    TransactionType.transfer => 'transfer',
  };

  static TransactionType fromValue(String? value, {double? amount}) {
    switch (value?.toLowerCase()) {
      case 'expense':
        return TransactionType.expense;
      case 'income':
        return TransactionType.income;
      case 'transfer':
        return TransactionType.transfer;
      default:
        if ((amount ?? 0) < 0) {
          return TransactionType.expense;
        }
        if ((amount ?? 0) > 0) {
          return TransactionType.income;
        }
        return TransactionType.transfer;
    }
  }
}

enum TransactionCategory {
  food,
  transport,
  shopping,
  bills,
  salary,
  crypto,
  subscriptions,
  entertainment,
  health,
  education,
  travel,
  transfer,
  other,
}

extension TransactionCategoryX on TransactionCategory {
  static const List<TransactionCategory> expenseValues = [
    TransactionCategory.food,
    TransactionCategory.transport,
    TransactionCategory.shopping,
    TransactionCategory.bills,
    TransactionCategory.crypto,
    TransactionCategory.subscriptions,
    TransactionCategory.entertainment,
    TransactionCategory.health,
    TransactionCategory.education,
    TransactionCategory.travel,
    TransactionCategory.other,
  ];

  String get apiValue => switch (this) {
    TransactionCategory.food => 'food',
    TransactionCategory.transport => 'transport',
    TransactionCategory.shopping => 'shopping',
    TransactionCategory.bills => 'bills',
    TransactionCategory.salary => 'salary',
    TransactionCategory.crypto => 'crypto',
    TransactionCategory.subscriptions => 'subscriptions',
    TransactionCategory.entertainment => 'entertainment',
    TransactionCategory.health => 'health',
    TransactionCategory.education => 'education',
    TransactionCategory.travel => 'travel',
    TransactionCategory.transfer => 'transfer',
    TransactionCategory.other => 'other',
  };

  static TransactionCategory fromValue(String? value) {
    return TransactionCategory.values.firstWhere(
      (category) => category.apiValue == value,
      orElse: () => TransactionCategory.other,
    );
  }

  String localizedLabel(String languageCode) {
    final isRussian = languageCode.toLowerCase().startsWith('ru');
    return switch (this) {
      TransactionCategory.food => isRussian ? 'Еда' : 'Food',
      TransactionCategory.transport => isRussian ? 'Транспорт' : 'Transport',
      TransactionCategory.shopping => isRussian ? 'Покупки' : 'Shopping',
      TransactionCategory.bills => isRussian ? 'Счета' : 'Bills',
      TransactionCategory.salary => isRussian ? 'Доход' : 'Salary',
      TransactionCategory.crypto => isRussian ? 'Крипта' : 'Crypto',
      TransactionCategory.subscriptions =>
        isRussian ? 'Подписки' : 'Subscriptions',
      TransactionCategory.entertainment =>
        isRussian ? 'Развлечения' : 'Entertainment',
      TransactionCategory.health => isRussian ? 'Здоровье' : 'Health',
      TransactionCategory.education => isRussian ? 'Обучение' : 'Education',
      TransactionCategory.travel => isRussian ? 'Путешествия' : 'Travel',
      TransactionCategory.transfer => isRussian ? 'Переводы' : 'Transfers',
      TransactionCategory.other => isRussian ? 'Другое' : 'Other',
    };
  }
}

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final SupportedCurrency currency;
  final TransactionCategory category;
  final TransactionType type;
  final DateTime createdAt;
  final String? note;
  final String? sourceAssetId;
  final String? sourceAssetName;
  final String? receiptId;
  final double? receiptConfidence;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.category,
    required this.type,
    required this.createdAt,
    this.note,
    this.sourceAssetId,
    this.sourceAssetName,
    this.receiptId,
    this.receiptConfidence,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final rawAmount = (json['amount'] as num? ?? 0).toDouble();
    final sourceAsset =
        json['sourceAsset'] as Map<String, dynamic>? ??
        json['account'] as Map<String, dynamic>?;
    final receipt = json['receipt'] as Map<String, dynamic>?;
    return TransactionModel(
      id:
          json['id'] as String? ??
          json['transactionId'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title:
          json['title'] as String? ??
          json['name'] as String? ??
          json['merchant'] as String? ??
          'Transaction',
      amount: rawAmount,
      currency: SupportedCurrencyX.fromCode(
        json['currency'] as String? ?? 'USD',
      ),
      category: TransactionCategoryX.fromValue(json['category'] as String?),
      type: TransactionTypeX.fromValue(
        json['type'] as String? ?? json['kind'] as String?,
        amount: rawAmount,
      ),
      createdAt:
          DateTime.tryParse(
            json['createdAt'] as String? ??
                json['occurredAt'] as String? ??
                json['date'] as String? ??
                json['timestamp'] as String? ??
                '',
          ) ??
          DateTime.now(),
      note: json['note'] as String? ?? json['description'] as String?,
      sourceAssetId:
          json['sourceAssetId'] as String? ??
          json['accountId'] as String? ??
          sourceAsset?['id'] as String?,
      sourceAssetName:
          json['sourceAssetName'] as String? ??
          json['accountName'] as String? ??
          json['assetName'] as String? ??
          sourceAsset?['name'] as String?,
      receiptId:
          json['receiptId'] as String? ??
          receipt?['id'] as String? ??
          receipt?['receiptId'] as String?,
      receiptConfidence:
          (json['receiptConfidence'] as num? ?? receipt?['confidence'] as num?)
              ?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'currency': currency.code,
    'category': category.apiValue,
    'type': type.apiValue,
    'createdAt': createdAt.toIso8601String(),
    if (note != null) 'note': note,
    if (sourceAssetId != null) 'sourceAssetId': sourceAssetId,
    if (sourceAssetName != null) 'sourceAssetName': sourceAssetName,
    if (receiptId != null) 'receiptId': receiptId,
    if (receiptConfidence != null) 'receiptConfidence': receiptConfidence,
  };

  TransactionModel copyWith({
    String? id,
    String? title,
    double? amount,
    SupportedCurrency? currency,
    TransactionCategory? category,
    TransactionType? type,
    DateTime? createdAt,
    String? note,
    String? sourceAssetId,
    String? sourceAssetName,
    String? receiptId,
    double? receiptConfidence,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      sourceAssetId: sourceAssetId ?? this.sourceAssetId,
      sourceAssetName: sourceAssetName ?? this.sourceAssetName,
      receiptId: receiptId ?? this.receiptId,
      receiptConfidence: receiptConfidence ?? this.receiptConfidence,
    );
  }

  static List<TransactionModel> demoList() {
    return [
      TransactionModel(
        id: 'tx_1',
        title: 'Magnum',
        amount: -42.8,
        currency: SupportedCurrency.usd,
        category: TransactionCategory.food,
        type: TransactionType.expense,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        note: 'Groceries and daily essentials',
        sourceAssetName: 'Main Card',
      ),
      TransactionModel(
        id: 'tx_2',
        title: 'Uber',
        amount: -9.2,
        currency: SupportedCurrency.usd,
        category: TransactionCategory.transport,
        type: TransactionType.expense,
        createdAt: DateTime.now().subtract(const Duration(hours: 10)),
        sourceAssetName: 'Daily Cash',
      ),
      TransactionModel(
        id: 'tx_3',
        title: 'Salary',
        amount: 1200,
        currency: SupportedCurrency.usd,
        category: TransactionCategory.salary,
        type: TransactionType.income,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        sourceAssetName: 'Payroll Account',
      ),
      TransactionModel(
        id: 'tx_4',
        title: 'Binance',
        amount: -250,
        currency: SupportedCurrency.usd,
        category: TransactionCategory.crypto,
        type: TransactionType.expense,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        note: 'Top-up for BTC purchase',
        sourceAssetName: 'USD Card',
      ),
      TransactionModel(
        id: 'tx_5',
        title: 'Netflix',
        amount: -14.99,
        currency: SupportedCurrency.usd,
        category: TransactionCategory.subscriptions,
        type: TransactionType.expense,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        sourceAssetName: 'Main Card',
      ),
      TransactionModel(
        id: 'tx_6',
        title: 'Internal transfer',
        amount: 300,
        currency: SupportedCurrency.usd,
        category: TransactionCategory.transfer,
        type: TransactionType.transfer,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        note: 'Savings account movement',
        sourceAssetName: 'Savings account',
      ),
    ];
  }
}
