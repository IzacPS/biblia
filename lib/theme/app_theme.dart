import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cores do tema claro
  static const Color _lightPrimary = Color(0xFF8B4513); // Marrom bíblico
  static const Color _lightSecondary = Color(0xFFD4AF37); // Dourado
  static const Color _lightTertiary = Color(0xFF2F4F4F); // Verde escuro
  static const Color _lightSurface = Color(0xFFF5F5DC); // Bege claro
  static const Color _lightBackground = Color(0xFFFAF8F3); // Background suave
  static const Color _lightText = Color(0xFF2C1810); // Texto escuro

  // Cores do tema escuro
  static const Color _darkPrimary = Color(0xFFD4AF37); // Dourado (mais visível no escuro)
  static const Color _darkSecondary = Color(0xFF8B4513); // Marrom bíblico
  static const Color _darkTertiary = Color(0xFF66BB6A); // Verde claro
  static const Color _darkSurface = Color(0xFF2C2C2C); // Cinza escuro
  static const Color _darkBackground = Color(0xFF1A1A1A); // Background escuro
  static const Color _darkText = Color(0xFFE8E8E8); // Texto claro

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _lightPrimary,
        brightness: Brightness.light,
      ).copyWith(
        primary: _lightPrimary,
        secondary: _lightSecondary,
        tertiary: _lightTertiary,
        surface: _lightSurface,
        background: _lightBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _lightText,
        onBackground: _lightText,
      ),
      useMaterial3: true,
      fontFamily: GoogleFonts.ptSans().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: _lightSurface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightSecondary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      scaffoldBackgroundColor: _lightBackground,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _darkPrimary,
        brightness: Brightness.dark,
      ).copyWith(
        primary: _darkPrimary,
        secondary: _darkSecondary,
        tertiary: _darkTertiary,
        surface: _darkSurface,
        background: _darkBackground,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: _darkText,
        onBackground: _darkText,
      ),
      useMaterial3: true,
      fontFamily: GoogleFonts.ptSans().fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkPrimary,
        foregroundColor: Colors.black,
        elevation: 2,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: _darkSurface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      scaffoldBackgroundColor: _darkBackground,
    );
  }

  // Cores específicas para cards no tema claro
  static const List<Color> lightReadingGradient = [
    Color(0xFF8B4513),
    Color(0xFF6D4C41),
  ];

  static const List<Color> lightBookmarkGradient = [
    Color(0xFFD4AF37),
    Color(0xFFB8860B),
  ];

  static const List<Color> lightSavedGradient = [
    Color(0xFF2F4F4F),
    Color(0xFF556B2F),
  ];

  static const List<Color> lightSettingsGradient = [
    Color(0xFF6D4C41),
    Color(0xFF5D4037),
  ];

  // Cores específicas para cards no tema escuro
  static const List<Color> darkReadingGradient = [
    Color(0xFFD4AF37),
    Color(0xFFB8860B),
  ];

  static const List<Color> darkBookmarkGradient = [
    Color(0xFF8B4513),
    Color(0xFF6D4C41),
  ];

  static const List<Color> darkSavedGradient = [
    Color(0xFF66BB6A),
    Color(0xFF4CAF50),
  ];

  static const List<Color> darkSettingsGradient = [
    Color(0xFF9E9E9E),
    Color(0xFF757575),
  ];
}