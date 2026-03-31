import 'package:flutter/material.dart';
import '../../data/models/transaction.dart';

class TransactionCategoryPickerSheet extends StatelessWidget {
  final TransactionCategory selectedCategory;

  const TransactionCategoryPickerSheet({
    super.key,
    required this.selectedCategory,
  });

  static Future<TransactionCategory?> show({
    required BuildContext context,
    required TransactionCategory selectedCategory,
  }) {
    return showModalBottomSheet<TransactionCategory>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) =>
          TransactionCategoryPickerSheet(selectedCategory: selectedCategory),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final languageCode = Localizations.localeOf(context).languageCode;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final sheetColor = isDark ? const Color(0xFF090909) : Colors.white;
    final tileColor = isDark
        ? const Color(0xFF050505)
        : const Color(0xFFF7F8FA);

    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: sheetColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
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
              const SizedBox(height: 18),
              Text(
                languageCode == 'ru' ? 'Категория траты' : 'Expense category',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: TransactionCategoryX.expenseValues.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final category = TransactionCategoryX.expenseValues[index];
                    final selected = category == selectedCategory;
                    return ListTile(
                      tileColor: selected
                          ? theme.colorScheme.primary.withValues(alpha: 0.09)
                          : tileColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: selected
                              ? theme.colorScheme.primary
                              : borderColor,
                        ),
                      ),
                      leading: Icon(
                        _iconFor(category),
                        color: selected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.76,
                              ),
                      ),
                      title: Text(
                        category.localizedLabel(languageCode),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: selected
                          ? Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                      onTap: () => Navigator.of(context).pop(category),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(TransactionCategory category) {
    return switch (category) {
      TransactionCategory.food => Icons.restaurant_rounded,
      TransactionCategory.transport => Icons.directions_car_rounded,
      TransactionCategory.shopping => Icons.shopping_bag_rounded,
      TransactionCategory.bills => Icons.receipt_long_rounded,
      TransactionCategory.salary => Icons.account_balance_wallet_rounded,
      TransactionCategory.crypto => Icons.currency_bitcoin_rounded,
      TransactionCategory.subscriptions => Icons.subscriptions_rounded,
      TransactionCategory.entertainment => Icons.movie_creation_rounded,
      TransactionCategory.health => Icons.favorite_rounded,
      TransactionCategory.education => Icons.school_rounded,
      TransactionCategory.travel => Icons.flight_takeoff_rounded,
      TransactionCategory.transfer => Icons.swap_horiz_rounded,
      TransactionCategory.other => Icons.grid_view_rounded,
    };
  }
}
