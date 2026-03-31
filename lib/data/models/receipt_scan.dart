import 'balance.dart';
import 'transaction.dart';

class ReceiptLineItem {
  final String title;
  final double price;
  final double quantity;

  const ReceiptLineItem({
    required this.title,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;

  factory ReceiptLineItem.fromJson(Map<String, dynamic> json) {
    final quantity = (json['quantity'] as num? ?? 1).toDouble();
    final totalPrice = (json['totalPrice'] as num?)?.toDouble();
    return ReceiptLineItem(
      title: json['title'] as String? ?? json['name'] as String? ?? 'Item',
      price:
          (json['price'] as num? ??
                  json['unitPrice'] as num? ??
                  (totalPrice != null && quantity != 0 ? totalPrice / quantity : null) ??
                  json['amount'] as num? ??
                  0)
              .toDouble(),
      quantity: quantity,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'price': price,
    'quantity': quantity,
  };
}

class ReceiptScanResult {
  final String? id;
  final String merchant;
  final double total;
  final SupportedCurrency currency;
  final DateTime purchasedAt;
  final double confidence;
  final List<ReceiptLineItem> items;
  final TransactionCategory suggestedCategory;
  final String? note;
  final String? rawText;
  final String? sourceImagePath;

  const ReceiptScanResult({
    this.id,
    required this.merchant,
    required this.total,
    required this.currency,
    required this.purchasedAt,
    required this.confidence,
    required this.items,
    required this.suggestedCategory,
    this.note,
    this.rawText,
    this.sourceImagePath,
  });

  factory ReceiptScanResult.fromJson(
    Map<String, dynamic> json, {
    String? sourceImagePath,
  }) {
    final itemsJson = json['items'] as List<dynamic>? ?? const [];
    return ReceiptScanResult(
      id: json['id'] as String? ?? json['receiptId'] as String?,
      merchant:
          json['merchant'] as String? ??
          json['storeName'] as String? ??
          json['title'] as String? ??
          'Receipt',
      total: (json['total'] as num? ?? json['amount'] as num? ?? 0).toDouble(),
      currency: SupportedCurrencyX.fromCode(
        json['currency'] as String? ?? 'USD',
      ),
      purchasedAt:
          DateTime.tryParse(
            json['purchasedAt'] as String? ??
                json['createdAt'] as String? ??
                json['date'] as String? ??
                '',
          ) ??
          DateTime.now(),
      confidence:
          (json['confidence'] as num? ??
                  json['score'] as num? ??
                  json['ocrConfidence'] as num? ??
                  0)
              .toDouble(),
      items: itemsJson
          .whereType<Map<String, dynamic>>()
          .map(ReceiptLineItem.fromJson)
          .toList(),
      suggestedCategory: TransactionCategoryX.fromValue(
        json['suggestedCategory'] as String? ?? json['category'] as String?,
      ),
      note:
          json['note'] as String? ??
          json['summary'] as String? ??
          json['description'] as String?,
      rawText: json['rawText'] as String? ?? json['ocrText'] as String?,
      sourceImagePath: sourceImagePath,
    );
  }

  ReceiptScanResult copyWith({
    String? id,
    String? merchant,
    double? total,
    SupportedCurrency? currency,
    DateTime? purchasedAt,
    double? confidence,
    List<ReceiptLineItem>? items,
    TransactionCategory? suggestedCategory,
    String? note,
    String? rawText,
    String? sourceImagePath,
  }) {
    return ReceiptScanResult(
      id: id ?? this.id,
      merchant: merchant ?? this.merchant,
      total: total ?? this.total,
      currency: currency ?? this.currency,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      confidence: confidence ?? this.confidence,
      items: items ?? this.items,
      suggestedCategory: suggestedCategory ?? this.suggestedCategory,
      note: note ?? this.note,
      rawText: rawText ?? this.rawText,
      sourceImagePath: sourceImagePath ?? this.sourceImagePath,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'merchant': merchant,
    'total': total,
    'currency': currency.code,
    'purchasedAt': purchasedAt.toIso8601String(),
    'confidence': confidence,
    'category': suggestedCategory.apiValue,
    if (note != null && note!.isNotEmpty) 'note': note,
    if (rawText != null && rawText!.isNotEmpty) 'rawText': rawText,
    'items': items.map((item) => item.toJson()).toList(),
  };
}
