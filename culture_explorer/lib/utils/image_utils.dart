import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageUtils {
  // Cached network image with error handling
  static Widget cachedImage(
    String imageUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius borderRadius = BorderRadius.zero,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
        errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(),
        fadeInDuration: Duration(milliseconds: 300),
        fadeOutDuration: Duration(milliseconds: 300),
      ),
    );
  }

  static Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  static Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.grey[400],
          size: 40,
        ),
      ),
    );
  }

  // Image with shimmer effect while loading
  static Widget shimmerImage(
    String imageUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[300]!, Colors.grey[200]!, Colors.grey[300]!],
              stops: [0.0, 0.5, 1.0],
              begin: Alignment(-1.0, -1.0),
              end: Alignment(1.0, 1.0),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey[400],
            size: 32,
          ),
        ),
      ),
    );
  }

  // Circle avatar with cached image
  static Widget circleAvatar(
    String imageUrl, {
    double radius = 20,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(imageUrl),
      backgroundColor: Colors.grey[200],
      child: imageUrl.isEmpty
          ? Icon(
              Icons.person,
              size: radius,
              color: Colors.grey[600],
            )
          : null,
    );
  }

  // Hero image with cached network image
  static Widget heroImage(
    String tag,
    String imageUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius borderRadius = BorderRadius.zero,
  }) {
    return Hero(
      tag: tag,
      child: cachedImage(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        borderRadius: borderRadius,
      ),
    );
  }

  // Check if image URL is valid
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.svg'];
    return imageExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }

  // Get placeholder color based on string hash
  static Color getPlaceholderColor(String text) {
    final hash = text.hashCode;
    final colors = [
      Colors.red[100]!,
      Colors.blue[100]!,
      Colors.green[100]!,
      Colors.yellow[100]!,
      Colors.purple[100]!,
      Colors.orange[100]!,
    ];
    return colors[hash.abs() % colors.length];
  }
}