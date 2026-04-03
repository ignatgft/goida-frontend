import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/ios_design_system.dart';
import '../providers/transaction_provider.dart';
import '../../data/models/transaction.dart';
import '../widgets/transaction_item.dart';

/// Экран истории платежей
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем транзакции после первого фрейма
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = context.read<TransactionProvider>();
        if (provider.list.isEmpty && !provider.loading) {
          provider.load();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: IosDesignSystem.getSystemGroupedBackground(context),
      appBar: AppBar(
        title: Text(l10n.billingHistory),
        backgroundColor: IosDesignSystem.getSystemBackground(context).withValues(alpha: 0.95),
        elevation: 0,
        foregroundColor: IosDesignSystem.getLabelPrimary(context),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.loading && provider.list.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.doc_text,
                    size: 80,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет транзакций',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ваши платежи будут отображаться здесь',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            );
          }

          // Группируем транзакции по дате
          final groupedTransactions = _groupByDate(provider.list);

          return RefreshIndicator(
            onRefresh: () => provider.load(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final date = groupedTransactions.keys.elementAt(index);
                final transactions = groupedTransactions[date]!;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок даты
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _formatDate(date),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Карточка с транзакциями
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.dividerColor,
                        ),
                      ),
                      child: Column(
                        children: transactions.map((tx) {
                          final txIndex = transactions.indexOf(tx);
                          return Column(
                            children: [
                              if (txIndex > 0)
                                Divider(
                                  height: 1,
                                  color: theme.dividerColor,
                                ),
                              TransactionItem(tx),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Группировка транзакций по дате
  Map<DateTime, List<TransactionModel>> _groupByDate(List<TransactionModel> transactions) {
    final Map<DateTime, List<TransactionModel>> grouped = {};
    
    for (final tx in transactions) {
      final date = DateTime(
        tx.createdAt.year,
        tx.createdAt.month,
        tx.createdAt.day,
      );
      
      if (grouped.containsKey(date)) {
        grouped[date]!.add(tx);
      } else {
        grouped[date] = [tx];
      }
    }
    
    // Сортируем по дате (новые сверху)
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    
    return {
      for (final key in sortedKeys) key: grouped[key]!
    };
  }

  /// Форматирование даты
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Сегодня';
    } else if (targetDate == yesterday) {
      return 'Вчера';
    } else {
      final months = [
        'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
        'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }
}
