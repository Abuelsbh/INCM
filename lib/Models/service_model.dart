import 'package:equatable/equatable.dart';

/// Model for a service (can be static or custom from Firebase)
class ServiceModel extends Equatable {
  final String id;
  final String pageId; // e.g. 'facility-management', 'my-custom-service'
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;
  final int order;
  final bool isCustom; // true = from Firebase, false = built-in
  /// Translation key for name (built-in only), e.g. 'CONSULTATION'
  final String? nameKey;
  /// Translation key for description (built-in only), e.g. 'CONSULTATION_DESCRIPTION'
  final String? descriptionKey;

  const ServiceModel({
    required this.id,
    required this.pageId,
    required this.nameEn,
    required this.nameAr,
    this.descriptionEn = '',
    this.descriptionAr = '',
    this.order = 0,
    this.isCustom = false,
    this.nameKey,
    this.descriptionKey,
  });

  String get route => '/services/$pageId';

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id']?.toString() ?? '',
      pageId: map['pageId']?.toString() ?? '',
      nameEn: map['nameEn']?.toString() ?? '',
      nameAr: map['nameAr']?.toString() ?? '',
      descriptionEn: map['descriptionEn']?.toString() ?? '',
      descriptionAr: map['descriptionAr']?.toString() ?? '',
      order: (map['order'] is int) ? map['order'] as int : int.tryParse(map['order']?.toString() ?? '0') ?? 0,
      isCustom: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pageId': pageId,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'descriptionEn': descriptionEn,
      'descriptionAr': descriptionAr,
      'order': order,
    };
  }

  ServiceModel copyWith({
    String? id,
    String? pageId,
    String? nameEn,
    String? nameAr,
    String? descriptionEn,
    String? descriptionAr,
    int? order,
    bool? isCustom,
    String? nameKey,
    String? descriptionKey,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      order: order ?? this.order,
      isCustom: isCustom ?? this.isCustom,
      nameKey: nameKey ?? this.nameKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
    );
  }

  @override
  List<Object?> get props => [id, pageId, nameEn, nameAr, order, isCustom];
}
