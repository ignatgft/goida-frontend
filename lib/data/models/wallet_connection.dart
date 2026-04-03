/// Модель кошелька для WalletConnect
class WalletConnection {
  final String id;
  final String name;
  final String imageUrl;
  final String? deeplink;
  final bool isPopular;

  const WalletConnection({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.deeplink,
    this.isPopular = false,
  });

  /// Популярные кошельки
  static List<WalletConnection> get popularWallets => [
        const WalletConnection(
          id: 'tonkeeper',
          name: 'Tonkeeper',
          imageUrl: 'assets/wallets/tonkeeper.png',
          deeplink: 'tonkeeper://',
          isPopular: true,
        ),
        const WalletConnection(
          id: 'metamask',
          name: 'MetaMask',
          imageUrl: 'assets/wallets/metamask.png',
          deeplink: 'metamask://',
          isPopular: true,
        ),
        const WalletConnection(
          id: 'trustwallet',
          name: 'Trust Wallet',
          imageUrl: 'assets/wallets/trustwallet.png',
          deeplink: 'trust://',
          isPopular: true,
        ),
        const WalletConnection(
          id: 'phantom',
          name: 'Phantom',
          imageUrl: 'assets/wallets/phantom.png',
          deeplink: 'phantom://',
          isPopular: true,
        ),
      ];

  /// Все кошельки
  static List<WalletConnection> get allWallets => [
        ...popularWallets,
        const WalletConnection(
          id: 'rainbow',
          name: 'Rainbow',
          imageUrl: 'assets/wallets/rainbow.png',
          deeplink: 'rainbow://',
        ),
        const WalletConnection(
          id: 'argent',
          name: 'Argent',
          imageUrl: 'assets/wallets/argent.png',
          deeplink: 'argent://',
        ),
        const WalletConnection(
          id: 'braavos',
          name: 'Braavos',
          imageUrl: 'assets/wallets/braavos.png',
          deeplink: 'braavos://',
        ),
        const WalletConnection(
          id: 'coinbase',
          name: 'Coinbase Wallet',
          imageUrl: 'assets/wallets/coinbase.png',
          deeplink: 'cbwallet://',
        ),
        const WalletConnection(
          id: 'ledger',
          name: 'Ledger',
          imageUrl: 'assets/wallets/ledger.png',
        ),
        const WalletConnection(
          id: 'safePal',
          name: 'SafePal',
          imageUrl: 'assets/wallets/safepal.png',
          deeplink: 'safepal://',
        ),
        const WalletConnection(
          id: 'imtoken',
          name: 'imToken',
          imageUrl: 'assets/wallets/imtoken.png',
          deeplink: 'imtokenv2://',
        ),
      ];
}

/// Статус подключения кошелька
enum WalletConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}

/// Модель подключённого кошелька
class ConnectedWallet {
  final String walletId;
  final String walletName;
  final String? address;
  final WalletConnectionStatus status;
  final DateTime? connectedAt;

  const ConnectedWallet({
    required this.walletId,
    required this.walletName,
    this.address,
    this.status = WalletConnectionStatus.disconnected,
    this.connectedAt,
  });

  ConnectedWallet copyWith({
    String? walletId,
    String? walletName,
    String? address,
    WalletConnectionStatus? status,
    DateTime? connectedAt,
  }) {
    return ConnectedWallet(
      walletId: walletId ?? this.walletId,
      walletName: walletName ?? this.walletName,
      address: address ?? this.address,
      status: status ?? this.status,
      connectedAt: connectedAt ?? this.connectedAt,
    );
  }
}
