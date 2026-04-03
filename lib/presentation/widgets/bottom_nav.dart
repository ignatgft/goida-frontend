import 'package:flutter/material.dart';
import '../../core/theme/ios_design_system.dart';
import '../../l10n/app_localizations.dart';

/// Нижняя навигация в едином стиле
class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: IosDesignSystem.getSystemBackground(context),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: IosDesignSystem.getSeparator(context).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: isDark
            ? IosDesignSystem.cardShadowDark
            : IosDesignSystem.cardShadowLight,
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: IosDesignSystem.primaryAccent,
          unselectedItemColor: IosDesignSystem.getLabelSecondary(context),
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: IosDesignSystem.weightSemibold,
            color: IosDesignSystem.primaryAccent,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
            fontWeight: IosDesignSystem.weightRegular,
            color: IosDesignSystem.getLabelSecondary(context),
          ),
          iconSize: 24,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: [
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home_filled,
                    color: currentIndex == 0
                        ? IosDesignSystem.primaryAccent
                        : IosDesignSystem.getLabelSecondary(context),
                  ),
                  if (currentIndex == 0)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: IosDesignSystem.primaryAccent,
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
                  Icon(
                    Icons.smart_toy_rounded,
                    color: currentIndex == 1
                        ? IosDesignSystem.primaryAccent
                        : IosDesignSystem.getLabelSecondary(context),
                  ),
                  if (currentIndex == 1)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: IosDesignSystem.primaryAccent,
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
                  Icon(
                    Icons.analytics_rounded,
                    color: currentIndex == 2
                        ? IosDesignSystem.primaryAccent
                        : IosDesignSystem.getLabelSecondary(context),
                  ),
                  if (currentIndex == 2)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: IosDesignSystem.primaryAccent,
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
