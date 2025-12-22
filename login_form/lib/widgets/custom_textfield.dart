import 'package:flutter/material.dart';
import '../theme/app_styles.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final bool autofocus;
  
  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.hintText = '',
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.focusNode,
    this.onFieldSubmitted,
    this.autofocus = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.bodySmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: AppStyles.textFieldRadius,
            boxShadow: [AppStyles.cardShadow],
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            keyboardType: keyboardType,
            autofocus: autofocus,
            onFieldSubmitted: onFieldSubmitted,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: AppStyles.textFieldRadius,
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppStyles.textFieldRadius,
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppStyles.textFieldRadius,
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: AppStyles.textFieldRadius,
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: AppStyles.textFieldRadius,
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: suffixIcon,
              errorStyle: const TextStyle(
                fontSize: 12,
                color: AppColors.error,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }
}