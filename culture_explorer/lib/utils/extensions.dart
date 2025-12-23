import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {
  // Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  // Capitalize each word
  String capitalizeWords() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  // Check if string is numeric
  bool isNumeric() {
    return double.tryParse(this) != null;
  }

  // Truncate with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  // Remove all whitespace
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  // Format as currency
  String toCurrency({String symbol = '\$'}) {
    if (isNumeric()) {
      final formatter = NumberFormat.currency(
        symbol: symbol,
        decimalDigits: 0,
      );
      return formatter.format(double.parse(this));
    }
    return this;
  }
}

extension DateTimeExtensions on DateTime {
  // Format date to string
  String format({String pattern = 'dd MMM yyyy'}) {
    return DateFormat(pattern).format(this);
  }

  // Check if date is today
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Check if date is tomorrow
  bool isTomorrow() {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    return year == tomorrow.year && 
           month == tomorrow.month && 
           day == tomorrow.day;
  }

  // Check if date is yesterday
  bool isYesterday() {
    final yesterday = DateTime.now().subtract(Duration(days: 1));
    return year == yesterday.year && 
           month == yesterday.month && 
           day == yesterday.day;
  }

  // Get relative time (e.g., "2 days ago", "in 3 weeks")
  String toRelativeTime() {
    final now = DateTime.now();
    final difference = this.difference(now);

    if (difference.inDays.abs() > 365) {
      final years = (difference.inDays.abs() / 365).floor();
      return difference.isNegative
          ? '$years year${years == 1 ? '' : 's'} ago'
          : 'in $years year${years == 1 ? '' : 's'}';
    } else if (difference.inDays.abs() > 30) {
      final months = (difference.inDays.abs() / 30).floor();
      return difference.isNegative
          ? '$months month${months == 1 ? '' : 's'} ago'
          : 'in $months month${months == 1 ? '' : 's'}';
    } else if (difference.inDays.abs() > 0) {
      final days = difference.inDays.abs();
      return difference.isNegative
          ? '$days day${days == 1 ? '' : 's'} ago'
          : 'in $days day${days == 1 ? '' : 's'}';
    } else if (difference.inHours.abs() > 0) {
      final hours = difference.inHours.abs();
      return difference.isNegative
          ? '$hours hour${hours == 1 ? '' : 's'} ago'
          : 'in $hours hour${hours == 1 ? '' : 's'}';
    } else if (difference.inMinutes.abs() > 0) {
      final minutes = difference.inMinutes.abs();
      return difference.isNegative
          ? '$minutes minute${minutes == 1 ? '' : 's'} ago'
          : 'in $minutes minute${minutes == 1 ? '' : 's'}';
    } else {
      return 'just now';
    }
  }
}

extension BuildContextExtensions on BuildContext {
  // Get screen size
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  // Check if device is in dark mode
  bool get isDarkMode => MediaQuery.of(this).platformBrightness == Brightness.dark;

  // Show snackbar
  void showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Navigate with fade transition
  Future<T?> fadeNavigateTo<T>(Widget page) {
    return Navigator.push<T>(
      this,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }
}

extension ListExtensions<T> on List<T> {
  // Safe element access
  T? getOrNull(int index) {
    return index >= 0 && index < length ? this[index] : null;
  }

  // Split list into chunks
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      final end = i + size > length ? length : i + size;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }

  // Remove duplicates by key
  List<T> removeDuplicatesByKey<K>(K Function(T) keySelector) {
    final seen = <K>{};
    return where((item) => seen.add(keySelector(item))).toList();
  }
}