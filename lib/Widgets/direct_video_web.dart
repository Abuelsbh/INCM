import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

/// يعرض فيديو عبر عنصر HTML5 <video> مباشر — أفضل توافق مع Safari وجميع المتصفحات
/// استخدم روابط مباشرة (.mp4) من استضافة مجانية مثل VidPlay أو Image2URL
class DirectVideoWeb extends StatefulWidget {
  final String url;
  final BoxFit fit;

  const DirectVideoWeb({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
  });

  @override
  State<DirectVideoWeb> createState() => _DirectVideoWebState();
}

class _DirectVideoWebState extends State<DirectVideoWeb> {
  static int _viewCounter = 0;
  late String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType =
        'direct-video-${DateTime.now().millisecondsSinceEpoch}-${_viewCounter++}';
    _registerView();
  }

  void _registerView() {
    ui.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final video = html.VideoElement()
          ..src = widget.url
          ..autoplay = true
          ..loop = true
          ..muted = true
          ..controls = false
          ..setAttribute('playsinline', 'true');
        video.style.setProperty('object-fit', 'cover');
        video.style.setProperty('pointer-events', 'none');
        video.style.setProperty('width', '100%');
        video.style.setProperty('height', '100%');
        video.style.setProperty('position', 'absolute');
        video.style.setProperty('top', '0');
        video.style.setProperty('left', '0');
        video.play().catchError((_) {});
        return video;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
