import 'package:flutter/material.dart';

/// Модель пула активов (несколько валют в одном активе)
class AssetPool {
  final String id;
  final String name;
  final AssetPoolType type;
  final String baseCurrency;
  final double totalBalance;
  final double totalValueInBaseCurrency;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssetPool({
    required this.id,
    required this.name,
    required this.type,
    required this.baseCurrency,
    required this.totalBalance,
    required this.totalValueInBaseCurrency,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssetPool.fromJson(Map<String, dynamic> json) {
    return AssetPool(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: AssetPoolType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AssetPoolType.cash,
      ),
      baseCurrency: json['baseCurrency'] as String? ?? 'USD',
      totalBalance: (json['totalBalance'] as num?)?.toDouble() ?? 0.0,
      totalValueInBaseCurrency: (json['totalValueInBaseCurrency'] as num?)?.toDouble() ?? 0.0,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'baseCurrency': baseCurrency,
    'totalBalance': totalBalance,
    'totalValueInBaseCurrency': totalValueInBaseCurrency,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

/// Элемент пула (отдельная валюта)
class PoolItem {
  final String id;
  final String poolId;
  final String currency;
  final double balance;
  final double valueInBaseCurrency;
  final double weight;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PoolItem({
    required this.id,
    required this.poolId,
    required this.currency,
    required this.balance,
    required this.valueInBaseCurrency,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PoolItem.fromJson(Map<String, dynamic> json) {
    return PoolItem(
      id: json['id'] as String? ?? '',
      poolId: json['poolId'] as String? ?? '',
      currency: json['currency'] as String? ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      valueInBaseCurrency: (json['valueInBaseCurrency'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'poolId': poolId,
    'currency': currency,
    'balance': balance,
    'valueInBaseCurrency': valueInBaseCurrency,
    'weight': weight,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

enum AssetPoolType {
  cash,
  bankAccount,
  savings,
  investments,
  crypto,
  walletConnect,
}

extension AssetPoolTypeX on AssetPoolType {
  String get displayName => switch (this) {
    AssetPoolType.cash => 'Наличные',
    AssetPoolType.bankAccount => 'Банковский счет',
    AssetPoolType.savings => 'Сбережения',
    AssetPoolType.investments => 'Инвестиции',
    AssetPoolType.crypto => 'Криптовалюты',
    AssetPoolType.walletConnect => 'WalletConnect',
  };

  IconData get icon => switch (this) {
    AssetPoolType.cash => Icons.payments_rounded,
    AssetPoolType.bankAccount => Icons.account_balance_rounded,
    AssetPoolType.savings => Icons.savings_rounded,
    AssetPoolType.investments => Icons.trending_up_rounded,
    AssetPoolType.crypto => Icons.currency_bitcoin_rounded,
    AssetPoolType.walletConnect => Icons.wallet_rounded,
  };
}
