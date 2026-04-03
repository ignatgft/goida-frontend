import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/ios_design_system.dart';
import '../providers/auth_provider.dart';

/// Экран входа в стиле iOS приложения
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: IosDesignSystem.getSystemGroupedBackground(context),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Пространство сверху
            const SliverPadding(padding: EdgeInsets.only(top: 60)),

            // Логотип
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        IosDesignSystem.primaryAccent,
                        IosDesignSystem.primaryAccent.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: IosDesignSystem.primaryAccent.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.creditcard_fill,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(top: 40)),

            // Заголовок
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Text(
                      'Goida AI',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: IosDesignSystem.getLabelPrimary(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.loginDescription,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(top: 60)),

            // Кнопки входа
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: authProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          // Google Login
                          _buildGoogleButton(context, authProvider, l10n),
                          const SizedBox(height: 12),

                          // Dev Login
                          _buildDevButton(context, authProvider),
                          const SizedBox(height: 20),

                          // Demo Mode
                          TextButton(
                            onPressed: () => authProvider.loginAsDemo(),
                            child: Text(
                              l10n.tryDemoMode,
                              style: TextStyle(
                                color: IosDesignSystem.primaryAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleButton(
    BuildContext context,
    AuthProvider authProvider,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CupertinoButton(
      onPressed: () => authProvider.signInWithGoogle(),
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://www.gstatic.com/images/branding/product/1x/gsa_512dp.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.login, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.signInWithGoogle,
              style: TextStyle(
                color: isDark ? Colors.black : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevButton(BuildContext context, AuthProvider authProvider) {
    return CupertinoButton(
      onPressed: () => authProvider.signInAsDev(),
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: IosDesignSystem.primaryAccent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.hammer_fill, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Войти как разработчик',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
