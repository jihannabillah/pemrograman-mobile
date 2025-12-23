import 'package:flutter/material.dart';
import '../../constants.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String? subtitle;
  final VoidCallback? onRetry;
  final IconData icon;

  const CustomErrorWidget({
    Key? key,
    required this.message,
    this.subtitle,
    this.onRetry,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: AppColors.error,
            ),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text('Try Again'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NetworkErrorWidget({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomErrorWidget(
      icon: Icons.wifi_off,
      message: 'No Internet Connection',
      subtitle: 'Please check your internet connection and try again.',
      onRetry: onRetry,
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData icon;

  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.subtitle,
    this.icon = Icons.search_off,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: AppColors.textHint,
            ),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}