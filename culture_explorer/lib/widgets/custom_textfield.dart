import 'package:flutter/material.dart';
import '../constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onSuffixTap;
  final bool enabled;
  final bool isRequired;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.onSuffixTap,
    this.enabled = true,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: maxLines,
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.textHint),
              filled: true,
              fillColor: enabled ? AppColors.surface : AppColors.background,
              prefixIcon: prefixIcon != null
                  ? Icon(
                      prefixIcon,
                      color: AppColors.primary,
                    )
                  : null,
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Icon(
                        suffixIcon,
                        color: AppColors.textSecondary,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.textHint),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.textHint),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.error, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: maxLines == 1 ? 0 : 16,
              ),
            ),
            style: TextStyle(
              fontSize: 16,
              color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            validator: validator ??
                (isRequired
                    ? (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter $labelText';
                        }
                        return null;
                      }
                    : null),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}