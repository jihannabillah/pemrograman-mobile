import 'package:flutter/material.dart';
import '../constants.dart';

class Helpers {
  // Format large numbers
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // Get color based on category
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cultural':
        return AppColors.primary;
      case 'natural':
        return AppColors.success;
      case 'mixed':
        return AppColors.accent;
      default:
        return AppColors.textSecondary;
    }
  }

  // Get icon based on category
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cultural':
        return Icons.account_balance;
      case 'natural':
        return Icons.landscape;
      case 'mixed':
        return Icons.auto_awesome;
      default:
        return Icons.help;
    }
  }

  // Show success snackbar
  static void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Show error snackbar
  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Show confirmation dialog
  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmText,
              style: TextStyle(
                color: isDestructive ? AppColors.error : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Calculate days until date
  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    return difference.inDays;
  }

  // Get status text color
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return AppColors.info;
      case 'visited':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  // Validate email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Validate URL
  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (_) {
      return false;
    }
  }

  // Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}