import 'package:flutter/material.dart';
import '../../constants.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;

  const CustomLoadingIndicator({
    Key? key,
    this.message,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          if (message != null) ...[
            SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      ),
    );
  }
}