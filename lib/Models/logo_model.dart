import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for managing logos (partners/clients)
class LogoModel extends Equatable {
  final String id;
  final String name; // اسم الشعار (اختياري)
  final String imageBase64; // الصورة كـ base64
  final String pageId; // الصفحة التي ينتمي إليها الشعار
  final int order; // الترتيب
  final DateTime createdAt;
  final DateTime updatedAt;

  const LogoModel({
    required this.id,
    required this.name,
    required this.imageBase64,
    required this.pageId,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LogoModel.fromMap(Map<String, dynamic> map) {
    return LogoModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageBase64: map['imageBase64'] ?? '',
      pageId: map['pageId'] ?? '',
      order: map['order'] ?? 0,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageBase64': imageBase64,
      'pageId': pageId,
      'order': order,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  LogoModel copyWith({
    String? id,
    String? name,
    String? imageBase64,
    String? pageId,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LogoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageBase64: imageBase64 ?? this.imageBase64,
      pageId: pageId ?? this.pageId,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, imageBase64, pageId, order, createdAt, updatedAt];
}

