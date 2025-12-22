import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF4A44C6);
  static const Color accent = Color(0xFFFF6584);
  static const Color background = Color(0xFFF8F9FF);
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFEF5350);
  static const Color success = Color(0xFF4CAF50);
  static const Color textPrimary = Color(0xFF2D2B4E);
  static const Color textSecondary = Color(0xFF6E6C7E);
  static const Color border = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A6C63FF);
  
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF4A44C6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}