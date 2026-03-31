import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/balance.dart';
import '../../data/models/transaction.dart';
import '../../l10n/app_localizations.dart';
import '../providers/balance_provider.dart';
import '../providers/transaction_provider.dart';
import 'account_picker_sheet.dart';
import 'currency_picker_sheet.dart';
import 'transaction_category_picker_sheet.dart';

class ExpenseEntrySheet extends StatefulWidget {
  final TransactionCategory? initialCategory;

  const ExpenseEntrySheet({super.key, this.initialCategory});

  static Future<void> show(
    BuildContext context, {
    TransactionCategory? initialCategory,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => ExpenseEntrySheet(initialCategory: initialCategory),
    );
  }

  @override
  State<ExpenseEntrySheet> createState() => _ExpenseEntrySheetState();
}

class _ExpenseEntrySheetState extends State<ExpenseEntrySheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  late SupportedCurrency _currency;
  late TransactionCategory _category;
  TrackedAsset? _selectedAsset;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final selectedFiat = context.read<BalanceProvider>().selectedCurrency;
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _noteController = TextEditingController();
    _currency = selectedFiat.isFiat ? selectedFiat : SupportedCurrency.usd;
    _category = widget.initialCategory ?? TransactionCategory.food;
    final spendingAccounts = context.read<BalanceProvider>().spendingAccounts;
    if (spendingAccounts.isNotEmpty) {
      _selectedAsset = spendingAccounts.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

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
                l10n.addExpense,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.expenseSubtitle, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.expenseTitle,
                  hintText: l10n.enterExpenseTitle,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _submitting ? null : () => _pickCategory(context),
                borderRadius: BorderRadius.circular(16),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.expenseCategory,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  child: Text(
                    _category.localizedLabel(languageCode),
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _submitting ? null : () => _pickAccount(context),
                borderRadius: BorderRadius.circular(16),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.spendingAccount,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  child: Text(
                    _selectedAsset == null
                        ? l10n.noAccountSelected
                        : _selectedAsset!.name,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _submitting ? null : () => _pickCurrency(context),
                borderRadius: BorderRadius.circular(16),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.fiatCurrencies,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  child: Text(
                    '${_currency.code} · ${_currency.symbol}',
                    style: theme.textTheme.bodyLarge,
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
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.expenseNote,
                  hintText: l10n.expenseNoteHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.addExpense),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickCategory(BuildContext context) async {
    final selected = await TransactionCategoryPickerSheet.show(
      context: context,
      selectedCategory: _category,
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _category = selected;
    });
  }

  Future<void> _pickCurrency(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final selected = await CurrencyPickerSheet.show(
      context: context,
      title: l10n.fiatCurrencies,
      searchHint: l10n.searchFiatCurrency,
      currencies: SupportedCurrencyX.fiatValues,
      selectedCurrency: _currency,
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _currency = selected;
    });
  }

  Future<void> _pickAccount(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final accounts = context.read<BalanceProvider>().spendingAccounts;
    if (accounts.isEmpty) {
      return;
    }

    final selected = await AccountPickerSheet.show(
      context: context,
      title: l10n.spendingAccount,
      accounts: accounts,
      selectedAccount: _selectedAsset,
      emptySelectionLabel: l10n.noAccountSelected,
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _selectedAsset = AccountPickerSheet.isEmptySelection(selected)
          ? null
          : selected;
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (title.isEmpty || amount == null || amount <= 0) {
      return;
    }

    setState(() {
      _submitting = true;
    });

    final transactionProvider = context.read<TransactionProvider>();
    final synced = await transactionProvider.addExpense(
      title: title,
      amount: amount,
      currency: _currency,
      category: _category,
      note: note.isEmpty ? null : note,
      sourceAssetId: _selectedAsset?.id,
      sourceAssetName: _selectedAsset?.name,
    );

    if (!mounted) {
      return;
    }

    if (synced) {
      await context.read<BalanceProvider>().load();
    } else {
      context.read<BalanceProvider>().registerExpenseLocally(
        amount: amount,
        currency: _currency,
        assetId: _selectedAsset?.id,
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _submitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(synced ? l10n.expenseAdded : l10n.expenseSavedLocally),
      ),
    );
    Navigator.of(context).pop();
  }
}
