import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/ios_design_system.dart';
import '../../data/models/balance.dart';

/// Виджет отображения одного актива (аналог TransactionItem)
class AssetItem extends StatelessWidget {
  final TrackedAsset asset;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AssetItem({
    super.key,
    required this.asset,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeInfo = _getTypeInfo(asset.type);
    final hasActions = onEdit != null || onDelete != null;
    final formatter = NumberFormat('#,##0.00');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Иконка актива
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: typeInfo.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              typeInfo.icon,
              color: typeInfo.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Информация об активе
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  typeInfo.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

          // Сумма и меню
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${asset.currency} ${formatter.format(asset.amount)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: typeInfo.color,
                ),
              ),
              if (hasActions) ...[
                const SizedBox(height: 4),
                PopupMenuButton<String>(
                  icon: Icon(
                    CupertinoIcons.ellipsis,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') onEdit?.call();
                    if (value == 'delete') onDelete?.call();
                  },
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.pencil, size: 18),
                            const SizedBox(width: 8),
                            const Text('Редактировать'),
                          ],
                        ),
                      ),
                    if (onDelete != null)
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.delete, size: 18, color: Colors.red),
                            const SizedBox(width: 8),
                            const Text('Удалить', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  _TypeInfo _getTypeInfo(AssetType type) {
    switch (type) {
      case AssetType.cash:
        return _TypeInfo('Наличные', CupertinoIcons.money_dollar, Colors.green);
      case AssetType.bankAccount:
        return _TypeInfo('Банковский счёт', CupertinoIcons.creditcard, Colors.blue);
      case AssetType.savings:
        return _TypeInfo('Накопления', CupertinoIcons.lock_shield, Colors.purple);
      case AssetType.investments:
        return _TypeInfo('Инвестиции', CupertinoIcons.chart_bar, Colors.orange);
      case AssetType.crypto:
        return _TypeInfo('Криптовалюта', CupertinoIcons.briefcase, Colors.amber);
    }
  }
}

class _TypeInfo {
  final String label;
  final IconData icon;
  final Color color;

  _TypeInfo(this.label, this.icon, this.color);
}
