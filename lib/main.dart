import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/api/api_client.dart';
import 'data/repositories/finance_repository.dart';
import 'presentation/providers/balance_provider.dart';
import 'presentation/providers/transaction_provider.dart';
import 'presentation/providers/chat_provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/receipt_provider.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final api = ApiClient();
  final repo = FinanceRepository(api);
  final authProvider = AuthProvider(api);
  await authProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => BalanceProvider(repo)),
        ChangeNotifierProvider(create: (_) => TransactionProvider(repo)),
        ChangeNotifierProvider(
          create: (context) {
            final chatProvider = ChatProvider(api);
            // Initialize with current locale
            WidgetsBinding.instance.addPostFrameCallback((_) {
              chatProvider.setLocale(authProvider.locale);
            });
            return chatProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => ReceiptProvider(api)),
      ],
      child: const GoidaApp(),
    ),
  );
}
