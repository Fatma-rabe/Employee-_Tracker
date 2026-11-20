import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// باليتة درب: كريمي مسطح + فحمي غالبا هشيله  + وردي + زيتوني + أخضر رمادي
class AppColors {
  static const ink = Color(0xFF26231F);
  static const cream = Color(0xFFF4EEE2);
  static const paper = Color(0xFFFBF8F2);
  static const line = Color(0xFFE2D9C6);
  static const pink = Color(0xFFD6A9A3);
  static const pinkDark = Color(0xFFB27D77);
  static const olive = Color(0xFF7B7D45);
  static const sage = Color(0xFFB3C1AB);
  static const sageLight = Color(0xFFE0E7D9);
  static const mute = Color(0xFF80786C);
  static const error = Color(0xFF9B4B43);
}

ThemeData buildTheme() {
  final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
  final text = GoogleFonts.tajawalTextTheme(base.textTheme)
      .apply(bodyColor: AppColors.ink, displayColor: AppColors.ink);

  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c, width: w),
      );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: const ColorScheme.light(
      primary: AppColors.ink,
      onPrimary: AppColors.cream,
      secondary: AppColors.pink,
      onSecondary: AppColors.ink,
      surface: AppColors.paper,
      onSurface: AppColors.ink,
      error: AppColors.error,
    ),
    textTheme: text,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cream,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      labelStyle: const TextStyle(color: AppColors.mute),
      border: border(AppColors.line),
      enabledBorder: border(AppColors.line),
      focusedBorder: border(AppColors.olive, 1.5),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.cream,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.tajawal(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: AppColors.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.tajawal(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
  );
}
