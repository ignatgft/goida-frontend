import 'package:flutter/material.dart';

/// Модель подключенного WalletConnect кошелька
class WalletConnectModel {
  final String id;
  final String userId;
  final String walletAddress;
  final WalletType walletType;
  final bool isActive;
  final DateTime connectedAt;
  final DateTime? lastSyncedAt;

  const WalletConnectModel({
    required this.id,
    required this.userId,
    required this.walletAddress,
    required this.walletType,
    required this.isActive,
    required this.connectedAt,
    this.lastSyncedAt,
  });

  factory WalletConnectModel.fromJson(Map<String, dynamic> json) {
    return WalletConnectModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      walletAddress: json['walletAddress'] as String? ?? '',
      walletType: WalletType.values.firstWhere(
        (e) => e.name == json['walletType'],
        orElse: () => WalletType.metamask,
      ),
      isActive: json['isActive'] as bool? ?? true,
      connectedAt: DateTime.parse(json['connectedAt'] as String),
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'walletAddress': walletAddress,
    'walletType': walletType.name,
    'isActive': isActive,
    'connectedAt': connectedAt.toIso8601String(),
    'lastSyncedAt': lastSyncedAt?.toIso8601String(),
  };
}

enum WalletType {
  metamask,
  trustWallet,
  rainbow,
  argent,
  walletConnect,
  coinbase,
  ledger,
  trezor,
}

extension WalletTypeX on WalletType {
  String get displayName => switch (this) {
    WalletType.metamask => 'MetaMask',
    WalletType.trustWallet => 'Trust Wallet',
    WalletType.rainbow => 'Rainbow',
    WalletType.argent => 'Argent',
    WalletType.walletConnect => 'WalletConnect',
    WalletType.coinbase => 'Coinbase Wallet',
    WalletType.ledger => 'Ledger',
    WalletType.trezor => 'Trezor',
  };

  IconData get icon => switch (this) {
    WalletType.metamask => Icons.account_balance_wallet_rounded,
    WalletType.trustWallet => Icons.security_rounded,
    WalletType.rainbow => Icons.palette_rounded,
    WalletType.argent => Icons.shield_rounded,
    WalletType.walletConnect => Icons.link_rounded,
    WalletType.coinbase => Icons.business_rounded,
    WalletType.ledger => Icons.credit_card_rounded,
    WalletType.trezor => Icons.usb_rounded,
  };
}
