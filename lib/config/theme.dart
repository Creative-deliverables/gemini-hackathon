import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFF0D1117);
  static const surface = Color(0xFF161B22);
  static const card = Color(0xFF1C2333);
  static const primary = Color(0xFF3B82F6);
  static const primaryLight = Color(0xFF60A5FA);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8B949E);
  static const textMuted = Color(0xFF6E7681);
  static const border = Color(0xFF30363D);
  static const error = Color(0xFFEF4444);
  static const success = Color(0xFF22C55E);
}

ThemeData buildDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.textMuted),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primary.withAlpha(51),
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: const TextStyle(color: AppColors.textPrimary),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
    ),
    textTheme: GoogleFonts.notoSansKrTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(color: AppColors.textPrimary),
        titleMedium: TextStyle(color: AppColors.textPrimary),
        titleSmall: TextStyle(color: AppColors.textSecondary),
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textPrimary),
        bodySmall: TextStyle(color: AppColors.textSecondary),
        labelLarge: TextStyle(color: AppColors.textPrimary),
        labelMedium: TextStyle(color: AppColors.textSecondary),
        labelSmall: TextStyle(color: AppColors.textMuted),
      ),
    ),
  );
}
