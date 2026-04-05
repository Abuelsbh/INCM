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
  );

  factory ContactInfoModel.fromMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return defaults;
    return ContactInfoModel(
      email: map['email'] as String? ?? defaults.email,
      phone: map['phone'] as String? ?? defaults.phone,
      whatsapp: map['whatsapp'] as String? ?? defaults.whatsapp,
      address: map['address'] as String? ?? defaults.address,
      mapLink: map['mapLink'] as String? ?? defaults.mapLink,
      formRecipientEmail: map['formRecipientEmail'] as String? ?? '',
      formRecipientName: map['formRecipientName'] as String? ?? '',
      emailJsPublicKey: map['emailJsPublicKey'] as String? ?? '',
      emailJsServiceId: map['emailJsServiceId'] as String? ?? '',
      emailJsTemplateId: map['emailJsTemplateId'] as String? ?? '',
    );
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
      );
}
