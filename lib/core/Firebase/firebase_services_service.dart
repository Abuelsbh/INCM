import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../Models/service_model.dart';

class FirebaseServicesService {
  final String _collectionName = 'services_config';

  bool get _isFirebaseInitialized {
    try {
      Firebase.app();
      return true;
    } catch (e) {
      return false;
    }
  }

  FirebaseFirestore? get _firestore {
    if (!_isFirebaseInitialized) return null;
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      return null;
    }
  }

  /// Get all custom services ordered by order field
  Future<List<ServiceModel>> getAllServices() async {
    if (!_isFirebaseInitialized || _firestore == null) {
      return [];
    }
    try {
      final querySnapshot = await _firestore!
          .collection(_collectionName)
          .orderBy('order')
          .get();

      return querySnapshot.docs.map((doc) {
        return ServiceModel.fromMap({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
    } catch (e) {
      // If index error, try without orderBy
      try {
        final querySnapshot = await _firestore!
            .collection(_collectionName)
            .get();
        final list = querySnapshot.docs.map((doc) {
          return ServiceModel.fromMap({
            'id': doc.id,
            ...doc.data(),
          });
        }).toList();
        list.sort((a, b) => a.order.compareTo(b.order));
        return list;
      } catch (_) {
        return [];
      }
    }
  }

  /// Add a new custom service
  Future<bool> addService(ServiceModel service) async {
    if (!_isFirebaseInitialized || _firestore == null) return false;
    try {
      final maxOrder = await _getMaxOrder();
      final data = service.toMap();
      data['order'] = maxOrder + 1;
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore!.collection(_collectionName).add(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Update an existing service
  Future<bool> updateService(ServiceModel service) async {
    if (!_isFirebaseInitialized || _firestore == null || service.id.isEmpty) {
      return false;
    }
    try {
      final data = service.toMap();
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore!.collection(_collectionName).doc(service.id).update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete a service
  Future<bool> deleteService(String serviceId) async {
    if (!_isFirebaseInitialized || _firestore == null || serviceId.isEmpty) {
      return false;
    }
    try {
      await _firestore!.collection(_collectionName).doc(serviceId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> _getMaxOrder() async {
    try {
      final snapshot = await _firestore!
          .collection(_collectionName)
          .orderBy('order', descending: true)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) return 0;
      final data = snapshot.docs.first.data();
      return (data['order'] as int?) ?? 0;
    } catch (_) {
      return 0;
    }
  }
}
