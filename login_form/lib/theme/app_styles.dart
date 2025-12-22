import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
  
  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    color: AppColors.primary,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
  );
  
  static const BoxShadow cardShadow = BoxShadow(
    color: AppColors.shadow,
    blurRadius: 20,
    offset: Offset(0, 8),
  );
  
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius textFieldRadius = BorderRadius.all(Radius.circular(12));
}