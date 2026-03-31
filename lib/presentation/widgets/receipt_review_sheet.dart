import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/formatter.dart';
import '../../data/models/balance.dart';
import '../../data/models/receipt_scan.dart';
import '../../data/models/transaction.dart';
import '../../l10n/app_localizations.dart';
import '../providers/balance_provider.dart';
import '../providers/receipt_provider.dart';
import '../providers/transaction_provider.dart';
import 'account_picker_sheet.dart';
import 'currency_picker_sheet.dart';
import 'transaction_category_picker_sheet.dart';

class ReceiptReviewSheet extends StatefulWidget {
  final ReceiptScanResult receipt;

  const ReceiptReviewSheet({super.key, required this.receipt});

  static Future<void> show(
    BuildContext context, {
    required ReceiptScanResult receipt,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => ReceiptReviewSheet(receipt: receipt),
    );
  }

  @override
  State<ReceiptReviewSheet> createState() => _ReceiptReviewSheetState();
}

class _ReceiptReviewSheetState extends State<ReceiptReviewSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  late TransactionCategory _category;
  late SupportedCurrency _currency;
  TrackedAsset? _selectedAsset;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.receipt.merchant);
    _amountController = TextEditingController(
      text: widget.receipt.total.toStringAsFixed(2),
    );
    _noteController = TextEditingController(text: widget.receipt.note ?? '');
    _category = widget.receipt.suggestedCategory;
    _currency = widget.receipt.currency;

    final accounts = context.read<BalanceProvider>().spendingAccounts;
    if (accounts.isNotEmpty) {
      _selectedAsset = accounts.first;
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
                l10n.reviewReceipt,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.reviewReceiptSubtitle,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    label:
                        '${l10n.receiptConfidence}: ${(widget.receipt.confidence * 100).clamp(0, 100).toStringAsFixed(0)}%',
                  ),
                  _InfoChip(
                    label:
                        '${l10n.receiptItems}: ${widget.receipt.items.length}',
                  ),
                  _InfoChip(
                    label:
                        '${l10n.receiptDate}: ${_formatDate(widget.receipt.purchasedAt)}',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.expenseTitle,
                  border: const OutlineInputBorder(),
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
                    _selectedAsset?.name ?? l10n.noAccountSelected,
                    style: theme.textTheme.bodyLarge,
                  ),
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
                  hintText: l10n.receiptNoteHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              if (widget.receipt.items.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  l10n.receiptLineItems,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...widget.receipt.items.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: theme.cardColor,
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.08,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${l10n.quantity}: ${item.quantity.toStringAsFixed(item.quantity % 1 == 0 ? 0 : 2)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          Formatter.formatCurrency(item.total, _currency),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
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
                      : Text(l10n.saveReceiptExpense),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

    final receiptPayload = widget.receipt.copyWith(
      merchant: title,
      total: amount,
      currency: _currency,
      suggestedCategory: _category,
      note: note.isEmpty ? null : note,
    );

    final transactionProvider = context.read<TransactionProvider>();
    final synced = await transactionProvider.addExpense(
      title: title,
      amount: amount,
      currency: _currency,
      category: _category,
      note: note.isEmpty ? null : note,
      createdAt: widget.receipt.purchasedAt,
      sourceAssetId: _selectedAsset?.id,
      sourceAssetName: _selectedAsset?.name,
      receipt: receiptPayload,
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

    context.read<ReceiptProvider>().clear();
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

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
