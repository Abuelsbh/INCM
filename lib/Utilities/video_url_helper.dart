/// Returns true if the URL is a direct video URL (e.g. .mp4) that works
/// on all browsers including Safari. Prefer these over Google Drive for Safari.
bool isDirectVideoUrl(String? url) {
  if (url == null || url.trim().isEmpty) return false;
  final u = url.trim().toLowerCase();
  return u.endsWith('.mp4') ||
      u.endsWith('.webm') ||
      u.contains('.mp4?') ||
      u.contains('vidplay.io') ||
      u.contains('image2url.com') ||
      u.contains('cloudinary.com') ||
      u.contains('b-cdn.net') ||
      u.contains('bunny.net');
}

/// Converts shared/view links (e.g. Google Drive, Dropbox) to direct video URLs
/// so video_player can load them.
String? toDirectVideoUrl(String? link) {
  if (link == null || link.trim().isEmpty) return null;
  final trimmed = link.trim();

  // Google Drive: /file/d/FILE_ID/view or /open?id=FILE_ID
  if (trimmed.contains('drive.google.com')) {
    String? fileId;
    final dMatch = RegExp(r'/file/d/([a-zA-Z0-9_-]+)').firstMatch(trimmed);
    if (dMatch != null) {
      fileId = dMatch.group(1);
    }
    if (fileId == null) {
      final idMatch = RegExp(r'[?&]id=([a-zA-Z0-9_-]+)').firstMatch(trimmed);
      if (idMatch != null) fileId = idMatch.group(1);
    }
    if (fileId != null && fileId.isNotEmpty) {
      return 'https://drive.google.com/uc?export=download&id=$fileId';
    }
  }

  // Dropbox: fix common typos (sci->scl, rikey->rlkey) then force direct download (dl=1)
  if (trimmed.contains('dropbox.com')) {
    String normalized = trimmed
        .replaceFirst(RegExp(r'/sci/'), '/scl/')
        .replaceAll('rikey=', 'rlkey=');
    try {
      final uri = Uri.parse(normalized);
      final params = Map<String, String>.from(uri.queryParameters);
      params['dl'] = '1';
      final direct = uri.replace(queryParameters: params);
      return direct.toString();
    } catch (_) {
      if (normalized.contains('dl=0')) {
        return normalized.replaceFirst('dl=0', 'dl=1');
      }
      return normalized.contains('?') ? '$normalized&dl=1' : '$normalized?dl=1';
    }
  }

  return trimmed;
}
