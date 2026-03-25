import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

/// يعرض فيديو Google Drive عبر iframe على الويب (يعمل بشكل موثوق)
class GoogleDriveVideoWeb extends StatefulWidget {
  final String url;
  final BoxFit fit;

  const GoogleDriveVideoWeb({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
  });

  @override
  State<GoogleDriveVideoWeb> createState() => _GoogleDriveVideoWebState();
}

class _GoogleDriveVideoWebState extends State<GoogleDriveVideoWeb> {
  static int _viewCounter = 0;
  late String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'gdrive-video-${DateTime.now().millisecondsSinceEpoch}-${_viewCounter++}';
    _registerView();
  }

  void _registerView() {
    final fileId = _extractFileId(widget.url);
    if (fileId == null || fileId.isEmpty) return;

    // autoplay=1&mute=1 مطلوب للتشغيل التلقائي؛ Safari يتطلب سمات allow مناسبة
    final embedUrl = 'https://drive.google.com/file/d/$fileId/preview?autoplay=1&mute=1';
    ui.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = embedUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.position = 'absolute'
          ..style.top = '0'
          ..style.left = '0'
          ..style.pointerEvents = 'none'
          ..attributes['allow'] = 'autoplay; encrypted-media; fullscreen'
          ..attributes['allowfullscreen'] = 'true'
          ..attributes['loading'] = 'eager'
          ..allowFullscreen = true;
        // قد يساعد Safari في بعض الحالات (خصوصاً مع منع التتبع)
        try {
          iframe.referrerPolicy = 'no-referrer';
        } catch (_) {}
        return iframe;
      },
    );
  }

  String? _extractFileId(String url) {
    final match = RegExp(r'drive\.google\.com/file/d/([a-zA-Z0-9_-]+)').firstMatch(url);
    if (match != null) return match.group(1);
    final match2 = RegExp(r'drive\.google\.com/open\?id=([a-zA-Z0-9_-]+)').firstMatch(url);
    if (match2 != null) return match2.group(1);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final fileId = _extractFileId(widget.url);
    if (fileId == null || fileId.isEmpty) {
      return Container(color: Colors.black);
    }

    return SizedBox.expand(
      child: HtmlElementView(viewType: _viewType),
    );
  }
}
