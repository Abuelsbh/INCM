/// نموذج معلومات الاتصال الموحدة
/// يستخدم في الفوتر وزر الاتصال العائم وصفحة اتصل بنا
class ContactInfoModel {
  final String email;
  final String phone; // رقم الاتصال (call)
  final String whatsapp; // رقم الواتساب (بدون +)
  final String address;
  final String mapLink; // رابط خرائط جوجل

  const ContactInfoModel({
    required this.email,
    required this.phone,
    required this.whatsapp,
    required this.address,
    required this.mapLink,
  });

  /// القيم الافتراضية عند عدم وجود بيانات في Firebase
  static const ContactInfoModel defaults = ContactInfoModel(
    email: 'info@incomercialeg.com',
    phone: '0111-032-7777',
    whatsapp: '201110327777',
    address: '14 A/2 Admin building, New Cairo, Egypt',
    mapLink: 'https://maps.app.goo.gl/xcCQnFRxJymzVune6',
  );

  factory ContactInfoModel.fromMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return defaults;
    return ContactInfoModel(
      email: map['email'] as String? ?? defaults.email,
      phone: map['phone'] as String? ?? defaults.phone,
      whatsapp: map['whatsapp'] as String? ?? defaults.whatsapp,
      address: map['address'] as String? ?? defaults.address,
      mapLink: map['mapLink'] as String? ?? defaults.mapLink,
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'phone': phone,
        'whatsapp': whatsapp,
        'address': address,
        'mapLink': mapLink,
      };

  ContactInfoModel copyWith({
    String? email,
    String? phone,
    String? whatsapp,
    String? address,
    String? mapLink,
  }) =>
      ContactInfoModel(
        email: email ?? this.email,
        phone: phone ?? this.phone,
        whatsapp: whatsapp ?? this.whatsapp,
        address: address ?? this.address,
        mapLink: mapLink ?? this.mapLink,
      );
}
