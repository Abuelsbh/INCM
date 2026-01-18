import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'content_provider.dart';
import '../../Widgets/base64_image_widget.dart';
import '../../core/Language/app_languages.dart';

/// Helper class to easily get and display content from Firebase
class ContentHelper {
  /// Get text content for current language
  static Future<String> getText(
    BuildContext context,
    String pageId,
    String sectionId, {
    String defaultValue = '',
  }) async {
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final appLanguage = Provider.of<AppLanguage>(context, listen: false);
    final language = appLanguage.appLang.name; // 'en' or 'ar'
    
    return await contentProvider.getTextContent(
      pageId,
      sectionId,
      language,
      defaultValue: defaultValue,
    );
  }

  /// Get image widget from base64 or fallback asset
  static Future<Widget> getImage(
    BuildContext context,
    String pageId,
    String sectionId, {
    String? fallbackAssetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) async {
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final base64 = await contentProvider.getImageContent(pageId, sectionId);
    
    return Base64ImageWidget(
      base64String: base64,
      fallbackAssetPath: fallbackAssetPath,
      width: width,
      height: height,
      fit: fit,
    );
  }

  /// Get image as DecorationImage for Container decoration
  static Future<DecorationImage?> getDecorationImage(
    BuildContext context,
    String pageId,
    String sectionId, {
    BoxFit fit = BoxFit.cover,
  }) async {
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    final base64 = await contentProvider.getImageContent(pageId, sectionId);
    
    if (base64 != null && base64.isNotEmpty) {
      try {
        final bytes = base64Decode(base64);
        return DecorationImage(
          image: MemoryImage(bytes),
          fit: fit,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Get video content (returns base64 string or link URL)
  static Future<Map<String, String?>?> getVideo(
    BuildContext context,
    String pageId,
    String sectionId,
  ) async {
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    return await contentProvider.getVideoContent(pageId, sectionId);
  }
}

