import 'package:flutter/material.dart';

// ==============================
// API CONSTANTS
// ==============================
class ApiConstants {
  // API PUBLIK SEDERHANA & PASTI WORK
  static const String countriesApi = 'https://restcountries.com/v3.1/region/asia';
  
  // Backup API jika utama error
  static const String backupApi = 
      'https://gist.githubusercontent.com/jihan-assist/abc123/raw/heritage.json';
}

// ==============================
// APP CONSTANTS
// ==============================
class AppConstants {
  static const String appName = 'CultureExplorer';
  static const String appVersion = '1.0.0';
}

// ==============================
// COLOR CONSTANTS (AESTHETIC)
// ==============================
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2D5A27);    // Hijau Elegant
  static const Color primaryLight = Color(0xFF4A7C42);
  static const Color primaryDark = Color(0xFF1E3D1B);
  
  // Accent Colors
  static const Color accent = Color(0xFFD4AF37);     // Emas
  static const Color accentLight = Color(0xFFE8C766);
  
  // Neutral Colors
  static const Color background = Color(0xFFF9F7F3);  // Cream Soft
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFF5F1EA);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textHint = Color(0xFFBDC3C7);
  
  // Status Colors
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);
}

// ==============================
// TEXT STYLES
// ==============================
class TextStyles {
  // Headers
  static TextStyle h1(BuildContext context) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      fontFamily: 'Poppins',
    );
  }
  
  static TextStyle h2(BuildContext context) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      fontFamily: 'Poppins',
    );
  }
  
  // Body
  static TextStyle bodyLarge(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: AppColors.textSecondary,
      fontFamily: 'Inter',
    );
  }
  
  static TextStyle bodySmall(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      color: AppColors.textSecondary,
      fontFamily: 'Inter',
    );
  }
  
  // Caption
  static TextStyle caption(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      color: AppColors.textHint,
      fontFamily: 'Inter',
    );
  }
}