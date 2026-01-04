import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFEDF5FF);
  static const Color text = Color(0xFF001141);
  static const Color primary = Color(0xFF0F67FE);
  
  static const Color statusLow = Colors.pinkAccent; // "Pink"
  static const Color statusNormal = Colors.green; // "Green"
  static const Color statusHigh = Colors.orange; // "Orange/Red" - using Orange for "Slightly High" usually, but user said High: Orange/Red.
  static const Color statusVeryHigh = Colors.red;

  static const Color surface = Colors.white;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        surface: AppColors.background,
        primary: AppColors.primary,
        onSurface: AppColors.text,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.text),
        bodyMedium: TextStyle(color: AppColors.text),
        titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      useMaterial3: true,
    );
  }
}
