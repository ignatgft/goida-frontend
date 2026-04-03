import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/theme/ios_design_system.dart';
import '../../l10n/app_localizations.dart';
import '../../data/models/wallet_connection.dart';

/// Экран выбора кошелька для подключения
class WalletConnectScreen extends StatefulWidget {
  const WalletConnectScreen({super.key});

  @override
  State<WalletConnectScreen> createState() => _WalletConnectScreenState();
}

class _WalletConnectScreenState extends State<WalletConnectScreen> {
  WalletConnection? _selectedWallet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.walletConnect),
        backgroundColor: IosDesignSystem.getSystemBackground(context).withValues(alpha: 0.9),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.only(top: 20),
            ),

            // QR Code секция (если кошелёк выбран)
            if (_selectedWallet != null) ...[
              SliverToBoxAdapter(
                child: _buildQRCodeSection(context, l10n),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: IosDesignSystem.sectionSpacing),
              ),
            ],

            // Список кошельков
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: IosDesignSystem.paddingMedium),
                child: Text(
                  l10n.selectWallet,
                  style: TextStyle(
                    color: IosDesignSystem.getLabelPrimary(context),
                    fontSize: IosDesignSystem.fontSizeTitle3,
                    fontWeight: IosDesignSystem.weightBold,
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 12),
            ),

            // Популярные кошельки
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: IosDesignSystem.paddingMedium),
                decoration: BoxDecoration(
                  color: IosDesignSystem.getSecondarySystemBackground(context),
                  borderRadius: BorderRadius.circular(IosDesignSystem.radiusMedium),
                ),
                child: Column(
                  children: WalletConnection.popularWallets.map((wallet) {
                    return _buildWalletTile(context, wallet, true);
                  }).toList(),
                ),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.only(bottom: IosDesignSystem.sectionSpacing),
            ),

            // Остальные кошельки
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: IosDesignSystem.paddingMedium),
                child: Text(
                  'Other Wallets',
                  style: TextStyle(
                    color: IosDesignSystem.getLabelSecondary(context),
                    fontSize: IosDesignSystem.fontSizeFootnote,
                    fontWeight: IosDesignSystem.weightSemibold,
                  ),
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: 12),
            ),

            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: IosDesignSystem.paddingMedium),
                decoration: BoxDecoration(
                  color: IosDesignSystem.getSecondarySystemBackground(context),
                  borderRadius: BorderRadius.circular(IosDesignSystem.radiusMedium),
                ),
                child: Column(
                  children: WalletConnection.allWallets
                      .where((w) => !w.isPopular)
                      .map((wallet) => _buildWalletTile(context, wallet, false))
                      .toList(),
                ),
              ),
            ),

            const SliverPadding(
              padding: EdgeInsets.only(bottom: 100),
            ),
          ],
        ),
      ),
    );
  }

  // MARK: - QR Code Section
  Widget _buildQRCodeSection(BuildContext context, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: IosDesignSystem.paddingMedium),
      padding: const EdgeInsets.all(IosDesignSystem.paddingXLarge),
      decoration: BoxDecoration(
        color: IosDesignSystem.getSecondarySystemBackground(context),
        borderRadius: BorderRadius.circular(IosDesignSystem.radiusXLarge),
      ),
      child: Column(
        children: [
          // QR Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(IosDesignSystem.radiusMedium),
            ),
            child: QrImageView(
              data: 'wc://connect?wallet=${_selectedWallet!.id}',
              version: QrVersions.auto,
              size: 200.0,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: IosDesignSystem.primaryAccent,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.scanQRCode,
            style: TextStyle(
              color: IosDesignSystem.getLabelPrimary(context),
              fontSize: IosDesignSystem.fontSizeHeadline,
              fontWeight: IosDesignSystem.weightSemibold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.qrCodeDescription,
            style: TextStyle(
              color: IosDesignSystem.getLabelSecondary(context),
              fontSize: IosDesignSystem.fontSizeSubheadline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Кнопка открытия кошелька
          if (_selectedWallet!.deeplink != null)
            CupertinoButton(
              color: IosDesignSystem.primaryAccent,
              onPressed: () {
                // TODO: Открыть кошелёк через deeplink
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text('Open ${_selectedWallet!.name}'),
              ),
            ),
        ],
      ),
    );
  }

  // MARK: - Wallet Tile
  Widget _buildWalletTile(BuildContext context, WalletConnection wallet, bool showChevron) {
    final isSelected = _selectedWallet?.id == wallet.id;
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return CupertinoButton(
      onPressed: () {
        setState(() {
          _selectedWallet = wallet;
        });
      },
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(IosDesignSystem.paddingMedium),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: IosDesignSystem.getSeparator(context),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Wallet Icon Placeholder
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    IosDesignSystem.primaryAccent.withValues(alpha: 0.2),
                    IosDesignSystem.successGreen.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(IosDesignSystem.radiusSmall),
              ),
              child: Center(
                child: Text(
                  wallet.name.substring(0, 2).toUpperCase(),
                  style: const TextStyle(
                    color: IosDesignSystem.primaryAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallet.name,
                    style: TextStyle(
                      color: IosDesignSystem.getLabelPrimary(context),
                      fontSize: IosDesignSystem.fontSizeBody,
                      fontWeight: IosDesignSystem.weightSemibold,
                    ),
                  ),
                  if (wallet.isPopular) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Popular',
                        style: TextStyle(
                          color: IosDesignSystem.primaryAccent,
                          fontSize: IosDesignSystem.fontSizeCaption2,
                          fontWeight: IosDesignSystem.weightSemibold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                CupertinoIcons.check_mark_circled,
                color: IosDesignSystem.successGreen,
                size: 24,
              )
            else if (showChevron)
              Icon(
                CupertinoIcons.chevron_right,
                color: IosDesignSystem.getLabelSecondary(context),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
