/// نموذج معلومات الاتصال الموحدة
/// يستخدم في الفوتر وزر الاتصال العائم وصفحة اتصل بنا
class ContactInfoModel {
  final String email;
  final String phone; // رقم الاتصال (call)
  final String whatsapp; // رقم الواتساب (بدون +)
  final String address;
  final String mapLink; // رابط خرائط جوجل
  /// بريد استلام رسائل النماذج (EmailJS). إن وُجد يُفضّل على RECIPIENT_EMAIL في البناء.
  final String formRecipientEmail;
  /// اسم المستلم في قالب EmailJS (`to_name`). اختياري.
  final String formRecipientName;
  /// يُرسَل كـ `user_id` في طلب EmailJS؛ إن وُجد يُفضّل على البناء.
  final String emailJsPublicKey;
  final String emailJsServiceId;
  final String emailJsTemplateId;
  /// مفتاح EmailJS الخاص (`accessToken` في REST API) — يُفضّل لتطبيقات Android/iOS.
  final String emailJsAccessToken;

  const ContactInfoModel({
    required this.email,
    required this.phone,
    required this.whatsapp,
    required this.address,
    required this.mapLink,
    this.formRecipientEmail = '',
    this.formRecipientName = '',
    this.emailJsPublicKey = '',
    this.emailJsServiceId = '',
    this.emailJsTemplateId = '',
    this.emailJsAccessToken = '',
  });

  /// القيم الافتراضية عند عدم وجود بيانات في Firebase
  static const ContactInfoModel defaults = ContactInfoModel(
    email: 'info@incomercialeg.com',
    phone: '0111-032-7777',
    whatsapp: '201110327777',
    address: '14 A/2 Admin building, New Cairo, Egypt',
    mapLink: 'https://maps.app.goo.gl/xcCQnFRxJymzVune6',
    formRecipientEmail: '',
    formRecipientName: '',
    emailJsPublicKey: '',
    emailJsServiceId: '',
    emailJsTemplateId: '',
    emailJsAccessToken: '',
  );

  static String _stringFromFirestore(
    Map<String, dynamic> map,
    String key,
    String fallback,
  ) {
    final v = map[key];
    if (v == null) return fallback;
    final s = v is String ? v : v.toString();
    final t = s.trim();
    return t.isEmpty ? fallback : t;
  }

  factory ContactInfoModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return defaults;
    try {
      return ContactInfoModel(
        email: _stringFromFirestore(map, 'email', defaults.email),
        phone: _stringFromFirestore(map, 'phone', defaults.phone),
        whatsapp: _stringFromFirestore(map, 'whatsapp', defaults.whatsapp),
        address: _stringFromFirestore(map, 'address', defaults.address),
        mapLink: _stringFromFirestore(map, 'mapLink', defaults.mapLink),
        formRecipientEmail: _stringFromFirestore(map, 'formRecipientEmail', ''),
        formRecipientName: _stringFromFirestore(map, 'formRecipientName', ''),
        emailJsPublicKey: _stringFromFirestore(map, 'emailJsPublicKey', ''),
        emailJsServiceId: _stringFromFirestore(map, 'emailJsServiceId', ''),
        emailJsTemplateId: _stringFromFirestore(map, 'emailJsTemplateId', ''),
        emailJsAccessToken: _stringFromFirestore(map, 'emailJsAccessToken', ''),
      );
    } catch (_) {
      return defaults;
    }
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'phone': phone,
        'whatsapp': whatsapp,
        'address': address,
        'mapLink': mapLink,
        'formRecipientEmail': formRecipientEmail,
        'formRecipientName': formRecipientName,
        'emailJsPublicKey': emailJsPublicKey,
        'emailJsServiceId': emailJsServiceId,
        'emailJsTemplateId': emailJsTemplateId,
        'emailJsAccessToken': emailJsAccessToken,
      };

  ContactInfoModel copyWith({
    String? email,
    String? phone,
    String? whatsapp,
    String? address,
    String? mapLink,
    String? formRecipientEmail,
    String? formRecipientName,
    String? emailJsPublicKey,
    String? emailJsServiceId,
    String? emailJsTemplateId,
    String? emailJsAccessToken,
  }) =>
      ContactInfoModel(
        email: email ?? this.email,
        phone: phone ?? this.phone,
        whatsapp: whatsapp ?? this.whatsapp,
        address: address ?? this.address,
        mapLink: mapLink ?? this.mapLink,
        formRecipientEmail: formRecipientEmail ?? this.formRecipientEmail,
        formRecipientName: formRecipientName ?? this.formRecipientName,
        emailJsPublicKey: emailJsPublicKey ?? this.emailJsPublicKey,
        emailJsServiceId: emailJsServiceId ?? this.emailJsServiceId,
        emailJsTemplateId: emailJsTemplateId ?? this.emailJsTemplateId,
        emailJsAccessToken: emailJsAccessToken ?? this.emailJsAccessToken,
      );
}
