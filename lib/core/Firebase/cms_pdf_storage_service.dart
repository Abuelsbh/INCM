import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart' show Firebase, FirebaseException;
import 'package:firebase_storage/firebase_storage.dart';

/// Result of a CMS PDF upload (user-facing [errorMessage] when [url] is null).
class CmsPdfUploadResult {
  const CmsPdfUploadResult._(this.url, this.errorMessage);

  final String? url;
  final String? errorMessage;

  factory CmsPdfUploadResult.ok(String url) => CmsPdfUploadResult._(url, null);

  factory CmsPdfUploadResult.fail(String errorMessage) =>
      CmsPdfUploadResult._(null, errorMessage);
}

/// Uploads PDFs for franchise brochure & company profile; returns download URLs for [ContentHelper.getLink].
class CmsPdfStorageService {
  CmsPdfStorageService._();

  static bool get _firebaseReady {
    try {
      Firebase.app();
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<CmsPdfUploadResult> uploadFranchiseBrochurePdf({
    required Uint8List bytes,
    required String originalFileName,
  }) {
    final safe = originalFileName.replaceAll(RegExp(r'[^\w.\-]+'), '_');
    final stamp = DateTime.now().millisecondsSinceEpoch;
    return _uploadPdf(
      bytes: bytes,
      originalFileName: originalFileName,
      storagePath: 'franchise_brochure/brochure_${stamp}_$safe',
      rulesPathHint: 'franchise_brochure',
    );
  }

  static Future<CmsPdfUploadResult> uploadCompanyProfilePdf({
    required Uint8List bytes,
    required String originalFileName,
  }) {
    final safe = originalFileName.replaceAll(RegExp(r'[^\w.\-]+'), '_');
    final stamp = DateTime.now().millisecondsSinceEpoch;
    return _uploadPdf(
      bytes: bytes,
      originalFileName: originalFileName,
      storagePath: 'company_profile/profile_${stamp}_$safe',
      rulesPathHint: 'company_profile',
    );
  }

  static Future<CmsPdfUploadResult> _uploadPdf({
    required Uint8List bytes,
    required String originalFileName,
    required String storagePath,
    required String rulesPathHint,
  }) async {
    if (!_firebaseReady || bytes.isEmpty) {
      return CmsPdfUploadResult.fail('Firebase غير جاهز أو الملف فارغ');
    }

    final n = originalFileName.toLowerCase();
    if (!n.endsWith('.pdf')) {
      return CmsPdfUploadResult.fail('امتداد الملف ليس ‎.pdf');
    }

    try {
      final ref = FirebaseStorage.instance.ref(storagePath);
      await ref.putData(bytes, SettableMetadata(contentType: 'application/pdf'));
      final url = await ref.getDownloadURL();
      if (url.isEmpty) {
        return CmsPdfUploadResult.fail('لم يُرجع رابط التحميل');
      }
      return CmsPdfUploadResult.ok(url);
    } on FirebaseException catch (e) {
      final code = e.code;
      var msg = e.message ?? e.toString();
      if (code == 'unauthorized' || code == 'storage/unauthorized') {
        msg =
            'Storage رفض الرفع. غالباً لم تُنشر قواعد المسار $rulesPathHint. نفّذ: firebase deploy --only storage'
            '\n(تفاصيل: $msg)';
      } else if (code == 'canceled' || code == 'storage/canceled') {
        msg = 'تم إلغاء الرفع. $msg';
      }
      return CmsPdfUploadResult.fail('[$code] $msg');
    } catch (e) {
      return CmsPdfUploadResult.fail(e.toString());
    }
  }
}
