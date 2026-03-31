import 'package:flutter/material.dart';

import '../../core/utils/formatter.dart';
import '../../data/models/balance.dart';
import '../../l10n/app_localizations.dart';

class AccountPickerSheet extends StatelessWidget {
  static const String noAccountId = '__no_account__';
  static const TrackedAsset noAccountSelection = TrackedAsset(
    id: noAccountId,
    name: '__no_account__',
    type: AssetType.cash,
    currency: SupportedCurrency.usd,
    amount: 0,
  );

  final String title;
  final List<TrackedAsset> accounts;
  final TrackedAsset? selectedAccount;
  final String? emptySelectionLabel;

  const AccountPickerSheet({
    super.key,
    required this.title,
    required this.accounts,
    this.selectedAccount,
    this.emptySelectionLabel,
  });

  static bool isEmptySelection(TrackedAsset? account) {
    return account?.id == noAccountId;
  }

  static Future<TrackedAsset?> show({
    required BuildContext context,
    required String title,
    required List<TrackedAsset> accounts,
    TrackedAsset? selectedAccount,
    String? emptySelectionLabel,
  }) {
    return showModalBottomSheet<TrackedAsset>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => AccountPickerSheet(
        title: title,
        accounts: accounts,
        selectedAccount: selectedAccount,
        emptySelectionLabel: emptySelectionLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (emptySelectionLabel != null)
              _AccountTile(
                title: emptySelectionLabel!,
                subtitle: null,
                selected: selectedAccount == null,
                onTap: () => Navigator.of(context).pop(noAccountSelection),
              ),
            if (accounts.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Text(
                  emptySelectionLabel ?? '',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: accounts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final account = accounts[index];
                    return _AccountTile(
                      title: account.name,
                      subtitle:
                          '${_assetTypeLabel(l10n, account.type)} · ${Formatter.formatCurrency(account.amount, account.currency)}',
                      selected: selectedAccount?.id == account.id,
                      onTap: () => Navigator.of(context).pop(account),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
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
}

class _AccountTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _AccountTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: theme.cardColor,
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.62,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
