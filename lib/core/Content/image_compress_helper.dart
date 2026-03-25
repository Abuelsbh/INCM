import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Firestore limit for a single field is 1,048,487 bytes. We stay under it.
const int kMaxImageBase64Bytes = 1000000;

/// Compresses [base64] image if it exceeds [maxBytes].
/// Runs compression in a separate isolate to avoid blocking the UI.
Future<String> compressBase64ImageIfNeeded(
  String? base64, {
  int maxBytes = kMaxImageBase64Bytes,
}) async {
  if (base64 == null || base64.trim().isEmpty) return base64 ?? '';

  String normalized = base64.trim();
  if (normalized.contains(',')) {
    normalized = normalized.split(',').last.trim();
  }

  if (normalized.length <= maxBytes) return base64;

  return compute(_compressBase64ImageIsolate, <Object>[normalized, maxBytes]);
}

String _compressBase64ImageIsolate(List<Object> args) {
  final normalized = args[0] as String;
  final maxBytes = args[1] as int;
  try {
    final decoded = base64Decode(normalized);
    img.Image? image = img.decodeImage(decoded);
    if (image == null) return normalized;
    const int maxSide = 1200;
    if (image.width > maxSide || image.height > maxSide) {
      if (image.width > image.height) {
        image = img.copyResize(image, width: maxSide);
      } else {
        image = img.copyResize(image, height: maxSide);
      }
    }
    int quality = 85;
    var jpegBytes = img.encodeJpg(image, quality: quality);
    if (jpegBytes == null || jpegBytes.isEmpty) return normalized;
    while (jpegBytes.length > maxBytes && quality > 20) {
      quality -= 15;
      jpegBytes = img.encodeJpg(image, quality: quality) ?? jpegBytes;
    }
    if (jpegBytes.length > maxBytes) {
      image = img.copyResize(
        image,
        width: (image.width * 0.7).round(),
        height: (image.height * 0.7).round(),
      );
      jpegBytes = img.encodeJpg(image, quality: 75) ?? jpegBytes;
    }
    return base64Encode(jpegBytes);
  } catch (_) {
    return normalized;
  }
}
