import 'package:flutter/material.dart';
import '../core/Content/content_helper.dart';
import '../core/Language/locales.dart';

/// Widget to display text content from Firebase with fallback
class DynamicText extends StatelessWidget {
  final String pageId;
  final String sectionId;
  final String defaultValue;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const DynamicText({
    super.key,
    required this.pageId,
    required this.sectionId,
    required this.defaultValue,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: ContentHelper.getText(
        context,
        pageId,
        sectionId,
        defaultValue: defaultValue,
      ),
      builder: (context, snapshot) {
        String text = snapshot.data ?? defaultValue;
        // If no text from Firebase and defaultValue looks like a translation key (contains _ and is uppercase),
        // use translation system
        if (text == defaultValue && defaultValue.contains('_') && defaultValue == defaultValue.toUpperCase()) {
          text = defaultValue.tr(context);
        }
        return Text(
          text,
          style: style,
          textAlign: textAlign,
          textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}

/// Widget to display image from Firebase with fallback
class DynamicImage extends StatelessWidget {
  final String pageId;
  final String sectionId;
  final String? fallbackAssetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const DynamicImage({
    super.key,
    required this.pageId,
    required this.sectionId,
    this.fallbackAssetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: ContentHelper.getImage(
        context,
        pageId,
        sectionId,
        fallbackAssetPath: fallbackAssetPath,
        width: width,
        height: height,
        fit: fit,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }
        // Fallback while loading
        if (fallbackAssetPath != null) {
          return Image.asset(
            fallbackAssetPath!,
            width: width,
            height: height,
            fit: fit,
          );
        }
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

/// Widget to display container with background image from Firebase
class DynamicBackgroundContainer extends StatelessWidget {
  final String pageId;
  final String sectionId;
  final String? fallbackAssetPath;
  final Widget child;
  final BoxFit fit;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const DynamicBackgroundContainer({
    super.key,
    required this.pageId,
    required this.sectionId,
    this.fallbackAssetPath,
    required this.child,
    this.fit = BoxFit.cover,
    this.color,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DecorationImage?>(
      future: ContentHelper.getDecorationImage(
        context,
        pageId,
        sectionId,
        fit: fit,
      ),
      builder: (context, snapshot) {
        DecorationImage? decorationImage = snapshot.data;
        
        // Fallback to asset if Firebase image not available
        if (decorationImage == null && fallbackAssetPath != null) {
          decorationImage = DecorationImage(
            image: AssetImage(fallbackAssetPath!),
            fit: fit,
          );
        }

        return Container(
          width: width,
          height: height,
          padding: padding,
          margin: margin,
          decoration: BoxDecoration(
            color: color,
            image: decorationImage,
          ),
          child: child,
        );
      },
    );
  }
}












