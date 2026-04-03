import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/ios_design_system.dart';
import '../providers/balance_provider.dart';
import '../providers/receipt_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/expense_entry_sheet.dart';
import '../widgets/asset_snapshot_sheet.dart';
import '../widgets/receipt_review_sheet.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';

/// Главная страница (Dashboard) в едином стиле
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<double> _chartData = [];

  @override
  void initState() {
    super.initState();
    _generateChartData();
  }

  void _generateChartData() {
    setState(() {
      _chartData = [
        125000, 127000, 126500, 128000, 130000, 129000, 131000,
        133000, 132500, 134000, 136000, 135500, 137000, 139000,
        138500, 140000, 141000, 140500, 142000, 143000, 142500,
        144000, 145000, 144500, 146000, 147000, 146500, 148000,
        142850.42,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final balanceProvider = context.watch<BalanceProvider>();
    final totalNetWorth = balanceProvider.totalTracked;
    final percentChange = 12.4;

    return Scaffold(
      backgroundColor: IosDesignSystem.getSystemGroupedBackground(context),
      body: CustomScrollView(
        slivers: [
          // Navigation Bar
          SliverAppBar(
            floating: true,
            backgroundColor: IosDesignSystem.getSystemBackground(context).withValues(alpha: 0.95),
            leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final avatarUrl = authProvider.avatarUrl;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: IosDesignSystem.getSeparator(context),
                      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                      child: avatarUrl == null
                          ? Icon(
                              CupertinoIcons.person_fill,
                              size: 18,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            title: Text(
              l10n.appTitle,
              style: TextStyle(
                fontSize: IosDesignSystem.fontSizeTitle3,
                fontWeight: IosDesignSystem.weightBold,
                color: IosDesignSystem.getLabelPrimary(context),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(CupertinoIcons.bell),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                },
                tooltip: l10n.notifications,
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.gear),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
                tooltip: l10n.settings,
              ),
            ],
          ),

          const SliverPadding(
            padding: EdgeInsets.only(top: 10),
          ),

          // Total Net Worth Card
          SliverToBoxAdapter(
            child: _buildTotalNetWorthCard(context, totalNetWorth, percentChange, l10n),
          ),

          const SliverPadding(
            padding: EdgeInsets.only(bottom: IosDesignSystem.sectionSpacing),
          ),

          // Quick Actions Section
          SliverToBoxAdapter(
            child: _buildQuickActionsSection(context, l10n, balanceProvider),
          ),

          const SliverPadding(
            padding: EdgeInsets.only(bottom: IosDesignSystem.sectionSpacing),
          ),

          // Assets Section
          SliverToBoxAdapter(
            child: _buildAssetsSection(context, l10n, balanceProvider),
          ),

          const SliverPadding(
            padding: EdgeInsets.only(bottom: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalNetWorthCard(
    BuildContext context,
    double totalNetWorth,
    double percentChange,
    AppLocalizations l10n,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: IosDesignSystem.paddingMedium),
      padding: const EdgeInsets.all(IosDesignSystem.paddingXLarge),
      decoration: BoxDecoration(
        color: IosDesignSystem.getSecondarySystemBackground(context),
        borderRadius: BorderRadius.circular(IosDesignSystem.radiusXLarge),
        border: Border.all(
          color: IosDesignSystem.getSeparator(context).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.totalAssets,
            style: TextStyle(
              color: IosDesignSystem.getLabelSecondary(context),
              fontSize: IosDesignSystem.fontSizeSubheadline,
              fontWeight: IosDesignSystem.weightMedium,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${totalNetWorth.toStringAsFixed(2)}',
            style: TextStyle(
              color: IosDesignSystem.getLabelPrimary(context),
              fontSize: 36,
              fontWeight: IosDesignSystem.weightBold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: IosDesignSystem.successGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(IosDesignSystem.radiusSmall),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  color: IosDesignSystem.successGreen,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '+${percentChange.toStringAsFixed(1)}% ${l10n.thisMonth}',
                  style: TextStyle(
                    color: IosDesignSystem.successGreen,
                    fontSize: IosDesignSystem.fontSizeSubheadline,
                    fontWeight: IosDesignSystem.weightSemibold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(IosDesignSystem.radiusLarge),
            child: _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    if (_chartData.isEmpty) {
      return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
    }

    return AspectRatio(
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: _chartData.length - 1,
            minY: _chartData.reduce((a, b) => a < b ? a : b) * 0.95,
            maxY: _chartData.reduce((a, b) => a > b ? a : b) * 1.05,
            lineBarsData: [
              LineChartBarData(
                spots: _chartData.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value);
                }).toList(),
                isCurved: true,
                curveSmoothness: 0.4,
                color: IosDesignSystem.primaryAccent,
                barWidth: 2.5,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      IosDesignSystem.primaryAccent.withValues(alpha: 0.25),
                      IosDesignSystem.primaryAccent.withValues(alpha: 0.02),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, AppLocalizations l10n, BalanceProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: IosDesignSystem.paddingMedium),
          child: Text(
            l10n.quickActions,
            style: TextStyle(
              color: IosDesignSystem.getLabelSecondary(context),
              fontSize: IosDesignSystem.fontSizeTitle3,
              fontWeight: IosDesignSystem.weightBold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: IosDesignSystem.paddingMedium),
          child: Row(
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: Opacity(
                      opacity: value,
                      child: _buildQuickActionButton(
                        context,
                        icon: CupertinoIcons.cart,
                        label: l10n.addExpenseAction,
                        color: Colors.red.shade400,
                        onTap: () => ExpenseEntrySheet.show(context),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: Opacity(
                      opacity: value,
                      child: _buildQuickActionButton(
                        context,
                        icon: CupertinoIcons.plus_circle_fill,
                        label: l10n.addAsset,
                        color: IosDesignSystem.successGreen,
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: IosDesignSystem.getSystemBackground(context),
                            builder: (_) => const AssetSnapshotSheet(),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: Opacity(
                      opacity: value,
                      child: _buildQuickActionButton(
                        context,
                        icon: CupertinoIcons.camera_fill,
                        label: l10n.scan,
                        color: IosDesignSystem.primaryAccent,
                        onTap: () async {
                          final receiptProvider = context.read<ReceiptProvider>();
                          final receipt = await receiptProvider.scanAndUploadReceipt(context);
                          if (!context.mounted || receipt == null) return;
                          await ReceiptReviewSheet.show(context, receipt: receipt);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: Opacity(
                      opacity: value,
                      child: _buildQuickActionButton(
                        context,
                        icon: CupertinoIcons.time_solid,
                        label: l10n.history,
                        color: Colors.orange.shade400,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HistoryScreen()),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: IosDesignSystem.paddingMedium),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(IosDesignSystem.radiusMedium),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: IosDesignSystem.fontSizeCaption1,
                fontWeight: IosDesignSystem.weightSemibold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetsSection(BuildContext context, AppLocalizations l10n, BalanceProvider provider) {
    final assets = provider.assets.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: IosDesignSystem.paddingMedium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.assets,
                style: TextStyle(
                  color: IosDesignSystem.getLabelSecondary(context),
                  fontSize: IosDesignSystem.fontSizeTitle3,
                  fontWeight: IosDesignSystem.weightBold,
                ),
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: IosDesignSystem.getSystemBackground(context),
                    builder: (_) => const AssetSnapshotSheet(),
                  );
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: IosDesignSystem.primaryAccent,
                    fontSize: IosDesignSystem.fontSizeSubheadline,
                    fontWeight: IosDesignSystem.weightSemibold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...assets.asMap().entries.map((entry) {
          final index = entry.key;
          final asset = entry.value;
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 400 + (index * 100)),
            curve: Curves.easeOutCubic,
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: _buildAssetRow(context, asset, l10n),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildAssetRow(BuildContext context, dynamic asset, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: IosDesignSystem.paddingMedium,
        vertical: 4,
      ),
      padding: const EdgeInsets.all(IosDesignSystem.paddingMedium),
      decoration: BoxDecoration(
        color: IosDesignSystem.getSecondarySystemBackground(context),
        borderRadius: BorderRadius.circular(IosDesignSystem.radiusLarge),
        border: Border.all(
          color: IosDesignSystem.getSeparator(context).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: IosDesignSystem.primaryAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(IosDesignSystem.radiusSmall),
            ),
            child: Icon(
              _getAssetIcon(asset.type),
              color: IosDesignSystem.primaryAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: TextStyle(
                    color: IosDesignSystem.getLabelPrimary(context),
                    fontSize: IosDesignSystem.fontSizeBody,
                    fontWeight: IosDesignSystem.weightSemibold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_getAssetTypeLabel(l10n, asset.type)} · ${asset.currency}',
                  style: TextStyle(
                    color: IosDesignSystem.getLabelSecondary(context),
                    fontSize: IosDesignSystem.fontSizeCaption1,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${asset.amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: IosDesignSystem.getLabelPrimary(context),
              fontSize: IosDesignSystem.fontSizeBody,
              fontWeight: IosDesignSystem.weightBold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAssetIcon(dynamic type) {
    final typeStr = type.toString().toLowerCase();
    switch (typeStr) {
      case 'AssetType.cash':
      case 'cash':
        return Icons.payments_rounded;
      case 'AssetType.bank_account':
      case 'bank_account':
        return Icons.account_balance_wallet_rounded;
      case 'AssetType.savings':
      case 'savings':
        return Icons.savings_rounded;
      case 'AssetType.investments':
      case 'investments':
        return Icons.trending_up_rounded;
      case 'AssetType.crypto':
      case 'crypto':
        return Icons.currency_bitcoin_rounded;
      default:
        return Icons.account_balance_wallet_rounded;
    }
  }

  String _getAssetTypeLabel(AppLocalizations l10n, dynamic type) {
    final typeStr = type.toString().toLowerCase();
    switch (typeStr) {
      case 'AssetType.cash':
      case 'cash':
        return l10n.cash;
      case 'AssetType.bank_account':
      case 'bank_account':
        return l10n.bankAccount;
      case 'AssetType.savings':
      case 'savings':
        return l10n.savings;
      case 'AssetType.investments':
      case 'investments':
        return l10n.investments;
      case 'AssetType.crypto':
      case 'crypto':
        return l10n.crypto;
      default:
        return l10n.assets;
    }
  }
}
