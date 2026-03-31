import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/formatter.dart';
import '../../data/models/balance.dart';
import '../../l10n/app_localizations.dart';
import '../providers/balance_provider.dart';
import 'action_chip.dart';
import 'asset_snapshot_sheet.dart';
import 'currency_picker_sheet.dart';

class BalanceCard extends StatelessWidget {
  final VoidCallback onAddExpenseTap;
  final VoidCallback onAddAssetTap;
  final VoidCallback onScanTap;
  final VoidCallback onHistoryTap;

  const BalanceCard({
    super.key,
    required this.onAddExpenseTap,
    required this.onAddAssetTap,
    required this.onScanTap,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BalanceProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.05);
    final mutedColor = isDark ? Colors.white60 : Colors.black54;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0A0A) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Секция общего баланса активов и потраченного баланса
          _buildAssetBalanceSection(
            provider: provider,
            theme: theme,
            l10n: l10n,
            mutedColor: mutedColor,
          ),
          const SizedBox(height: 24),
          // Разделитель
          Container(
            height: 1,
            color: borderColor,
          ),
          const SizedBox(height: 24),
          // Текущий баланс (старая секция)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.currentBalance,
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.periodLabel.isEmpty
                          ? _periodLabel(l10n, provider.selectedPeriod)
                          : provider.periodLabel,
                      style: TextStyle(color: mutedColor, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    provider.loading
                        ? SizedBox(
                            height: 44,
                            width: 44,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.primary,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            Formatter.formatCurrency(
                              provider.totalTracked,
                              provider.selectedCurrency,
                            ),
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                              letterSpacing: -1,
                            ),
                          ),
                    const SizedBox(height: 10),
                    Text(
                      '${l10n.remaining}: ${Formatter.formatCurrency(provider.remainingAmount, provider.selectedCurrency)}',
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Кольцо с процентным соотношением потраченного к общему балансу активов
              _AssetPercentageRing(
                totalAssets: provider.totalAssetsBalance,
                spentBalance: provider.spentAssetsBalance,
                label: provider.loading ? '' : _formatPercent(provider.spentAssetsBalance, provider.totalAssetsBalance),
                caption: l10n.spent,
                currency: provider.selectedCurrency,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n.period,
            style: TextStyle(
              color: mutedColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TrackerPeriod.values.map((period) {
              return ChoiceChip(
                label: Text(_periodLabel(l10n, period)),
                selected: provider.selectedPeriod == period,
                onSelected: (_) => provider.selectPeriod(period),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          Text(
            l10n.availableBalances,
            style: TextStyle(
              color: mutedColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () async {
              final selected = await CurrencyPickerSheet.show(
                context: context,
                title: l10n.selectedFiat,
                searchHint: l10n.searchFiatCurrency,
                currencies: SupportedCurrencyX.fiatValues,
                selectedCurrency: provider.selectedCurrency,
              );
              if (selected != null && context.mounted) {
                context.read<BalanceProvider>().selectCurrency(selected);
              }
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.black.withValues(alpha: 0.02),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.selectedFiat,
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${provider.selectedCurrency.code} · ${provider.selectedCurrency.symbol}',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.primary.withValues(alpha: 0.14),
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ActionChipWidget(
                  text: l10n.addExpenseAction,
                  icon: Icons.trending_down_rounded,
                  onTap: onAddExpenseTap,
                ),
              ),
              Expanded(
                child: ActionChipWidget(
                  text: l10n.assets,
                  icon: Icons.add_rounded,
                  onTap: onAddAssetTap,
                ),
              ),
              Expanded(
                child: ActionChipWidget(
                  text: l10n.scan,
                  icon: Icons.camera_alt_rounded,
                  onTap: onScanTap,
                ),
              ),
              Expanded(
                child: ActionChipWidget(
                  text: l10n.history,
                  icon: Icons.history_rounded,
                  onTap: onHistoryTap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            l10n.assets,
            style: TextStyle(
              color: mutedColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...provider.assets.take(4).map((asset) {
            return InkWell(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  builder: (_) => AssetSnapshotSheet(asset: asset),
                );
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.black.withValues(alpha: 0.02),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                      ),
                      child: Icon(
                        _assetIcon(asset.type),
                        color: theme.colorScheme.primary,
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
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_assetTypeLabel(l10n, asset.type)} · ${asset.currency.code}',
                            style: TextStyle(color: mutedColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      Formatter.formatCurrency(asset.amount, asset.currency),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (provider.fiatRates != null) ...[
            const SizedBox(height: 4),
            Text(
              '${l10n.exchangeRate}: ${Formatter.formatCompactRate(provider.fiatRates!.baseCurrency, provider.selectedCurrency, provider.fiatRates!.rateFor(provider.selectedCurrency))}',
              style: TextStyle(color: mutedColor, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAssetBalanceSection({
    required BalanceProvider provider,
    required ThemeData theme,
    required AppLocalizations l10n,
    required Color mutedColor,
  }) {
    final totalAssets = provider.totalAssetsBalance;
    final spentBalance = provider.spentAssetsBalance;
    final netBalance = provider.netAssetsBalance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.assets,
          style: TextStyle(
            color: mutedColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        // Общий баланс активов
        _buildBalanceRow(
          theme: theme,
          l10n: l10n,
          label: 'Total Assets',
          amount: totalAssets,
          currency: provider.selectedCurrency,
          mutedColor: mutedColor,
          isLoading: provider.loading,
        ),
        const SizedBox(height: 12),
        // Потраченный баланс
        _buildBalanceRow(
          theme: theme,
          l10n: l10n,
          label: 'Spent Balance',
          amount: spentBalance,
          currency: provider.selectedCurrency,
          mutedColor: mutedColor,
          isLoading: provider.loading,
          isExpense: true,
        ),
        const SizedBox(height: 12),
        // Чистый баланс (разделитель с итогом)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Net Balance',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    provider.loading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.primary,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            Formatter.formatCurrency(netBalance, provider.selectedCurrency),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: netBalance >= 0
                                  ? theme.colorScheme.primary
                                  : Colors.red.shade400,
                            ),
                          ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.primary.withValues(alpha: 0.14),
                ),
                child: Icon(
                  netBalance >= 0
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceRow({
    required ThemeData theme,
    required AppLocalizations l10n,
    required String label,
    required double amount,
    required SupportedCurrency currency,
    required Color mutedColor,
    required bool isLoading,
    bool isExpense = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: mutedColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        isLoading
            ? SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                  strokeWidth: 2,
                ),
              )
            : Text(
                Formatter.formatCurrency(amount, currency),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isExpense ? Colors.red.shade400 : theme.colorScheme.onSurface,
                ),
              ),
      ],
    );
  }

  String _periodLabel(AppLocalizations l10n, TrackerPeriod period) {
    return switch (period) {
      TrackerPeriod.week => l10n.thisWeek,
      TrackerPeriod.month => l10n.thisMonth,
      TrackerPeriod.year => l10n.thisYear,
    };
  }

  String _assetTypeLabel(AppLocalizations l10n, AssetType type) {
    return switch (type) {
      AssetType.cash => l10n.cash,
      AssetType.bankAccount => l10n.bankAccount,
      AssetType.savings => l10n.savings,
      AssetType.investments => l10n.investments,
      AssetType.crypto => l10n.crypto,
    };
  }

  IconData _assetIcon(AssetType type) {
    return switch (type) {
      AssetType.cash => Icons.payments_rounded,
      AssetType.bankAccount => Icons.account_balance_wallet_rounded,
      AssetType.savings => Icons.savings_rounded,
      AssetType.investments => Icons.trending_up_rounded,
      AssetType.crypto => Icons.currency_bitcoin_rounded,
    };
  }

  String _formatPercent(double spent, double total) {
    if (total <= 0) return '0%';
    final percent = (spent / total * 100).clamp(0, 999);
    return '${percent.toStringAsFixed(1)}%';
  }
}

class _AssetPercentageRing extends StatelessWidget {
  final double totalAssets;
  final double spentBalance;
  final String label;
  final String caption;
  final SupportedCurrency currency;

  const _AssetPercentageRing({
    required this.totalAssets,
    required this.spentBalance,
    required this.label,
    required this.caption,
    this.currency = SupportedCurrency.usd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = totalAssets > 0 ? (spentBalance / totalAssets).clamp(0.0, 1.0) : 0.0;

    return SizedBox(
      width: 116,
      height: 116,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size.square(116),
            painter: _ExpenseRingPainter(
              progress: progress,
              trackColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              progressColor: theme.colorScheme.primary,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                caption,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                Formatter.formatCurrency(spentBalance, currency),
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpenseRing extends StatelessWidget {
  final double progress;
  final String label;
  final String caption;

  const _ExpenseRing({
    required this.progress,
    required this.label,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 116,
      height: 116,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size.square(116),
            painter: _ExpenseRingPainter(
              progress: progress,
              trackColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              progressColor: theme.colorScheme.primary,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 2),
              Text(
                caption,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpenseRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;

  const _ExpenseRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 12.0;
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -1.5708, 6.2831, false, trackPaint);
    canvas.drawArc(rect, -1.5708, 6.2831 * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _ExpenseRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}
