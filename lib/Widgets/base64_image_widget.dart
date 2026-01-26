import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget to display images from base64 string
class Base64ImageWidget extends StatelessWidget {
  final String? base64String;
  final String? fallbackAssetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const Base64ImageWidget({
    super.key,
    this.base64String,
    this.fallbackAssetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (base64String == null || base64String!.isEmpty) {
      return _buildFallback();
    }

    try {
      String cleanBase64 = base64String!.trim();
      
      // Check if it's already a data URL and extract the base64 part
      if (cleanBase64.startsWith('data:image')) {
        final parts = cleanBase64.split(',');
        if (parts.length == 2) {
          cleanBase64 = parts[1].trim();
        }
      }
      
      // Remove any whitespace, newlines, etc.
      cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s'), '');
      
      if (cleanBase64.isEmpty) {
        return _buildFallback();
      }
      
      // Use Image.memory for both web and mobile - it's the most reliable approach
      return _buildMemoryImage(cleanBase64);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('Base64ImageWidget error: $e');
      }
      return _buildFallback();
    }
  }
  
  /// Build Image.memory widget (for mobile or as fallback)
  Widget _buildMemoryImage(String cleanBase64) {
    try {
      // Try to decode - if it fails, the catch block will handle it
      final bytes = base64Decode(cleanBase64);
      
      if (bytes.isEmpty) {
        return _buildFallback();
      }
      
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        filterQuality: FilterQuality.medium, // Medium quality for better performance
        errorBuilder: (context, error, stackTrace) {
          if (kDebugMode) {
            debugPrint('Base64ImageWidget: Image.memory failed: $error');
          }
          return _buildFallback();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Base64ImageWidget: Failed to decode base64: ${e.toString().substring(0, e.toString().length > 100 ? 100 : e.toString().length)}');
      }
      return _buildFallback();
    }
  }

  Widget _buildFallback() {
    if (fallbackAssetPath != null) {
      try {
        return Image.asset(
          fallbackAssetPath!,
          width: width,
          height: height,
          fit: fit,
          cacheWidth: width?.toInt(),
          cacheHeight: height?.toInt(),
          filterQuality: FilterQuality.medium, // Medium quality for better performance
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorIcon();
          },
        );
      } catch (e) {
        return _buildErrorIcon();
      }
    }
    return _buildErrorIcon();
  }

  Widget _buildErrorIcon() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(
        Icons.broken_image,
        color: Colors.grey[600],
        size: (width != null && height != null) 
            ? (width! < height! ? width! * 0.5 : height! * 0.5)
            : 48,
      ),
    );
  }
}

