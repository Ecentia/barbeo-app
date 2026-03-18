import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const black = Color(0xFF0A0A0A);
  static const white = Color(0xFFFFFFFF);
  static const offWhite = Color(0xFFF7F7F7);
  static const greyLight = Color(0xFFF0F0F0);
  static const greyMid = Color(0xFFD4D4D4);
  static const greyText = Color(0xFF8A8A8A);
  static const greySubtext = Color(0xFFB0B0B0);
  static const error = Color(0xFFE53935);
  static const success = Color(0xFF1B5E20);
  static const successLight = Color(0xFFE8F5E9);
  static const errorLight = Color(0xFFFFEBEE);
  static const accent = Color(0xFF0A0A0A);
}

class AppTextStyles {
  static const headline1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.black,
    height: 1.15,
    letterSpacing: -0.8,
  );

  static const headline2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    height: 1.2,
    letterSpacing: -0.4,
  );

  static const body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 1.5,
  );

  static const bodyMuted = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.greyText,
    height: 1.5,
  );

  static const label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    letterSpacing: 0.2,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.greyText,
  );

  static const buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: 0.3,
  );
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.white,
      primaryColor: AppColors.black,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      fontFamily: 'SF Pro Display',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: AppColors.black),
        titleTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.greyLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        hintStyle: const TextStyle(color: AppColors.greySubtext, fontSize: 15),
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
          borderSide: const BorderSide(color: AppColors.black, width: 1.5),
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
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}