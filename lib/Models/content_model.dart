import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for managing app content (text, images, etc.)
class ContentModel extends Equatable {
  final String id;
  final String pageId; // e.g., 'home', 'about', 'corporate-leasing'
  final String sectionId; // e.g., 'hero-title', 'description', 'background-image'
  final ContentType type; // text, image, etc.
  final Map<String, String> values; // {'en': 'English text', 'ar': 'Arabic text'}
  final String? imageBase64; // Base64 string for images
  final DateTime createdAt;
  final DateTime updatedAt;

  const ContentModel({
    required this.id,
    required this.pageId,
    required this.sectionId,
    required this.type,
    required this.values,
    this.imageBase64,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContentModel.fromMap(Map<String, dynamic> map) {
    final rawValues = map['values'];
    Map<String, String> valuesMap = {};
    if (rawValues != null && rawValues is Map) {
      for (final e in rawValues.entries) {
        final k = e.key?.toString();
        if (k != null && k.isNotEmpty) valuesMap[k] = e.value?.toString() ?? '';
      }
    }
    final createdAtRaw = map['createdAt'];
    final updatedAtRaw = map['updatedAt'];
    return ContentModel(
      id: map['id']?.toString() ?? '',
      pageId: map['pageId']?.toString() ?? '',
      sectionId: map['sectionId']?.toString() ?? '',
      type: ContentType.fromString(map['type'] ?? 'text'),
      values: valuesMap,
      imageBase64: map['imageBase64']?.toString(),
      createdAt: createdAtRaw is Timestamp
          ? createdAtRaw.toDate()
          : (createdAtRaw is DateTime ? createdAtRaw : DateTime.now()),
      updatedAt: updatedAtRaw is Timestamp
          ? updatedAtRaw.toDate()
          : (updatedAtRaw is DateTime ? updatedAtRaw : DateTime.now()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pageId': pageId,
      'sectionId': sectionId,
      'type': type.toString().split('.').last,
      'values': values,
      'imageBase64': imageBase64,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ContentModel copyWith({
    String? id,
    String? pageId,
    String? sectionId,
    ContentType? type,
    Map<String, String>? values,
    String? imageBase64,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ContentModel(
      id: id ?? this.id,
      pageId: pageId ?? this.pageId,
      sectionId: sectionId ?? this.sectionId,
      type: type ?? this.type,
      values: values ?? this.values,
      imageBase64: imageBase64 ?? this.imageBase64,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        pageId,
        sectionId,
        type,
        values,
        imageBase64,
        createdAt,
        updatedAt,
      ];
}

enum ContentType {
  text,
  image,
  video,
  link;

  static ContentType fromString(dynamic value) {
    if (value == null) return ContentType.text;
    final s = value.toString().trim();
    if (s.isEmpty) return ContentType.text;
    // Firebase may store "ContentType.image" or "image"
    final key = s.contains('.') ? s.split('.').last.toLowerCase() : s.toLowerCase();
    return ContentType.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == key,
      orElse: () => ContentType.text,
    );
  }
}

