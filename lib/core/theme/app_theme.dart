import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.secondary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      surfaceContainerHighest: Color(0xFFECEDF2),
      error: AppColors.error,
      onError: Colors.white,
    ),
    textTheme: AppTextTheme.textTheme(
      primary: AppColors.lightTextPrimary,
      secondary: AppColors.lightTextSecondary,
    ),
    elevatedButtonTheme: _elevatedButtonTheme(
      background: AppColors.secondary,
      foreground: Colors.white,
    ),
    inputDecorationTheme: _inputDecorationTheme(
      fillColor: const Color(0xFFECEDF2),
      hintColor: AppColors.lightTextSecondary,
      focusColor: AppColors.secondary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.secondary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: Color(0xFF22233A),
      error: AppColors.error,
      onError: Colors.white,
    ),
    textTheme: AppTextTheme.textTheme(
      primary: AppColors.darkTextPrimary,
      secondary: AppColors.darkTextSecondary,
    ),
    elevatedButtonTheme: _elevatedButtonTheme(
      background: AppColors.secondary,
      foreground: Colors.white,
    ),
    inputDecorationTheme: _inputDecorationTheme(
      fillColor: const Color(0xFF22233A),
      hintColor: AppColors.darkTextSecondary,
      focusColor: AppColors.secondary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );

  static ElevatedButtonThemeData _elevatedButtonTheme({
    required Color background,
    required Color foreground,
  }) => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: background,
      foregroundColor: foreground,
      disabledBackgroundColor: background.withValues(alpha: 0.5),
      disabledForegroundColor: foreground.withValues(alpha: 0.7),
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0,
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    ),
  );

  static InputDecorationTheme _inputDecorationTheme({
    required Color fillColor,
    required Color hintColor,
    required Color focusColor,
  }) => InputDecorationTheme(
    filled: true,
    fillColor: fillColor,
    hintStyle: TextStyle(
      color: hintColor.withValues(alpha: 0.5),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: focusColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    errorStyle: const TextStyle(
      color: AppColors.error,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );
}
