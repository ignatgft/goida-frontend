import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// iOS Human Interface Guidelines Design System
/// Полный дизайн-кит для Goida AI в стиле Apple iOS
class IosDesignSystem {
  // MARK: - Цвета из ТЗ
  static const Color primaryAccent = Color(0xFF007AFF); // Apple голубой
  static const Color successGreen = Color(0xFF34C759); // Apple зеленый
  static const Color errorRed = Color(0xFFFF3B30); // iOS красный
  static const Color warningOrange = Color(0xFFFF9500); // iOS оранжевый
  static const Color infoBlue = Color(0xFF007AFF); // iOS синий

  // MARK: - Системные цвета iOS (Light Mode)
  static const Color systemBackgroundLight = Color(0xFFFFFFFF);
  static const Color secondarySystemBackgroundLight = Color(0xFFF2F2F7);
  static const Color tertiarySystemBackgroundLight = Color(0xFFFFFFFF);
  static const Color systemGroupedBackgroundLight = Color(0xFFF2F2F7);
  static const Color secondarySystemGroupedBackgroundLight = Color(0xFFFFFFFF);
  static const Color tertiarySystemGroupedBackgroundLight = Color(0xFFF2F2F7);

  // MARK: - Системные цвета iOS (Dark Mode)
  static const Color systemBackgroundDark = Color(0xFF000000);
  static const Color secondarySystemBackgroundDark = Color(0xFF1C1C1E);
  static const Color tertiarySystemBackgroundDark = Color(0xFF2C2C2E);
  static const Color systemGroupedBackgroundDark = Color(0xFF000000);
  static const Color secondarySystemGroupedBackgroundDark = Color(0xFF1C1C1E);
  static const Color tertiarySystemGroupedBackgroundDark = Color(0xFF2C2C2E);

  // MARK: - Цвета текста (Light Mode)
  static const Color labelPrimaryLight = Color(0xFF000000);
  static const Color labelSecondaryLight = Color(0xFF3C3C43);
  static const Color labelTertiaryLight = Color(0xFF3C3C4399);
  static const Color labelQuaternaryLight = Color(0xFF3C3C4348);

  // MARK: - Цвета текста (Dark Mode)
  static const Color labelPrimaryDark = Color(0xFFFFFFFF);
  static const Color labelSecondaryDark = Color(0xFFEBEBF5);
  static const Color labelTertiaryDark = Color(0xFFEBEBF599);
  static const Color labelQuaternaryDark = Color(0xFFEBEBF548);

  // MARK: - Разделители (Light Mode)
  static const Color separatorLight = Color(0xFFC6C6C8);
  static const Color separatorLightAlpha = Color(0x19000000);
  
  // MARK: - Разделители (Dark Mode)
  static const Color separatorDark = Color(0xFF38383A);
  static const Color separatorDarkAlpha = Color(0x19FFFFFF);

  // MARK: - Границы (Light Mode)
  static const Color borderLight = Color(0xFFE5E5EA);
  static const Color borderLightAlpha = Color(0x0A000000);
  
  // MARK: - Границы (Dark Mode)
  static const Color borderDark = Color(0xFF3A3A3C);
  static const Color borderDarkAlpha = Color(0x0AFFFFFF);

  // MARK: - Радиусы (iOS HIG)
  static const double radiusSmall = 8.0; // Кнопки, чипсы
  static const double radiusMedium = 12.0; // Карточки в списках
  static const double radiusLarge = 16.0; // Большие карточки
  static const double radiusXLarge = 20.0; // Профиль, модальные окна
  static const double radiusXXLarge = 24.0; // Главные карточки
  static const double radiusAvatar = 40.0; // Аватар (80pt диаметр)

  // MARK: - Отступы
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 20.0;
  static const double paddingXLarge = 24.0;
  static const double sectionSpacing = 32.0; // Между секциями

  // MARK: - Размеры шрифтов (SF Pro, iOS HIG)
  static const double fontSizeLargeTitle = 34.0;
  static const double fontSizeTitle1 = 28.0;
  static const double fontSizeTitle2 = 22.0;
  static const double fontSizeTitle3 = 20.0;
  static const double fontSizeHeadline = 17.0;
  static const double fontSizeBody = 17.0;
  static const double fontSizeCallout = 16.0;
  static const double fontSizeSubheadline = 15.0;
  static const double fontSizeFootnote = 13.0;
  static const double fontSizeCaption1 = 12.0;
  static const double fontSizeCaption2 = 11.0;

  // MARK: - Вес шрифтов
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightSemibold = FontWeight.w600;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightRegular = FontWeight.w400;

  // MARK: - Анимации
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeInOut;
  static const Curve springCurve = Curves.easeOutCubic;

  // MARK: - Тени (Light Mode)
  static List<BoxShadow> get cardShadowLight => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevatedShadowLight => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  // MARK: - Тени (Dark Mode)
  static List<BoxShadow> get cardShadowDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevatedShadowDark => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  // MARK: - Helpers для получения цветов в зависимости от темы
  static Color getSystemBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? systemBackgroundDark : systemBackgroundLight;
  }

  static Color getSecondarySystemBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? secondarySystemBackgroundDark : secondarySystemBackgroundLight;
  }

  static Color getTertiarySystemBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? tertiarySystemBackgroundDark : tertiarySystemBackgroundLight;
  }

  static Color getSystemGroupedBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? systemGroupedBackgroundDark : systemGroupedBackgroundLight;
  }

  static Color getLabelPrimary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? labelPrimaryDark : labelPrimaryLight;
  }

  static Color getLabelSecondary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? labelSecondaryDark : labelSecondaryLight;
  }

  static Color getLabelTertiary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? labelTertiaryDark : labelTertiaryLight;
  }

  static Color getSeparator(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? separatorDark : separatorLight;
  }

  static Color getBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? borderDark : borderLight;
  }

  static List<BoxShadow> getCardShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? cardShadowDark : cardShadowLight;
  }

  static Color getPrimaryAccentWithAlpha(BuildContext context, double alpha) {
    return primaryAccent.withValues(alpha: alpha);
  }

  // MARK: - Cupertino Themes
  static CupertinoThemeData get lightCupertinoTheme {
    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: primaryAccent,
      scaffoldBackgroundColor: systemGroupedBackgroundLight,
      barBackgroundColor: systemBackgroundLight.withValues(alpha: 0.9),
      textTheme: const CupertinoTextThemeData(
        textStyle: TextStyle(
          color: labelPrimaryLight,
          fontFamily: '.SF Pro Text',
        ),
        navTitleTextStyle: TextStyle(
          color: labelPrimaryLight,
          fontSize: fontSizeTitle3,
          fontWeight: weightSemibold,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: labelPrimaryLight,
          fontSize: fontSizeLargeTitle,
          fontWeight: weightBold,
        ),
        actionTextStyle: TextStyle(
          color: primaryAccent,
          fontSize: fontSizeBody,
        ),
        tabLabelTextStyle: TextStyle(
          color: primaryAccent,
          fontSize: fontSizeCaption2,
        ),
      ),
    );
  }

  static CupertinoThemeData get darkCupertinoTheme {
    return CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryAccent,
      scaffoldBackgroundColor: systemGroupedBackgroundDark,
      barBackgroundColor: systemBackgroundDark.withValues(alpha: 0.9),
      textTheme: const CupertinoTextThemeData(
        textStyle: TextStyle(
          color: labelPrimaryDark,
          fontFamily: '.SF Pro Text',
        ),
        navTitleTextStyle: TextStyle(
          color: labelPrimaryDark,
          fontSize: fontSizeTitle3,
          fontWeight: weightSemibold,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: labelPrimaryDark,
          fontSize: fontSizeLargeTitle,
          fontWeight: weightBold,
        ),
        actionTextStyle: TextStyle(
          color: primaryAccent,
          fontSize: fontSizeBody,
        ),
        tabLabelTextStyle: TextStyle(
          color: primaryAccent,
          fontSize: fontSizeCaption2,
        ),
      ),
    );
  }

  // MARK: - Material Light Theme
  static ThemeData get lightMaterialTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: systemGroupedBackgroundLight,
      primaryColor: primaryAccent,
      colorScheme: const ColorScheme.light(
        primary: primaryAccent,
        onPrimary: Colors.white,
        secondary: successGreen,
        onSecondary: Colors.white,
        surface: systemBackgroundLight,
        onSurface: labelPrimaryLight,
        outline: separatorLight,
        shadow: Colors.black26,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: systemBackgroundLight.withValues(alpha: 0.95),
        foregroundColor: labelPrimaryLight,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: labelPrimaryLight,
          fontSize: fontSizeTitle3,
          fontWeight: weightBold,
          fontFamily: '.SF Pro Display',
        ),
        iconTheme: const IconThemeData(
          color: labelPrimaryLight,
          size: 24,
        ),
        shadowColor: Colors.black12,
      ),
      cardTheme: CardThemeData(
        color: secondarySystemGroupedBackgroundLight,
        elevation: 0,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          side: BorderSide(
            color: borderLight.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: systemBackgroundLight,
        selectedItemColor: primaryAccent,
        unselectedItemColor: labelSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 1,
        selectedLabelStyle: TextStyle(
          fontSize: fontSizeCaption2,
          fontWeight: weightSemibold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: fontSizeCaption2,
          fontWeight: weightRegular,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: fontSizeLargeTitle,
          fontWeight: weightBold,
          color: labelPrimaryLight,
          letterSpacing: -0.5,
          fontFamily: '.SF Pro Display',
        ),
        displayMedium: TextStyle(
          fontSize: fontSizeTitle1,
          fontWeight: weightBold,
          color: labelPrimaryLight,
          fontFamily: '.SF Pro Display',
        ),
        displaySmall: TextStyle(
          fontSize: fontSizeTitle2,
          fontWeight: weightSemibold,
          color: labelPrimaryLight,
          fontFamily: '.SF Pro Display',
        ),
        headlineLarge: TextStyle(
          fontSize: fontSizeTitle3,
          fontWeight: weightBold,
          color: labelPrimaryLight,
          fontFamily: '.SF Pro Display',
        ),
        headlineMedium: TextStyle(
          fontSize: fontSizeHeadline,
          fontWeight: weightSemibold,
          color: labelPrimaryLight,
        ),
        titleLarge: TextStyle(
          fontSize: fontSizeBody,
          fontWeight: weightSemibold,
          color: labelPrimaryLight,
        ),
        titleMedium: TextStyle(
          fontSize: fontSizeCallout,
          fontWeight: weightMedium,
          color: labelPrimaryLight,
        ),
        titleSmall: TextStyle(
          fontSize: fontSizeSubheadline,
          fontWeight: weightMedium,
          color: labelPrimaryLight,
        ),
        bodyLarge: TextStyle(
          fontSize: fontSizeBody,
          fontWeight: weightRegular,
          color: labelPrimaryLight,
        ),
        bodyMedium: TextStyle(
          fontSize: fontSizeCallout,
          fontWeight: weightRegular,
          color: labelSecondaryLight,
        ),
        bodySmall: TextStyle(
          fontSize: fontSizeFootnote,
          fontWeight: weightRegular,
          color: labelTertiaryLight,
        ),
        labelLarge: TextStyle(
          fontSize: fontSizeHeadline,
          fontWeight: weightMedium,
          color: labelPrimaryLight,
        ),
        labelMedium: TextStyle(
          fontSize: fontSizeSubheadline,
          fontWeight: weightMedium,
          color: labelSecondaryLight,
        ),
        labelSmall: TextStyle(
          fontSize: fontSizeCaption1,
          fontWeight: weightRegular,
          color: labelTertiaryLight,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondarySystemBackgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: paddingMedium,
          vertical: paddingSmall,
        ),
        hintStyle: const TextStyle(
          color: labelTertiaryLight,
          fontSize: fontSizeBody,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: secondarySystemBackgroundLight,
        selectedColor: primaryAccent.withValues(alpha: 0.15),
        labelStyle: const TextStyle(
          color: labelPrimaryLight,
          fontSize: fontSizeSubheadline,
          fontWeight: weightMedium,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: paddingSmall,
          vertical: paddingSmall / 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          side: BorderSide(color: borderLight.withValues(alpha: 0.5)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingXLarge,
            vertical: paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeBody,
            fontWeight: weightSemibold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryAccent,
          side: const BorderSide(color: primaryAccent),
          padding: const EdgeInsets.symmetric(
            horizontal: paddingXLarge,
            vertical: paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeBody,
            fontWeight: weightSemibold,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: labelPrimaryLight,
          padding: const EdgeInsets.all(paddingSmall),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: separatorLight,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryAccent;
          }
          return Colors.grey.shade400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryAccent.withValues(alpha: 0.5);
          }
          return Colors.grey.shade200;
        }),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: paddingMedium,
          vertical: paddingSmall,
        ),
        titleTextStyle: TextStyle(
          fontSize: fontSizeBody,
          fontWeight: weightRegular,
          color: labelPrimaryLight,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: fontSizeSubheadline,
          fontWeight: weightRegular,
          color: labelSecondaryLight,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
      ),
    );
  }

  // MARK: - Material Dark Theme
  static ThemeData get darkMaterialTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: systemGroupedBackgroundDark,
      primaryColor: primaryAccent,
      colorScheme: const ColorScheme.dark(
        primary: primaryAccent,
        onPrimary: Colors.white,
        secondary: successGreen,
        onSecondary: Colors.white,
        surface: systemBackgroundDark,
        onSurface: labelPrimaryDark,
        outline: separatorDark,
        shadow: Colors.black54,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: systemBackgroundDark.withValues(alpha: 0.95),
        foregroundColor: labelPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: labelPrimaryDark,
          fontSize: fontSizeTitle3,
          fontWeight: weightBold,
          fontFamily: '.SF Pro Display',
        ),
        iconTheme: const IconThemeData(
          color: labelPrimaryDark,
          size: 24,
        ),
        shadowColor: Colors.black54,
      ),
      cardTheme: CardThemeData(
        color: secondarySystemGroupedBackgroundDark,
        elevation: 0,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          side: BorderSide(
            color: borderDark.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: systemBackgroundDark,
        selectedItemColor: primaryAccent,
        unselectedItemColor: labelSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 1,
        selectedLabelStyle: TextStyle(
          fontSize: fontSizeCaption2,
          fontWeight: weightSemibold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: fontSizeCaption2,
          fontWeight: weightRegular,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: fontSizeLargeTitle,
          fontWeight: weightBold,
          color: labelPrimaryDark,
          letterSpacing: -0.5,
          fontFamily: '.SF Pro Display',
        ),
        displayMedium: TextStyle(
          fontSize: fontSizeTitle1,
          fontWeight: weightBold,
          color: labelPrimaryDark,
          fontFamily: '.SF Pro Display',
        ),
        displaySmall: TextStyle(
          fontSize: fontSizeTitle2,
          fontWeight: weightSemibold,
          color: labelPrimaryDark,
          fontFamily: '.SF Pro Display',
        ),
        headlineLarge: TextStyle(
          fontSize: fontSizeTitle3,
          fontWeight: weightBold,
          color: labelPrimaryDark,
          fontFamily: '.SF Pro Display',
        ),
        headlineMedium: TextStyle(
          fontSize: fontSizeHeadline,
          fontWeight: weightSemibold,
          color: labelPrimaryDark,
        ),
        titleLarge: TextStyle(
          fontSize: fontSizeBody,
          fontWeight: weightSemibold,
          color: labelPrimaryDark,
        ),
        titleMedium: TextStyle(
          fontSize: fontSizeCallout,
          fontWeight: weightMedium,
          color: labelPrimaryDark,
        ),
        titleSmall: TextStyle(
          fontSize: fontSizeSubheadline,
          fontWeight: weightMedium,
          color: labelPrimaryDark,
        ),
        bodyLarge: TextStyle(
          fontSize: fontSizeBody,
          fontWeight: weightRegular,
          color: labelPrimaryDark,
        ),
        bodyMedium: TextStyle(
          fontSize: fontSizeCallout,
          fontWeight: weightRegular,
          color: labelSecondaryDark,
        ),
        bodySmall: TextStyle(
          fontSize: fontSizeFootnote,
          fontWeight: weightRegular,
          color: labelTertiaryDark,
        ),
        labelLarge: TextStyle(
          fontSize: fontSizeHeadline,
          fontWeight: weightMedium,
          color: labelPrimaryDark,
        ),
        labelMedium: TextStyle(
          fontSize: fontSizeSubheadline,
          fontWeight: weightMedium,
          color: labelSecondaryDark,
        ),
        labelSmall: TextStyle(
          fontSize: fontSizeCaption1,
          fontWeight: weightRegular,
          color: labelTertiaryDark,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondarySystemBackgroundDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: paddingMedium,
          vertical: paddingSmall,
        ),
        hintStyle: const TextStyle(
          color: labelTertiaryDark,
          fontSize: fontSizeBody,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: secondarySystemBackgroundDark,
        selectedColor: primaryAccent.withValues(alpha: 0.2),
        labelStyle: const TextStyle(
          color: labelPrimaryDark,
          fontSize: fontSizeSubheadline,
          fontWeight: weightMedium,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: paddingSmall,
          vertical: paddingSmall / 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          side: BorderSide(color: borderDark.withValues(alpha: 0.5)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingXLarge,
            vertical: paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeBody,
            fontWeight: weightSemibold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryAccent,
          side: const BorderSide(color: primaryAccent),
          padding: const EdgeInsets.symmetric(
            horizontal: paddingXLarge,
            vertical: paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeBody,
            fontWeight: weightSemibold,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: labelPrimaryDark,
          padding: const EdgeInsets.all(paddingSmall),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: separatorDark,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryAccent;
          }
          return Colors.grey.shade600;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryAccent.withValues(alpha: 0.5);
          }
          return Colors.grey.shade800;
        }),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: paddingMedium,
          vertical: paddingSmall,
        ),
        titleTextStyle: TextStyle(
          fontSize: fontSizeBody,
          fontWeight: weightRegular,
          color: labelPrimaryDark,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: fontSizeSubheadline,
          fontWeight: weightRegular,
          color: labelSecondaryDark,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
      ),
    );
  }
}
