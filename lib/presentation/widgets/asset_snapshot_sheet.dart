import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/balance.dart';
import '../../l10n/app_localizations.dart';
import '../providers/balance_provider.dart';
import 'currency_picker_sheet.dart';

class AssetSnapshotSheet extends StatefulWidget {
  final TrackedAsset? asset;

  const AssetSnapshotSheet({super.key, this.asset});

  @override
  State<AssetSnapshotSheet> createState() => _AssetSnapshotSheetState();
}

class _AssetSnapshotSheetState extends State<AssetSnapshotSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late AssetType _assetType;
  late SupportedCurrency _currency;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final asset = widget.asset;
    _nameController = TextEditingController(text: asset?.name ?? '');
    _amountController = TextEditingController(
      text: asset != null ? asset.amount.toString() : '',
    );
    _assetType = asset?.type ?? AssetType.bankAccount;
    _currency = asset?.currency ?? SupportedCurrency.usd;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currencyOptions = _assetType == AssetType.crypto
        ? SupportedCurrencyX.cryptoValues
        : SupportedCurrencyX.fiatValues;

    if (!currencyOptions.contains(_currency)) {
      _currency = currencyOptions.first;
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                widget.asset == null ? l10n.addAsset : l10n.editAsset,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.trackAssets, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.assetName,
                  hintText: l10n.enterAssetName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<AssetType>(
                initialValue: _assetType,
                decoration: InputDecoration(
                  labelText: l10n.assetType,
                  border: const OutlineInputBorder(),
                ),
                items: AssetType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_assetTypeLabel(l10n, type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _assetType = value;
                    _currency = value == AssetType.crypto
                        ? SupportedCurrencyX.cryptoValues.first
                        : SupportedCurrencyX.fiatValues.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _pickCurrency(context, currencyOptions),
                borderRadius: BorderRadius.circular(16),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: _assetType == AssetType.crypto
                        ? l10n.cryptoCurrencies
                        : l10n.fiatCurrencies,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_currency.code} · ${_currency.symbol}',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l10n.enterAmount,
                  prefixText: '${_currency.symbol} ',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  if (widget.asset != null) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _submitting ? null : _deleteAsset,
                        icon: const Icon(Icons.delete_outline),
                        label: Text(l10n.deleteAsset),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              widget.asset == null
                                  ? l10n.saveAsset
                                  : l10n.saveChanges,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (name.isEmpty || amount == null || amount <= 0) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    final provider = context.read<BalanceProvider>();
    final asset = widget.asset;
    final synced = asset == null
        ? await provider.addAsset(
            name: name,
            type: _assetType,
            currency: _currency,
            amount: amount,
          )
        : await provider.updateAsset(
            assetId: asset.id,
            name: name,
            type: _assetType,
            currency: _currency,
            amount: amount,
          );

    if (!mounted) {
      return;
    }

    setState(() {
      _submitting = false;
    });

    final successText = asset == null
        ? (synced ? l10n.assetSaved : l10n.assetSavedLocally)
        : (synced ? l10n.assetUpdated : l10n.assetSavedLocally);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(successText)));
    Navigator.of(context).pop();
  }

  Future<void> _deleteAsset() async {
    final asset = widget.asset;
    final l10n = AppLocalizations.of(context)!;
    if (asset == null) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    final deleted = await context.read<BalanceProvider>().deleteAsset(asset.id);

    if (!mounted) {
      return;
    }

    setState(() {
      _submitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(deleted ? l10n.assetDeleted : l10n.assetSavedLocally),
      ),
    );
    Navigator.of(context).pop();
  }

  Future<void> _pickCurrency(
    BuildContext context,
    List<SupportedCurrency> currencyOptions,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final selected = await CurrencyPickerSheet.show(
      context: context,
      title: _assetType == AssetType.crypto
          ? l10n.cryptoCurrencies
          : l10n.fiatCurrencies,
      searchHint: _assetType == AssetType.crypto
          ? l10n.searchCryptoCurrency
          : l10n.searchFiatCurrency,
      currencies: currencyOptions,
      selectedCurrency: _currency,
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _currency = selected;
    });
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
