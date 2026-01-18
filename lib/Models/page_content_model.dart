import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'content_model.dart';

/// Model for organizing content by page
class PageContentModel extends Equatable {
  final String pageId;
  final String pageName;
  final List<ContentModel> contents;
  final DateTime lastUpdated;

  const PageContentModel({
    required this.pageId,
    required this.pageName,
    required this.contents,
    required this.lastUpdated,
  });

  factory PageContentModel.fromMap(Map<String, dynamic> map) {
    return PageContentModel(
      pageId: map['pageId'] ?? '',
      pageName: map['pageName'] ?? '',
      contents: (map['contents'] as List<dynamic>?)
              ?.map((e) => ContentModel.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastUpdated: map['lastUpdated'] != null
          ? (map['lastUpdated'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pageId': pageId,
      'pageName': pageName,
      'contents': contents.map((e) => e.toMap()).toList(),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  @override
  List<Object?> get props => [pageId, pageName, contents, lastUpdated];
}

