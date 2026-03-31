import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF00D09E);
  static const Color pureBlack = Colors.black;
  static const Color pureWhite = Colors.white;

  // Use a very slightly lighter black for cards to create a "glass" or "layered" effect on pure black
  static const Color surfaceDark = Color(0xFF0A0A0A);
  static const Color borderDark = Color(0xFF1F1F1F);
  static const Color borderLight = Color(0xFFE5E5EA);

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: pureBlack,
    primaryColor: primaryGreen,
    colorScheme: const ColorScheme.dark(
      primary: primaryGreen,
      onPrimary: pureBlack,
      surface: pureBlack,
      onSurface: pureWhite,
      outline: borderDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: pureBlack,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: pureWhite,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: pureWhite),
    ),
    cardTheme: CardThemeData(
      color: pureBlack,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: borderDark, width: 1),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: pureBlack,
      selectedItemColor: primaryGreen,
      unselectedItemColor: Colors.white24,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: pureWhite,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      bodyLarge: TextStyle(color: pureWhite, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white54, fontSize: 14),
    ),
  );

  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: pureWhite,
    primaryColor: primaryGreen,
    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      onPrimary: pureWhite,
      surface: pureWhite,
      onSurface: pureBlack,
      outline: borderLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: pureWhite,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: pureBlack,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: pureBlack),
    ),
    cardTheme: CardThemeData(
      color: pureWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: borderLight, width: 1),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: pureWhite,
      selectedItemColor: primaryGreen,
      unselectedItemColor: Colors.black26,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: pureBlack,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      bodyLarge: TextStyle(color: pureBlack, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black45, fontSize: 14),
    ),
  );
}
