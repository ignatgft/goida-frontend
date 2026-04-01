import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: isDark ? Colors.white54 : Colors.black54,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.normal,
          ),
          iconSize: 24,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: [
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.home_filled),
                  if (currentIndex == 0)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              label: l10n.home,
            ),
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.forum_rounded),
                  if (currentIndex == 1)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              label: l10n.messenger,
            ),
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.smart_toy_rounded),
                  if (currentIndex == 2)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              label: l10n.aiChat,
            ),
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.analytics_rounded),
                  if (currentIndex == 3)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              label: l10n.statistics,
            ),
          ],
        ),
      ),
    );
  }
}
