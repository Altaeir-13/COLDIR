import 'package:flutter/material.dart';

class AppTheme {
  static const _seedColor = Color(0xFF0E564D);
  static const _fontFamily = 'Roboto';

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );
    final textTheme = _textTheme(colorScheme);

    return base.copyWith(
      colorScheme: colorScheme,
      textTheme: textTheme,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: textTheme.bodyMedium,
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final baseScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );
    final colorScheme = baseScheme.copyWith(surface: const Color(0xFF15171B));
    final textTheme = _textTheme(colorScheme);

    return base.copyWith(
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: const Color(0xFF0E0F12),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF15171B),
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      cardColor: const Color(0xFF1C1E23),
      dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF15171B)),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1C1E23),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF15171B),
        selectedItemColor: const Color(0xFF4DD0E1),
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelMedium,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF0E564D),
        foregroundColor: Colors.white,
      ),
    );
  }

  static TextTheme _textTheme(ColorScheme colorScheme) {
    const base = TextTheme(
      headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.2),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.1),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.05),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.4),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4),
      bodySmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, height: 1.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.1),
    );

    return base.apply(
      fontFamily: _fontFamily,
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
  }
}
