import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/ios_design_system.dart';
import '../../data/models/wallet_connect.dart';
import '../providers/wallet_connect_provider.dart';

/// Экран подключения Web3 кошельков
class WalletConnectManagementScreen extends StatefulWidget {
  const WalletConnectManagementScreen({super.key});

  @override
  State<WalletConnectManagementScreen> createState() => _WalletConnectManagementScreenState();
}

class _WalletConnectManagementScreenState extends State<WalletConnectManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: IosDesignSystem.getSystemGroupedBackground(context),
      appBar: AppBar(
        title: const Text('Web3 Кошельки'),
        backgroundColor: IosDesignSystem.getSystemBackground(context).withValues(alpha: 0.95),
        elevation: 0,
        foregroundColor: IosDesignSystem.getLabelPrimary(context),
      ),
      body: Consumer<WalletConnectProvider>(
        builder: (context, walletProvider, child) {
          if (!walletProvider.hasWallets) {
            return _buildEmptyState(context, walletProvider);
          }

          return CustomScrollView(
            slivers: [
              // Кнопка подключения
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: walletProvider.isConnecting
                        ? null
                        : () => _showConnectWalletDialog(context, walletProvider),
                    icon: walletProvider.isConnecting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(CupertinoIcons.plus_circle_fill),
                    label: Text(
                      walletProvider.isConnecting
                          ? 'Подключение...'
                          : 'Подключить кошелек',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

              // Список кошельков
              if (walletProvider.hasWallets)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final wallet = walletProvider.wallets[index];
                        return _WalletCard(
                          wallet: wallet,
                          onDisconnect: () => walletProvider.disconnectWallet(wallet.id),
                          onToggle: () => walletProvider.toggleWalletStatus(wallet.id),
                          onSync: () => walletProvider.syncWallet(wallet.id),
                        );
                      },
                      childCount: walletProvider.wallets.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WalletConnectProvider provider) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.link_circle,
              size: 80,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Нет подключенных кошельков',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Подключите Web3 кошелек для взаимодействия с DeFi',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: provider.isConnecting
                  ? null
                  : () => _showConnectWalletDialog(context, provider),
              icon: const Icon(CupertinoIcons.plus_circle_fill),
              label: const Text('Подключить первый кошелек'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConnectWalletDialog(BuildContext context, WalletConnectProvider provider) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Выберите кошелек'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: WalletType.values.map((type) {
            return ListTile(
              leading: Icon(type.icon),
              title: Text(type.displayName),
              onTap: () {
                Navigator.pop(context);
                // Демо подключение
                _connectDemoWallet(context, provider, type);
              },
            );
          }).toList(),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  Future<void> _connectDemoWallet(
    BuildContext context,
    WalletConnectProvider provider,
    WalletType type,
  ) async {
    // Генерируем демо адрес
    final demoAddress = '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16).substring(0, 8)}...' +
        '${DateTime.now().microsecond.toRadixString(16).padLeft(4, '0')}';

    final success = await provider.connectWallet(
      walletAddress: demoAddress,
      walletType: type,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Кошелек подключен' : (provider.error ?? 'Ошибка подключения')),
          backgroundColor: success
              ? IosDesignSystem.successGreen
              : IosDesignSystem.errorRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}

class _WalletCard extends StatelessWidget {
  final WalletConnectModel wallet;
  final VoidCallback onDisconnect;
  final VoidCallback onToggle;
  final VoidCallback onSync;

  const _WalletCard({
    required this.wallet,
    required this.onDisconnect,
    required this.onToggle,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: wallet.isActive
              ? IosDesignSystem.successGreen.withValues(alpha: 0.3)
              : theme.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  wallet.walletType.icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wallet.walletType.displayName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      wallet.walletAddress,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: wallet.isActive
                      ? IosDesignSystem.successGreen.withValues(alpha: 0.1)
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  wallet.isActive ? 'Активен' : 'Неактивен',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: wallet.isActive
                        ? IosDesignSystem.successGreen
                        : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Статистика
          Row(
            children: [
              Icon(
                CupertinoIcons.clock,
                size: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              const SizedBox(width: 4),
              Text(
                'Подключен: ${_formatDate(wallet.connectedAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              if (wallet.lastSyncedAt != null) ...[
                const SizedBox(width: 12),
                Icon(
                  CupertinoIcons.arrow_clockwise,
                  size: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 4),
                Text(
                  'Синхронизирован: ${_formatDate(wallet.lastSyncedAt!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          // Кнопки действий
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onSync,
                  icon: const Icon(CupertinoIcons.arrow_clockwise, size: 16),
                  label: const Text('Синхронизировать'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onToggle,
                  icon: Icon(
                    wallet.isActive
                        ? CupertinoIcons.pause_fill
                        : CupertinoIcons.play_fill,
                    size: 16,
                  ),
                  label: Text(wallet.isActive ? 'Деактивировать' : 'Активировать'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    foregroundColor: wallet.isActive
                        ? IosDesignSystem.warningOrange
                        : IosDesignSystem.successGreen,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onDisconnect,
                icon: const Icon(CupertinoIcons.delete, color: Colors.red),
                tooltip: 'Отключить',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
