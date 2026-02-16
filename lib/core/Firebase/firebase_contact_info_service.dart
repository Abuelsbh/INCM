import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../Models/contact_info_model.dart';

class FirebaseContactInfoService {
  static const String _docPath = 'app_settings/contact_info';

  bool get _isFirebaseInitialized {
    try {
      Firebase.app();
      return true;
    } catch (e) {
      return false;
    }
  }

  FirebaseFirestore? get _firestore {
    if (!_isFirebaseInitialized) return null;
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      return null;
    }
  }

  /// جلب معلومات الاتصال من Firebase
  Future<ContactInfoModel> getContactInfo() async {
    if (!_isFirebaseInitialized || _firestore == null) {
      return ContactInfoModel.defaults;
    }
    try {
      final doc = await _firestore!.doc(_docPath).get();
      if (doc.exists && doc.data() != null) {
        return ContactInfoModel.fromMap(doc.data());
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error getting contact info: $e');
    }
    return ContactInfoModel.defaults;
  }

  /// حفظ معلومات الاتصال في Firebase
  Future<bool> saveContactInfo(ContactInfoModel info) async {
    if (!_isFirebaseInitialized || _firestore == null) {
      return false;
    }
    try {
      await _firestore!.doc(_docPath).set({
        ...info.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error saving contact info: $e');
      return false;
    }
  }
}
