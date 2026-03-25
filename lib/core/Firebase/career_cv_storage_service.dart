import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Uploads career CV bytes to Storage; returns a download URL for email / Firestore text.
class CareerCvStorageService {
  CareerCvStorageService._();

  static bool get _firebaseReady {
    try {
      Firebase.app();
      return true;
    } catch (_) {
      return false;
    }
  }

  static String _contentType(String fileName) {
    final n = fileName.toLowerCase();
    if (n.endsWith('.pdf')) return 'application/pdf';
    if (n.endsWith('.doc')) return 'application/msword';
    if (n.endsWith('.docx')) {
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    }
    if (n.endsWith('.png')) return 'image/png';
    if (n.endsWith('.jpg') || n.endsWith('.jpeg')) return 'image/jpeg';
    return 'application/octet-stream';
  }

  /// Max ~15 MB enforced in Storage rules; keep client-side sanity check.
  static const int _maxBytes = 15 * 1024 * 1024;

  static Future<String?> uploadCv({
    required Uint8List bytes,
    required String originalFileName,
    required String applicantEmail,
  }) async {
    if (!_firebaseReady || bytes.isEmpty) return null;
    if (bytes.length > _maxBytes) return null;

    final safe = originalFileName.replaceAll(RegExp(r'[^\w.\-]+'), '_');
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final tag = applicantEmail.hashCode.abs();
    final path = 'career_cvs/${stamp}_${tag}_$safe';

    try {
      final ref = FirebaseStorage.instance.ref(path);
      await ref.putData(
        bytes,
        SettableMetadata(contentType: _contentType(originalFileName)),
      );
      return ref.getDownloadURL();
    } catch (_) {
      return null;
    }
  }
}
