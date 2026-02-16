import 'package:flutter/foundation.dart';
import '../../Models/contact_info_model.dart';
import '../Firebase/firebase_contact_info_service.dart';

/// Provider لمعلومات الاتصال الموحدة
/// يتم جلب البيانات من Firebase مرة واحدة فقط عند زيارة الصفحة الرئيسية
/// وباقي الصفحات تستخدم البيانات المخزنة بدون جلب جديد
class ContactInfoProvider extends ChangeNotifier {
  final FirebaseContactInfoService _service = FirebaseContactInfoService();

  ContactInfoModel _contactInfo = ContactInfoModel.defaults;
  bool _isLoaded = false;
  bool _isLoading = false;

  ContactInfoModel get contactInfo => _contactInfo;
  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;

  String get email => _contactInfo.email;
  String get phone => _contactInfo.phone;
  String get whatsapp => _contactInfo.whatsapp;
  String get address => _contactInfo.address;
  String get mapLink => _contactInfo.mapLink;

  /// جلب معلومات الاتصال من Firebase
  /// يُستدعى فقط من الصفحة الرئيسية
  /// إذا كانت البيانات محملة مسبقاً، لا يتم جلبها مرة أخرى
  Future<void> fetchContactInfo() async {
    if (_isLoaded && !_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      _contactInfo = await _service.getContactInfo();
      _isLoaded = true;
    } catch (e) {
      _contactInfo = ContactInfoModel.defaults;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// إجبار إعادة جلب البيانات (مثلاً بعد التحديث من الأدمن)
  Future<void> refreshContactInfo() async {
    _isLoaded = false;
    await fetchContactInfo();
  }

  /// حفظ معلومات الاتصال (من لوحة الأدمن)
  Future<bool> saveContactInfo(ContactInfoModel info) async {
    final success = await _service.saveContactInfo(info);
    if (success) {
      _contactInfo = info;
      _isLoaded = true;
      notifyListeners();
    }
    return success;
  }
}
