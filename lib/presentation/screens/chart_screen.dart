import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/ios_design_system.dart';
import '../../core/utils/formatter.dart';
import '../../data/models/balance.dart';
import '../../l10n/app_localizations.dart';
import '../providers/balance_provider.dart';

/// Экран статистики в едином стиле
class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<BalanceProvider>();
    final assets = provider.assets;
    final cryptoAssets = assets.where((asset) => asset.currency.isCrypto).toList();
    final fiatAssets = assets.where((asset) => asset.currency.isFiat).toList();

    return Scaffold(
      backgroundColor: IosDesignSystem.getSystemGroupedBackground(context),
      appBar: AppBar(
        title: Text(l10n.statistics),
        backgroundColor: IosDesignSystem.getSystemBackground(context).withValues(alpha: 0.95),
        elevation: 0,
        foregroundColor: IosDesignSystem.getLabelPrimary(context),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatsCard(
            title: l10n.totalAssets,
            subtitle: '${l10n.selectedFiat}: ${provider.selectedCurrency.code}',
            context: context,
            child: Text(
              Formatter.formatCurrency(
                provider.totalTracked,
                provider.selectedCurrency,
              ),
              style: TextStyle(
                fontWeight: IosDesignSystem.weightBold,
                fontSize: 32,
                color: IosDesignSystem.getLabelPrimary(context),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _StatsCard(
            title: l10n.portfolioMix,
            subtitle: l10n.templateStatisticsHint,
            context: context,
            child: Column(
              children: [
                _MetricRow(
                  label: l10n.fiatAssets,
                  value: fiatAssets.length.toString(),
                  context: context,
                ),
                const SizedBox(height: 10),
                _MetricRow(
                  label: l10n.cryptoAssets,
                  value: cryptoAssets.length.toString(),
                  context: context,
                ),
                const SizedBox(height: 10),
                _MetricRow(
                  label: l10n.spent,
                  value: Formatter.formatCurrency(
                    provider.spentAmount,
                    provider.selectedCurrency,
                  ),
                  context: context,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _StatsCard(
            title: l10n.marketSnapshot,
            subtitle: l10n.templateStatisticsHint,
            context: context,
            child: Column(
              children: cryptoAssets.take(5).map((asset) {
                final quote = provider.cryptoRates?.priceFor(asset.currency) ?? 0;
                final totalValue = asset.amount * quote;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _MetricRow(
                    label: '${asset.currency.code} · ${asset.amount.toStringAsFixed(4)}',
                    value: Formatter.formatCurrency(
                      totalValue,
                      provider.selectedCurrency,
                    ),
                    context: context,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _StatsCard(
            title: l10n.spendingVelocity,
            subtitle: l10n.templateStatisticsHint,
            context: context,
            child: LinearProgressIndicator(
              value: provider.spendingProgress.clamp(0.0, 1.0),
              minHeight: 10,
              borderRadius: BorderRadius.circular(999),
              backgroundColor: IosDesignSystem.getSecondarySystemBackground(context),
              color: IosDesignSystem.primaryAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final BuildContext context;

  const _StatsCard({
    required this.title,
    required this.subtitle,
    required this.child,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            title,
            style: TextStyle(
              color: IosDesignSystem.getLabelPrimary(context),
              fontSize: IosDesignSystem.fontSizeTitle3,
              fontWeight: IosDesignSystem.weightBold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: IosDesignSystem.getLabelSecondary(context),
              fontSize: IosDesignSystem.fontSizeSubheadline,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;

  const _MetricRow({
    required this.label,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: IosDesignSystem.getLabelSecondary(context),
            fontSize: IosDesignSystem.fontSizeBody,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: IosDesignSystem.getLabelPrimary(context),
            fontSize: IosDesignSystem.fontSizeBody,
            fontWeight: IosDesignSystem.weightSemibold,
          ),
        ),
      ],
    );
  }
}
