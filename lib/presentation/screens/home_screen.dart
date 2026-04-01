import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../providers/balance_provider.dart';
import '../providers/receipt_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/asset_snapshot_sheet.dart';
import '../widgets/expense_entry_sheet.dart';
import '../widgets/receipt_review_sheet.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';
import 'messenger_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final BalanceProvider _balanceProvider;

  @override
  void initState() {
    super.initState();
    _balanceProvider = context.read<BalanceProvider>();
    Future.microtask(() {
      if (_balanceProvider.overview == null && !_balanceProvider.loading) {
        _balanceProvider.load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MessengerScreen()),
              );
            },
            tooltip: l10n.messenger,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _balanceProvider.load();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              BalanceCard(
                onAddExpenseTap: () {
                  ExpenseEntrySheet.show(context);
                },
                onAddAssetTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    builder: (_) => const AssetSnapshotSheet(),
                  );
                },
                onScanTap: () async {
                  final receiptProvider = context.read<ReceiptProvider>();
                  final receipt = await receiptProvider.scanAndUploadReceipt(
                    context,
                  );
                  if (!context.mounted || receipt == null) {
                    return;
                  }
                  await ReceiptReviewSheet.show(context, receipt: receipt);
                },
                onHistoryTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },
              ),
              // Use Consumer to isolate receipt processing indicator rebuilds
              Consumer<ReceiptProvider>(
                builder: (context, receiptProvider, child) {
                  if (receiptProvider.isProcessing) {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 8),
                            Text(l10n.processingReceipt),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
