import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../Models/content_model.dart';
import '../../Models/page_content_model.dart';

const Duration _kFirestoreTimeout = Duration(seconds: 10);

class FirebaseContentService {
  final String _collectionName = 'app_content';

  /// Check if Firebase is initialized
  bool get _isFirebaseInitialized {
    try {
      Firebase.app();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get Firestore instance (with null safety)
  FirebaseFirestore? get _firestore {
    if (!_isFirebaseInitialized) {
      return null;
    }
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      return null;
    }
  }

  /// Get all content for a specific page
  Future<List<ContentModel>> getPageContent(String pageId) async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot get page content.');
      return [];
    }
    try {
      final querySnapshot = await _firestore!
          .collection(_collectionName)
          .where('pageId', isEqualTo: pageId)
          .get()
          .timeout(_kFirestoreTimeout);

      return querySnapshot.docs
          .map((doc) => ContentModel.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      print('Error getting page content: $e');
      return [];
    }
  }

  /// Get specific content by page and section
  Future<ContentModel?> getContent(
    String pageId,
    String sectionId,
  ) async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot get content.');
      return null;
    }
    try {
      final querySnapshot = await _firestore!
          .collection(_collectionName)
          .where('pageId', isEqualTo: pageId)
          .where('sectionId', isEqualTo: sectionId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final doc = querySnapshot.docs.first;
      return ContentModel.fromMap({
        'id': doc.id,
        ...doc.data(),
      });
    } catch (e) {
      print('Error getting content: $e');
      return null;
    }
  }

  /// Save or update content.
  /// If content has no id but a document with same pageId+sectionId exists,
  /// updates that document instead of creating a duplicate.
  Future<bool> saveContent(ContentModel content) async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot save content.');
      return false;
    }
    try {
      final contentMap = content.toMap();
      contentMap.remove('id'); // Remove id from map as it's the document ID

      String docId = content.id;
      if (docId.isEmpty) {
        // Check if section already exists (same pageId + sectionId)
        final existing = await getContent(content.pageId, content.sectionId);
        if (existing != null) {
          docId = existing.id; // Update existing instead of creating duplicate
        }
      }

      if (docId.isEmpty) {
        // Create new content
        final docRef = await _firestore!.collection(_collectionName).add({
          ...contentMap,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return docRef.id.isNotEmpty;
      } else {
        // Update existing content
        await _firestore!.collection(_collectionName).doc(docId).update({
          ...contentMap,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
    } catch (e) {
      print('Error saving content: $e');
      return false;
    }
  }

  /// Delete content
  Future<bool> deleteContent(String contentId) async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot delete content.');
      return false;
    }
    try {
      await _firestore!.collection(_collectionName).doc(contentId).delete();
      return true;
    } catch (e) {
      print('Error deleting content: $e');
      return false;
    }
  }

  /// Get all pages with their content
  Future<List<PageContentModel>> getAllPagesContent() async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot get all pages content.');
      return [];
    }
    try {
      final querySnapshot = await _firestore!.collection(_collectionName).get();

      // Group by pageId
      final Map<String, List<ContentModel>> pagesMap = {};
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final pageId = data['pageId'] as String? ?? '';
        if (pageId.isNotEmpty) {
          pagesMap.putIfAbsent(pageId, () => []);
          pagesMap[pageId]!.add(ContentModel.fromMap({
            'id': doc.id,
            ...data,
          }));
        }
      }

      // Convert to PageContentModel list
      return pagesMap.entries.map((entry) {
        return PageContentModel(
          pageId: entry.key,
          pageName: _getPageName(entry.key),
          contents: entry.value,
          lastUpdated: entry.value.isNotEmpty
              ? entry.value
                  .map((c) => c.updatedAt)
                  .reduce((a, b) => a.isAfter(b) ? a : b)
              : DateTime.now(),
        );
      }).toList();
    } catch (e) {
      print('Error getting all pages content: $e');
      return [];
    }
  }

  /// Stream content for real-time updates
  Stream<List<ContentModel>> streamPageContent(String pageId) {
    if (!_isFirebaseInitialized || _firestore == null) {
      return Stream.value([]);
    }
    return _firestore!
        .collection(_collectionName)
        .where('pageId', isEqualTo: pageId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ContentModel.fromMap({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList());
  }

  /// Get page name from pageId
  String _getPageName(String pageId) {
    final pageNames = {
      'home': 'الصفحة الرئيسية',
      'about': 'من نحن',
      'contacts': 'اتصل بنا',
      'career': 'الوظائف',
      'buy': 'شراء',
      'sell': 'بيع',
      'lease': 'إيجار',
      'corporate-leasing': 'إيجار الشركات',
      'retail-leasing': 'إيجار التجزئة',
      'medical-leasing': 'إيجار طبي',
      'facility-management': 'إدارة المرافق',
      'franchise-investment': 'استثمار الامتياز',
      'primary-investment': 'الاستثمار الأساسي',
      'marketing': 'التسويق',
      'consultation': 'الاستشارة',
      'services': 'الخدمات',
      'all-logos': 'جميع الشعارات',
    };
    return pageNames[pageId] ?? pageId;
  }

  /// Batch save multiple content items.
  /// For items with no id, updates existing doc with same pageId+sectionId if found.
  Future<bool> batchSaveContent(List<ContentModel> contents) async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot batch save content.');
      return false;
    }
    try {
      // Resolve ids for items with empty id (update existing section if found)
      final resolvedContents = <ContentModel>[];
      for (var content in contents) {
        if (content.id.isEmpty) {
          final existing = await getContent(content.pageId, content.sectionId);
          resolvedContents.add(existing != null
              ? content.copyWith(id: existing.id)
              : content);
        } else {
          resolvedContents.add(content);
        }
      }

      final batch = _firestore!.batch();
      final now = FieldValue.serverTimestamp();

      for (var content in resolvedContents) {
        final contentMap = content.toMap();
        contentMap.remove('id');
        contentMap['updatedAt'] = now;

        if (content.id.isEmpty) {
          final docRef = _firestore!.collection(_collectionName).doc();
          batch.set(docRef, {
            ...contentMap,
            'createdAt': now,
          });
        } else {
          final docRef = _firestore!.collection(_collectionName).doc(content.id);
          batch.update(docRef, contentMap);
        }
      }

      await batch.commit();
      return true;
    } catch (e) {
      print('Error batch saving content: $e');
      return false;
    }
  }
}

