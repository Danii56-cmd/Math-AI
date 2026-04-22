import 'package:flutter/material.dart';
import 'package:math_ai/core/app_constants.dart';

class ThemeChangerProvider with ChangeNotifier {
  var _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}

class AppTheme {
  // ── Brand colors (from your palette screenshot) ──────────────────────────
  static const Color primary = Color(0xFF00D2FF); // cyan
  static const Color secondary = Color(0xFF1E293B); // dark navy card/surface
  static const Color tertiary = Color(0xFFA78BFA); // purple accent
  static const Color neutral = Color(0xFF0F172A); // deepest background

  // ── Light theme (unchanged) ───────────────────────────────────────────────
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppConstants.primaryColor,
    colorScheme: ColorScheme.light(
      primary: AppConstants.primaryColor,
      secondary: AppConstants.primaryColor,
      surface: Colors.white,
      background: Colors.white,
      onPrimary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black87),
      labelLarge: TextStyle(color: Colors.black),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    cardColor: Colors.white,
  );

  // ── Dark theme (matches your screenshot palette) ──────────────────────────
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primary,

    colorScheme: const ColorScheme.dark(
      primary: primary, // #00D2FF – buttons, toggles, active icons
      onPrimary: neutral, // text/icons ON primary-colored surfaces
      secondary: tertiary, // #A78BFA – FABs, chips, highlights
      onSecondary: Colors.white,
      tertiary: tertiary, // extra accent slots
      onTertiary: Colors.white,
      surface: secondary, // #1E293B – cards, bottom sheets
      onSurface: Colors.white,
      background: neutral, // #0F172A – scaffold background
      onBackground: Colors.white,
      outline: Color(0xFF334155), // subtle borders (slate-700)
      surfaceVariant: Color(0xFF1E293B), // slightly raised surfaces
    ),

    scaffoldBackgroundColor: neutral, // #0F172A

    appBarTheme: const AppBarTheme(
      backgroundColor: neutral, // #0F172A
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: secondary, // #1E293B – matches your nav bar
      selectedItemColor: primary, // #00D2FF
      unselectedItemColor: Colors.white54,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white70),
      labelLarge: TextStyle(color: Colors.white),
    ),

    iconTheme: const IconThemeData(color: primary), // cyan icons by default

    cardTheme: const CardThemeData(
      color: secondary, // #1E293B card background
      elevation: 0,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith(
        (s) => s.contains(MaterialState.selected) ? primary : Colors.white54,
      ),
      trackColor: MaterialStateProperty.resolveWith(
        (s) => s.contains(MaterialState.selected)
            ? primary.withOpacity(0.5)
            : Colors.white24,
      ),
    ),

    dividerColor: const Color(0xFF334155),
    cardColor: secondary,
  );
}
