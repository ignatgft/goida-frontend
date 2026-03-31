import 'package:flutter/material.dart';
import '../../core/utils/formatter.dart';
import '../../data/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel tx;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionItem(this.tx, {super.key, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final isIncome = tx.type == TransactionType.income;
    final isTransfer = tx.type == TransactionType.transfer;
    final accent = isIncome
        ? const Color(0xFF16C784)
        : isTransfer
        ? const Color(0xFF4DA3FF)
        : const Color(0xFFFF6B6B);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.cardColor,
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: accent.withValues(alpha: 0.12),
            ),
            child: Icon(_categoryIcon(tx.category), color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    tx.category.localizedLabel(languageCode),
                    if (tx.sourceAssetName != null &&
                        tx.sourceAssetName!.isNotEmpty)
                      tx.sourceAssetName!,
                    _formatDate(tx.createdAt),
                  ].join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                  ),
                ),
                if (tx.note != null && tx.note!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    tx.note!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.48,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (onEdit != null || onDelete != null)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface.withValues(alpha: 0.62)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onSelected: (value) {
                if (value == 'edit' && onEdit != null) {
                  onEdit!();
                } else if (value == 'delete' && onDelete != null) {
                  onDelete!();
                }
              },
              itemBuilder: (context) => [
                if (onEdit != null)
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 20),
                        const SizedBox(width: 12),
                        Text('Редактировать'),
                      ],
                    ),
                  ),
                if (onDelete != null)
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, size: 20, color: Colors.red),
                        const SizedBox(width: 12),
                        Text('Удалить', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
              ],
            )
          else
            Text(
              _formatAmount(tx),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
          if (onEdit == null && onDelete == null) ...[
            const SizedBox(width: 12),
            Text(
              _formatAmount(tx),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatAmount(TransactionModel tx) {
    final value = Formatter.formatCurrency(tx.amount.abs(), tx.currency);
    if (tx.type == TransactionType.income) {
      return '+$value';
    }
    if (tx.type == TransactionType.transfer) {
      return value;
    }
    return '-$value';
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }

  IconData _categoryIcon(TransactionCategory category) {
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
