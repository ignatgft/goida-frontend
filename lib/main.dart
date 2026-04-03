import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api/api_client.dart';
import 'core/cache/cache_service.dart';
import 'data/repositories/finance_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/balance_provider.dart';
import 'presentation/providers/transaction_provider.dart';
import 'presentation/providers/chat_provider.dart';
import 'presentation/providers/receipt_provider.dart';
import 'presentation/providers/app_settings_provider.dart';
import 'presentation/providers/notification_provider.dart';
import 'presentation/providers/reminder_provider.dart';
import 'presentation/providers/wallet_connect_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация кэширования
  await CacheService().initialize();

  final api = ApiClient();
  final repo = FinanceRepository(api);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppSettingsProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(api)..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => BalanceProvider(repo),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(repo),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(api),
        ),
        ChangeNotifierProvider(
          create: (_) => ReceiptProvider(api),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(api),
        ),
        ChangeNotifierProvider(
          create: (_) => ReminderProvider(api),
        ),
        ChangeNotifierProvider(
          create: (_) => WalletConnectProvider(),
        ),
      ],
      child: const GoidaApp(),
    ),
  );
}
