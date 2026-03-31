import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/formatter.dart';
import '../../data/models/balance.dart';
import '../../l10n/app_localizations.dart';
import '../providers/balance_provider.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<BalanceProvider>();
    final theme = Theme.of(context);
    final assets = provider.assets;
    final cryptoAssets = assets
        .where((asset) => asset.currency.isCrypto)
        .toList();
    final fiatAssets = assets.where((asset) => asset.currency.isFiat).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statistics)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _StatsCard(
            title: l10n.totalAssets,
            subtitle:
                '${l10n.selectedFiat}: ${provider.selectedCurrency.code} · ${_periodLabel(l10n, provider.selectedPeriod)}',
            child: Text(
              Formatter.formatCurrency(
                provider.totalTracked,
                provider.selectedCurrency,
              ),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _StatsCard(
            title: l10n.portfolioMix,
            subtitle: l10n.templateStatisticsHint,
            child: Column(
              children: [
                _MetricRow(
                  label: l10n.fiatAssets,
                  value: fiatAssets.length.toString(),
                ),
                const SizedBox(height: 10),
                _MetricRow(
                  label: l10n.cryptoAssets,
                  value: cryptoAssets.length.toString(),
                ),
                const SizedBox(height: 10),
                _MetricRow(
                  label: l10n.spent,
                  value: Formatter.formatCurrency(
                    provider.spentAmount,
                    provider.selectedCurrency,
                  ),
                ),
              ],
            ),
          ),
          _StatsCard(
            title: l10n.marketSnapshot,
            subtitle: l10n.templateStatisticsHint,
            child: Column(
              children: cryptoAssets.take(5).map((asset) {
                final quote =
                    provider.cryptoRates?.priceFor(asset.currency) ?? 0;
                final totalValue = asset.amount * quote;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _MetricRow(
                    label: '${asset.currency.code} · ${asset.amount}',
                    value: Formatter.formatCurrency(
                      totalValue,
                      provider.selectedCurrency,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          _StatsCard(
            title: l10n.spendingVelocity,
            subtitle: l10n.templateStatisticsHint,
            child: LinearProgressIndicator(
              value: provider.spendingProgress,
              minHeight: 10,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }

  String _periodLabel(AppLocalizations l10n, TrackerPeriod period) {
    return switch (period) {
      TrackerPeriod.week => l10n.thisWeek,
      TrackerPeriod.month => l10n.thisMonth,
      TrackerPeriod.year => l10n.thisYear,
    };
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _StatsCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.cardColor,
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: theme.textTheme.bodyMedium),
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

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
