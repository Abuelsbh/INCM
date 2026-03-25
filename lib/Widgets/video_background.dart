import 'package:flutter/material.dart';

import 'video_background_stub.dart'
    if (dart.library.html) 'video_background_web.dart' as vb;

/// يعرض الفيديو: على الويب مع Google Drive يستخدم iframe، وإلا video_player
Widget buildVideoBackground({
  required String url,
  required Widget fallback,
}) =>
    vb.buildVideoBackground(url: url, fallback: fallback);
