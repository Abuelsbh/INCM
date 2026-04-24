import 'package:flutter/material.dart';

import '../core/Content/content_helper.dart';
import '../generated/assets.dart';

/// CMS: on each service page, section `home-carousel-image` (image).
class HomeServiceCarouselImage extends StatefulWidget {
  final String pageId;
  final BoxFit fit;

  const HomeServiceCarouselImage({
    super.key,
    required this.pageId,
    this.fit = BoxFit.cover,
  });

  @override
  State<HomeServiceCarouselImage> createState() => _HomeServiceCarouselImageState();
}

class _HomeServiceCarouselImageState extends State<HomeServiceCarouselImage> {
  Future<Widget>? _future;
  String? _loadedKey;

  void _ensureFuture() {
    final key = '${widget.pageId}\n${widget.fit}';
    if (_loadedKey == key && _future != null) return;
    _loadedKey = key;
    _future = ContentHelper.getImage(
      context,
      widget.pageId,
      'home-carousel-image',
      fallbackAssetPath: Assets.imagesLearnServices,
      fit: widget.fit,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureFuture();
  }

  @override
  void didUpdateWidget(covariant HomeServiceCarouselImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageId != widget.pageId || oldWidget.fit != widget.fit) {
      _loadedKey = null;
      _ensureFuture();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) return snapshot.data!;
        return Image.asset(Assets.imagesLearnServices, fit: widget.fit);
      },
    );
  }
}
