import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ios_design_system.dart';

/// iOS Human Interface Guidelines Theme
/// Цветовая палитра и стили на основе Apple Finance, Stocks, Wallet
class IosTheme {
  // Цвета из дизайн-системы
  static Color get primaryAccent => IosDesignSystem.primaryAccent;
  static Color get successGreen => IosDesignSystem.successGreen;
  static Color get gradientStart => IosDesignSystem.primaryAccent;
  static Color get gradientEnd => IosDesignSystem.successGreen;

  // Системные цвета (Dark Mode - по умолчанию)
  static Color get systemBackground => IosDesignSystem.systemBackgroundDark;
  static Color get secondarySystemBackground => IosDesignSystem.secondarySystemBackgroundDark;
  static Color get tertiarySystemBackground => IosDesignSystem.tertiarySystemBackgroundDark;
  static Color get systemGray6 => IosDesignSystem.secondarySystemBackgroundDark;

  // Разделители и границы
  static Color get separatorDark => IosDesignSystem.separatorDark;
  static Color get separatorLight => IosDesignSystem.separatorLight;
  static Color get borderDark => IosDesignSystem.borderDark;
  static Color get borderLight => IosDesignSystem.borderLight;

  // Текст
  static Color get labelPrimary => IosDesignSystem.labelPrimaryDark;
  static Color get labelSecondary => IosDesignSystem.labelSecondaryDark;
  static Color get labelTertiary => IosDesignSystem.labelTertiaryDark;
  static Color get labelQuaternary => IosDesignSystem.labelQuaternaryDark;

  // Радиусы
  static double get radiusSmall => IosDesignSystem.radiusSmall;
  static double get radiusMedium => IosDesignSystem.radiusMedium;
  static double get radiusLarge => IosDesignSystem.radiusLarge;
  static double get radiusXLarge => IosDesignSystem.radiusXLarge;
  static double get radiusXXLarge => IosDesignSystem.radiusXXLarge;

  // Отступы
  static double get paddingSmall => IosDesignSystem.paddingSmall;
  static double get paddingMedium => IosDesignSystem.paddingMedium;
  static double get paddingLarge => IosDesignSystem.paddingLarge;
  static double get paddingXLarge => IosDesignSystem.paddingXLarge;

  // Размеры шрифтов
  static double get fontSizeLargeTitle => IosDesignSystem.fontSizeLargeTitle;
  static double get fontSizeTitle1 => IosDesignSystem.fontSizeTitle1;
  static double get fontSizeTitle2 => IosDesignSystem.fontSizeTitle2;
  static double get fontSizeTitle3 => IosDesignSystem.fontSizeTitle3;
  static double get fontSizeHeadline => IosDesignSystem.fontSizeHeadline;
  static double get fontSizeBody => IosDesignSystem.fontSizeBody;
  static double get fontSizeCallout => IosDesignSystem.fontSizeCallout;
  static double get fontSizeSubheadline => IosDesignSystem.fontSizeSubheadline;
  static double get fontSizeFootnote => IosDesignSystem.fontSizeFootnote;
  static double get fontSizeCaption1 => IosDesignSystem.fontSizeCaption1;
  static double get fontSizeCaption2 => IosDesignSystem.fontSizeCaption2;

  // Вес шрифтов
  static FontWeight get weightBold => IosDesignSystem.weightBold;
  static FontWeight get weightSemibold => IosDesignSystem.weightSemibold;
  static FontWeight get weightMedium => IosDesignSystem.weightMedium;
  static FontWeight get weightRegular => IosDesignSystem.weightRegular;

  // Тени
  static List<BoxShadow> get cardShadow => IosDesignSystem.cardShadowDark;
  static List<BoxShadow> get elevatedShadow => IosDesignSystem.elevatedShadowDark;

  // MARK: - ThemeData для Material (Dark Mode - по умолчанию)
  static ThemeData get darkTheme {
    return IosDesignSystem.darkMaterialTheme;
  }

  // MARK: - Light Theme
  static ThemeData get lightTheme {
    return IosDesignSystem.lightMaterialTheme;
  }

  // MARK: - Cupertino Theme (Dark Mode)
  static CupertinoThemeData get cupertinoTheme {
    return IosDesignSystem.darkCupertinoTheme;
  }

  // MARK: - Cupertino Light Theme
  static CupertinoThemeData get cupertinoLightTheme {
    return IosDesignSystem.lightCupertinoTheme;
  }
}
