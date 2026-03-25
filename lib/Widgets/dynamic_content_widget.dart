import 'package:flutter/material.dart';
import '../core/Content/content_helper.dart';
import '../core/Language/locales.dart';

/// Widget to display text content from Firebase with fallback
class DynamicText extends StatefulWidget {
  final String pageId;
  final String sectionId;
  final String defaultValue;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final int? maxLines;
  final TextOverflow? overflow;

  const DynamicText({
    super.key,
    required this.pageId,
    required this.sectionId,
    required this.defaultValue,
    this.style,
    this.textAlign,
    this.textDirection,
    this.maxLines,
    this.overflow,
  });

  @override
  State<DynamicText> createState() => _DynamicTextState();
}

class _DynamicTextState extends State<DynamicText> {
  late Future<String> _textFuture;

  @override
  void initState() {
    super.initState();
    _textFuture = _loadText();
  }

  @override
  void didUpdateWidget(covariant DynamicText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageId != widget.pageId ||
        oldWidget.sectionId != widget.sectionId ||
        oldWidget.defaultValue != widget.defaultValue) {
      _textFuture = _loadText();
    }
  }

  Future<String> _loadText() {
    return ContentHelper.getText(
      context,
      widget.pageId,
      widget.sectionId,
      defaultValue: widget.defaultValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    return FutureBuilder<String>(
      future: _textFuture,
      builder: (context, snapshot) {
        String text = snapshot.data ?? widget.defaultValue;

        if (text == widget.defaultValue &&
            widget.defaultValue.contains('_') &&
            widget.defaultValue == widget.defaultValue.toUpperCase()) {
          text = widget.defaultValue.tr(context);
        }

        // Convert literal \n (from i18n/Firebase) to actual newlines for display
        text = text.replaceAll(r'\n', '\n');

        return Text(
          text,
          style: widget.style,
          maxLines: widget.maxLines,
          overflow: widget.overflow,

          textDirection: widget.textDirection ??
              (isArabic ? TextDirection.rtl : TextDirection.ltr),
          textAlign:
              widget.textAlign ?? (isArabic ? TextAlign.right : TextAlign.left),
        );
      },
    );
  }
}

/// Widget to display image from Firebase with fallback
class DynamicImage extends StatefulWidget {
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
  State<DynamicImage> createState() => _DynamicImageState();
}

class _DynamicImageState extends State<DynamicImage> {
  late Future<Widget> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadImage();
  }

  @override
  void didUpdateWidget(covariant DynamicImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageId != widget.pageId ||
        oldWidget.sectionId != widget.sectionId ||
        oldWidget.fallbackAssetPath != widget.fallbackAssetPath ||
        oldWidget.width != widget.width ||
        oldWidget.height != widget.height ||
        oldWidget.fit != widget.fit) {
      _imageFuture = _loadImage();
    }
  }

  Future<Widget> _loadImage() {
    return ContentHelper.getImage(
      context,
      widget.pageId,
      widget.sectionId,
      fallbackAssetPath: widget.fallbackAssetPath,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }
        if (widget.fallbackAssetPath != null) {
          return Image.asset(
            widget.fallbackAssetPath!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            cacheWidth: widget.width?.toInt(),
            cacheHeight: widget.height?.toInt(),
            filterQuality: FilterQuality.medium,
          );
        }
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

/// Widget to display container with background image from Firebase
class DynamicBackgroundContainer extends StatefulWidget {
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
  State<DynamicBackgroundContainer> createState() =>
      _DynamicBackgroundContainerState();
}

class _DynamicBackgroundContainerState extends State<DynamicBackgroundContainer> {
  late Future<DecorationImage?> _decorationFuture;

  @override
  void initState() {
    super.initState();
    _decorationFuture = _loadDecoration();
  }

  @override
  void didUpdateWidget(covariant DynamicBackgroundContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageId != widget.pageId ||
        oldWidget.sectionId != widget.sectionId ||
        oldWidget.fallbackAssetPath != widget.fallbackAssetPath ||
        oldWidget.fit != widget.fit) {
      _decorationFuture = _loadDecoration();
    }
  }

  Future<DecorationImage?> _loadDecoration() {
    return ContentHelper.getDecorationImage(
      context,
      widget.pageId,
      widget.sectionId,
      fit: widget.fit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DecorationImage?>(
      future: _decorationFuture,
      builder: (context, snapshot) {
        DecorationImage? decorationImage = snapshot.data;

        if (decorationImage == null && widget.fallbackAssetPath != null) {
          decorationImage = DecorationImage(
            image: AssetImage(widget.fallbackAssetPath!),
            fit: widget.fit,
          );
        }

        return Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: widget.color,
            image: decorationImage,
          ),
          child: widget.child,
        );
      },
    );
  }
}












