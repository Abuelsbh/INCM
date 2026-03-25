import 'package:flutter/material.dart';

import '../Utilities/video_url_helper.dart';
import 'direct_video_web.dart';
import 'google_drive_video_web.dart';

/// على الويب: رابط مباشر (.mp4) → HTML5 video (أفضل مع Safari)
/// Google Drive → iframe
/// غير ذلك → fallback
Widget buildVideoBackground({
  required String url,
  required Widget fallback,
}) {
  if (url.trim().isEmpty) return fallback;
  // الروابط المباشرة أفضل مع Safari — استخدم عنصر فيديو HTML5
  if (isDirectVideoUrl(url)) {
    final directUrl = toDirectVideoUrl(url) ?? url.trim();
    return DirectVideoWeb(url: directUrl);
  }
  if (url.contains('drive.google.com')) {
    return GoogleDriveVideoWeb(url: url);
  }
  return fallback;
}
