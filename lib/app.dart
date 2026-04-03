import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/ios_theme.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/chat_screen.dart';
import 'presentation/screens/chart_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/widgets/bottom_nav.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/balance_provider.dart';
import 'presentation/providers/chat_provider.dart';
import 'presentation/providers/receipt_provider.dart';
import 'presentation/providers/transaction_provider.dart';
import 'presentation/providers/app_settings_provider.dart';

class GoidaApp extends StatefulWidget {
  const GoidaApp({super.key});

  @override
  State<GoidaApp> createState() => _GoidaAppState();
}

class _GoidaAppState extends State<GoidaApp> {
  int _currentIndex = 0;
  late final PageController _pageController;
  AuthProvider? _authProvider;
  String? _activeSessionKey;

  // Единые экраны для всех платформ
  final List<Widget> _screens = [
    const HomeScreen(),
    const ChatScreen(),
    const ChartScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _authProvider?.removeListener(_handleAuthStateChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = context.read<AuthProvider>();
    if (_authProvider == authProvider) {
      return;
    }

    _authProvider?.removeListener(_handleAuthStateChanged);
    _authProvider = authProvider;
    _authProvider?.addListener(_handleAuthStateChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleAuthStateChanged();
    });
  }

  void _onNavTap(int index) {
    if (_currentIndex == index) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _handleAuthStateChanged() async {
    final auth = _authProvider;
    if (auth == null || !mounted || !auth.isInitialized) {
      return;
    }

    final nextSessionKey = auth.sessionKey;
    if (nextSessionKey == _activeSessionKey) {
      return;
    }
    _activeSessionKey = nextSessionKey;

    final balanceProvider = context.read<BalanceProvider>();
    final transactionProvider = context.read<TransactionProvider>();
    final chatProvider = context.read<ChatProvider>();
    final receiptProvider = context.read<ReceiptProvider>();

    if (nextSessionKey == null) {
      // Пользователь вышел — сбрасываем всё
      setState(() {
        _currentIndex = 0;
      });
      balanceProvider.clear();
      transactionProvider.clear();
      chatProvider.clearChat();
      receiptProvider.clear();
      return;
    }

    chatProvider.clearChat();
    receiptProvider.clear();

    if (auth.isDemoMode) {
      balanceProvider.loadDemoData();
      transactionProvider.loadDemoData();
      return;
    }

    balanceProvider.clear();
    transactionProvider.clear();
    await Future.wait([balanceProvider.load(), transactionProvider.load()]);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final appSettings = context.watch<AppSettingsProvider>();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: appSettings.themeMode == ThemeMode.dark
          ? Brightness.dark
          : Brightness.light,
      statusBarIconBrightness: appSettings.themeMode == ThemeMode.dark
          ? Brightness.light
          : Brightness.dark,
    ));

    if (!authProvider.isInitialized || !appSettings.isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Goida AI',
        theme: IosTheme.lightTheme,
        darkTheme: IosTheme.darkTheme,
        themeMode: appSettings.themeMode,
        locale: appSettings.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goida AI',
      theme: IosTheme.lightTheme,
      darkTheme: IosTheme.darkTheme,
      themeMode: appSettings.themeMode,
      locale: appSettings.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: authProvider.isAuthenticated
          ? Scaffold(
              body: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  if (_currentIndex == index) {
                    return;
                  }
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: _screens,
              ),
              bottomNavigationBar: BottomNav(
                currentIndex: _currentIndex,
                onTap: _onNavTap,
              ),
            )
          : const LoginScreen(),
    );
  }
}
