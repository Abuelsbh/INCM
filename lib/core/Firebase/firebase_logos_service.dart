import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../Models/logo_model.dart';

class FirebaseLogosService {
  final String _collectionName = 'logos';

  /// Check if Firebase is initialized
  bool get _isFirebaseInitialized {
    try {
      Firebase.app();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get Firestore instance
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

  /// Get all logos ordered by order field
  Future<List<LogoModel>> getAllLogos({String? pageId}) async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot get logos.');
      return [];
    }
    try {
      Query<Map<String, dynamic>> query = _firestore!.collection(_collectionName);
      
      // Filter by pageId if provided
      if (pageId != null && pageId.isNotEmpty) {
        query = query.where('pageId', isEqualTo: pageId);
      }
      
      // Order by order field
      // Note: If using where with orderBy, you may need a composite index in Firestore
      // Firestore will suggest creating the index if needed
      final querySnapshot = await query.orderBy('order').get();

      print('Firebase query returned ${querySnapshot.docs.length} documents');
      
      final logos = querySnapshot.docs
          .map((doc) {
            final data = doc.data();
            print('Document ID: ${doc.id}, pageId: ${data['pageId']}, imageBase64 length: ${(data['imageBase64'] as String?)?.length ?? 0}');
            return LogoModel.fromMap({
              'id': doc.id,
              ...data,
            });
          })
          .toList();
      
      print('Parsed ${logos.length} logos');
      for (var logo in logos) {
        print('Logo: id=${logo.id}, pageId=${logo.pageId}, imageBase64 length=${logo.imageBase64.length}');
      }
      
      return logos;
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      // Check for various forms of index errors
      final isIndexError = errorString.contains('index') || 
                          errorString.contains('failed-precondition') ||
                          errorString.contains('requires an index');
      
      // If composite index error, try fetching all and filtering in memory
      if (isIndexError) {
        // Suppress the error message since we have a fallback
        print('Composite index required. Fetching all logos and filtering in memory...');
        try {
          final allLogos = await _firestore!
              .collection(_collectionName)
              .orderBy('order')
              .get();
          
          var filteredDocs = allLogos.docs;
          if (pageId != null && pageId.isNotEmpty) {
            filteredDocs = allLogos.docs.where((doc) {
              final data = doc.data();
              return data['pageId'] == pageId;
            }).toList();
          }
          
          final result = filteredDocs
              .map((doc) => LogoModel.fromMap({
                    'id': doc.id,
                    ...doc.data(),
                  }))
              .toList();
          
          // Only log success, not the original error
          if (result.isNotEmpty) {
            print('Successfully loaded ${result.length} logos using fallback method');
          }
          
          return result;
        } catch (e2) {
          print('Error in fallback method: $e2');
          return [];
        }
      }
      // For other errors, log them
      print('Error getting logos: $e');
      return [];
    }
  }

  /// Add a new logo
  Future<bool> addLogo(LogoModel logo) async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot add logo.');
      return false;
    }
    try {
      final logoMap = logo.toMap();
      logoMap.remove('id');

      // Validate imageBase64
      if (logoMap['imageBase64'] == null || (logoMap['imageBase64'] as String).isEmpty) {
        print('Error: imageBase64 is empty');
        return false;
      }

      print('Adding logo to Firestore: pageId=${logoMap['pageId']}, imageBase64 length=${(logoMap['imageBase64'] as String).length}');

      await _firestore!.collection(_collectionName).add({
        ...logoMap,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      print('Logo added successfully');
      return true;
    } catch (e, stackTrace) {
      print('Error adding logo: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Add multiple logos in batch
  Future<bool> addLogosBatch(List<LogoModel> logos, {int? startOrder}) async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot add logos.');
      return false;
    }

    if (logos.isEmpty) {
      print('Error: No logos to add');
      return false;
    }

    try {
      // Get the current max order for the page if startOrder is not provided
      int currentOrder = startOrder ?? 0;
      if (startOrder == null && logos.isNotEmpty) {
        final pageId = logos.first.pageId;
        final existingLogos = await getAllLogos(pageId: pageId);
        if (existingLogos.isNotEmpty) {
          currentOrder = existingLogos.map((l) => l.order).reduce((a, b) => a > b ? a : b);
        }
      }

      // Use batch write for efficient multiple writes
      final batch = _firestore!.batch();
      
      for (int i = 0; i < logos.length; i++) {
        final logo = logos[i];
        final logoMap = logo.toMap();
        logoMap.remove('id');

        // Validate imageBase64
        if (logoMap['imageBase64'] == null || (logoMap['imageBase64'] as String).isEmpty) {
          print('Warning: Skipping logo ${i + 1} - imageBase64 is empty');
          continue;
        }

        // Set order
        logoMap['order'] = currentOrder + i + 1;

        // Create document reference
        final docRef = _firestore!.collection(_collectionName).doc();
        
        batch.set(docRef, {
          ...logoMap,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Commit batch
      await batch.commit();
      
      print('Successfully added ${logos.length} logos in batch');
      return true;
    } catch (e, stackTrace) {
      print('Error adding logos in batch: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Update logo
  Future<bool> updateLogo(LogoModel logo) async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot update logo.');
      return false;
    }
    try {
      final logoMap = logo.toMap();
      logoMap.remove('id');

      await _firestore!.collection(_collectionName).doc(logo.id).update({
        ...logoMap,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating logo: $e');
      return false;
    }
  }

  /// Delete logo
  Future<bool> deleteLogo(String logoId) async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot delete logo.');
      return false;
    }
    try {
      await _firestore!.collection(_collectionName).doc(logoId).delete();
      return true;
    } catch (e) {
      print('Error deleting logo: $e');
      return false;
    }
  }

  /// Reorder logos
  Future<bool> reorderLogos(List<LogoModel> logos) async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot reorder logos.');
      return false;
    }
    try {
      final batch = _firestore!.batch();
      for (var logo in logos) {
        final docRef = _firestore!.collection(_collectionName).doc(logo.id);
        batch.update(docRef, {
          'order': logo.order,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
      return true;
    } catch (e) {
      print('Error reordering logos: $e');
      return false;
    }
  }

  /// Get all logos from all 8 services (for home page)
  Future<List<LogoModel>> getAllServicesLogos() async {
    if (!_isFirebaseInitialized || _firestore == null) {
      print('Firebase not initialized. Cannot get logos.');
      return [];
    }

    // List of all 8 service page IDs
    const servicePageIds = [
      'corporate-leasing',
      'retail-leasing',
      'medical-leasing',
      'facility-management',
      'franchise-investment',
      'primary-investment',
      'marketing',
      'consultation',
    ];

    try {
      print('Loading all logos from all 8 services...');
      
      // Fetch all logos (without pageId filter) and filter in memory
      final allLogosSnapshot = await _firestore!
          .collection(_collectionName)
          .get();
      
      // Filter to only include logos from the 8 services
      final filteredDocs = allLogosSnapshot.docs.where((doc) {
        final data = doc.data();
        final pageId = data['pageId'] as String?;
        return pageId != null && servicePageIds.contains(pageId);
      }).toList();
      
      // Sort by order manually
      filteredDocs.sort((a, b) {
        final orderA = (a.data()['order'] as int?) ?? 0;
        final orderB = (b.data()['order'] as int?) ?? 0;
        final pageIdA = a.data()['pageId'] as String? ?? '';
        final pageIdB = b.data()['pageId'] as String? ?? '';
        
        // First sort by pageId to group by service
        final pageIdCompare = pageIdA.compareTo(pageIdB);
        if (pageIdCompare != 0) return pageIdCompare;
        
        // Then sort by order within each service
        return orderA.compareTo(orderB);
      });
      
      final logos = filteredDocs
          .map((doc) => LogoModel.fromMap({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
      
      print('Loaded ${logos.length} logos from all 8 services');
      return logos;
    } catch (e) {
      print('Error getting all services logos: $e');
      return [];
    }
  }

  /// Stream logos for real-time updates
  Stream<List<LogoModel>> streamLogos({String? pageId}) {
    if (!_isFirebaseInitialized || _firestore == null) {
      return Stream.value([]);
    }
    try {
      Query<Map<String, dynamic>> query = _firestore!.collection(_collectionName);
      
      // Filter by pageId if provided
      if (pageId != null && pageId.isNotEmpty) {
        query = query.where('pageId', isEqualTo: pageId);
      }
      
      // Order by order field
      // Note: If using where with orderBy, you may need a composite index in Firestore
      return query
          .orderBy('order')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => LogoModel.fromMap({
                    'id': doc.id,
                    ...doc.data(),
                  }))
              .toList());
    } catch (e) {
      print('Error streaming logos: $e');
      // If composite index error, return empty stream or filter in memory
      if (e.toString().contains('index') || e.toString().contains('requires an index')) {
        print('Composite index required for streaming. Returning filtered stream...');
        // Fallback: stream all and filter in memory
        return _firestore!
            .collection(_collectionName)
            .orderBy('order')
            .snapshots()
            .map((snapshot) {
              var docs = snapshot.docs;
              if (pageId != null && pageId.isNotEmpty) {
                docs = snapshot.docs.where((doc) {
                  final data = doc.data();
                  return data['pageId'] == pageId;
                }).toList();
              }
              return docs
                  .map((doc) => LogoModel.fromMap({
                        'id': doc.id,
                        ...doc.data(),
                      }))
                  .toList();
            });
      }
      return Stream.value([]);
    }
  }
}

