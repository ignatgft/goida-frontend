import 'package:flutter/foundation.dart';
import '../../data/models/wallet_connect.dart';

/// Provider для управления подключенными Web3 кошельками
class WalletConnectProvider extends ChangeNotifier {
  final List<WalletConnectModel> _wallets = [];
  bool _isConnecting = false;
  String? _error;

  List<WalletConnectModel> get wallets => List.unmodifiable(_wallets);
  bool get isConnecting => _isConnecting;
  String? get error => _error;
  bool get hasWallets => _wallets.isNotEmpty;

  /// Подключить новый кошелек
  Future<bool> connectWallet({
    required String walletAddress,
    required WalletType walletType,
  }) async {
    try {
      _isConnecting = true;
      _error = null;
      notifyListeners();

      // TODO: Реальная интеграция с WalletConnect SDK
      // Сейчас это демо-функционал
      
      // Проверяем нет ли уже такого кошелька
      if (_wallets.any((w) => w.walletAddress == walletAddress)) {
        _error = 'Этот кошелек уже подключен';
        return false;
      }

      final newWallet = WalletConnectModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current-user', // TODO: Получить из AuthProvider
        walletAddress: walletAddress,
        walletType: walletType,
        isActive: true,
        connectedAt: DateTime.now(),
      );

      _wallets.add(newWallet);
      _isConnecting = false;
      notifyListeners();
      
      debugPrint('Wallet connected: ${walletType.displayName} - $walletAddress');
      return true;
    } catch (e) {
      _error = 'Ошибка подключения: $e';
      _isConnecting = false;
      notifyListeners();
      debugPrint('Error connecting wallet: $e');
      return false;
    }
  }

  /// Отключить кошелек
  Future<void> disconnectWallet(String walletId) async {
    try {
      _wallets.removeWhere((w) => w.id == walletId);
      notifyListeners();
      debugPrint('Wallet disconnected: $walletId');
    } catch (e) {
      _error = 'Ошибка отключения: $e';
      notifyListeners();
      debugPrint('Error disconnecting wallet: $e');
    }
  }

  /// Переключить активный кошелек
  Future<void> toggleWalletStatus(String walletId) async {
    final index = _wallets.indexWhere((w) => w.id == walletId);
    if (index != -1) {
      final wallet = _wallets[index];
      _wallets[index] = WalletConnectModel(
        id: wallet.id,
        userId: wallet.userId,
        walletAddress: wallet.walletAddress,
        walletType: wallet.walletType,
        isActive: !wallet.isActive,
        connectedAt: wallet.connectedAt,
        lastSyncedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  /// Синхронизировать кошелек
  Future<void> syncWallet(String walletId) async {
    final index = _wallets.indexWhere((w) => w.id == walletId);
    if (index != -1) {
      final wallet = _wallets[index];
      _wallets[index] = WalletConnectModel(
        id: wallet.id,
        userId: wallet.userId,
        walletAddress: wallet.walletAddress,
        walletType: wallet.walletType,
        isActive: wallet.isActive,
        connectedAt: wallet.connectedAt,
        lastSyncedAt: DateTime.now(),
      );
      notifyListeners();
      debugPrint('Wallet synced: $walletId');
    }
  }

  /// Очистить все кошельки
  void clearAll() {
    _wallets.clear();
    _error = null;
    _isConnecting = false;
    notifyListeners();
  }
}
