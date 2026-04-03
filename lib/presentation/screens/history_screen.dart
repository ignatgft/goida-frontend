import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/ios_design_system.dart';
import '../../data/models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../widgets/expense_entry_sheet.dart';
import '../widgets/transaction_item.dart';
import '../widgets/edit_transaction_dialog.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final TransactionProvider _transactionProvider;

  @override
  void initState() {
    super.initState();
    _transactionProvider = context.read<TransactionProvider>();
    Future.microtask(() {
      if (_transactionProvider.list.isEmpty && !_transactionProvider.loading) {
        _transactionProvider.load();
      }
    });
  }

  void _showEditDialog(TransactionModel tx) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditTransactionDialog(transaction: tx),
    );

    if (result != null && mounted) {
      final success = await _transactionProvider.updateTransaction(
        transactionId: tx.id,
        title: result['title'] as String,
        amount: result['amount'] as double,
        currency: tx.currency,
        category: result['category'] as TransactionCategory,
        type: result['type'] as TransactionType,
        createdAt: result['date'] as DateTime?,
        note: result['note'] as String?,
      );

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? l10n.transactionUpdated : l10n.errorUpdating),
            backgroundColor: success ? IosDesignSystem.successGreen : IosDesignSystem.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(TransactionModel tx) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Удаление транзакции'),
        content: Text('Вы уверены, что хотите удалить транзакцию "${tx.title}"?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await _transactionProvider.deleteTransaction(tx.id);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? l10n.transactionDeleted : l10n.errorDeleting),
            backgroundColor: success ? IosDesignSystem.successGreen : IosDesignSystem.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<TransactionProvider>();
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final selectedCategory = provider.selectedCategory;
    final filtered = provider.list;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              ExpenseEntrySheet.show(
                context,
                initialCategory: selectedCategory,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _transactionProvider.load(category: selectedCategory),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.historySubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
              ),
            ),
            const SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _CategoryChip(
                    label: l10n.allCategories,
                    selected: selectedCategory == null,
                    onTap: () => _transactionProvider.load(),
                  ),
                  const SizedBox(width: 8),
                  ...provider.availableCategories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _CategoryChip(
                        label: category.localizedLabel(languageCode),
                        selected: selectedCategory == category,
                        onTap: () =>
                            _transactionProvider.load(category: category),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (provider.loading && provider.list.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Center(
                  child: Text(
                    l10n.noTransactionsYet,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedList(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    initialItemCount: filtered.length,
                    itemBuilder: (context, index, animation) {
                      final tx = filtered[index];
                      return SlideTransition(
                        position: animation.drive(
                          Tween(
                            begin: const Offset(0, 0.3),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeOutCubic)),
                        ),
                        child: FadeTransition(
                          opacity: animation.drive(
                            CurveTween(curve: Curves.easeInOut),
                          ),
                          child: SizeTransition(
                            sizeFactor: animation.drive(
                              CurveTween(curve: Curves.easeOutCubic),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TransactionItem(
                                tx,
                                onEdit: () => _showEditDialog(tx),
                                onDelete: () => _showDeleteConfirmation(tx),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected ? theme.colorScheme.primary : theme.cardColor,
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: selected ? Colors.black : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
