import 'package:flutter/material.dart';
import '../../Models/service_model.dart';
import '../Firebase/firebase_services_service.dart';

/// Built-in services with their static routes (pageId matches existing screens)
/// Order matches services_content_section: Consultation, Retail, Medical, Corporate, Facility, Franchise, Primary, Marketing
const List<ServiceModel> _builtInServices = [
  ServiceModel(
    id: 'consultation',
    pageId: 'consultation',
    nameEn: 'Consultation',
    nameAr: 'الاستشارة',
    order: 0,
    isCustom: false,
    nameKey: 'CONSULTATION',
    descriptionKey: 'CONSULTATION_DESCRIPTION',
  ),
  ServiceModel(
    id: 'retail-leasing',
    pageId: 'retail-leasing',
    nameEn: 'Retail Leasing',
    nameAr: 'إيجار التجزئة',
    order: 1,
    isCustom: false,
    nameKey: 'RETAIL_LEASING',
    descriptionKey: 'RETAIL_LEASING_DESCRIPTION',
  ),
  ServiceModel(
    id: 'medical-leasing',
    pageId: 'medical-leasing',
    nameEn: 'Medical Leasing',
    nameAr: 'إيجار طبي',
    order: 2,
    isCustom: false,
    nameKey: 'MEDICAL_LEASING',
    descriptionKey: 'MEDICAL_LEASING_DESCRIPTION',
  ),
  ServiceModel(
    id: 'corporate-leasing',
    pageId: 'corporate-leasing',
    nameEn: 'Corporate Leasing',
    nameAr: 'إيجار الشركات',
    order: 3,
    isCustom: false,
    nameKey: 'CORPORATE_LEASING',
    descriptionKey: 'CORPORATE_LEASING_DESCRIPTION',
  ),
  ServiceModel(
    id: 'facility-management',
    pageId: 'facility-management',
    nameEn: 'Facility Management',
    nameAr: 'إدارة المرافق',
    order: 4,
    isCustom: false,
    nameKey: 'FACILITY_MANAGEMENT',
    descriptionKey: 'FACILITY_MANAGEMENT_DESCRIPTION',
  ),
  ServiceModel(
    id: 'franchise-investment',
    pageId: 'franchise-investment',
    nameEn: 'Franchise Investment',
    nameAr: 'استثمار الامتياز',
    order: 5,
    isCustom: false,
    nameKey: 'FRANCHISE_INVESTMENT',
    descriptionKey: 'FRANCHISE_INVESTMENT_DESCRIPTION',
  ),
  ServiceModel(
    id: 'primary-investment',
    pageId: 'primary-investment',
    nameEn: 'Primary Investment',
    nameAr: 'الاستثمار الأساسي',
    order: 6,
    isCustom: false,
    nameKey: 'PRIMARY_INVESTMENT',
    descriptionKey: 'PRIMARY_INVESTMENT_DESCRIPTION',
  ),
  ServiceModel(
    id: 'marketing',
    pageId: 'marketing',
    nameEn: 'Marketing',
    nameAr: 'التسويق',
    order: 7,
    isCustom: false,
    nameKey: 'MARKETING',
    descriptionKey: 'MARKETING_DESCRIPTION',
  ),
];

/// Provider that merges built-in services with custom services from Firebase
class ServicesProvider extends ChangeNotifier {
  final FirebaseServicesService _firebaseService = FirebaseServicesService();
  List<ServiceModel> _customServices = [];
  bool _isLoading = false;
  bool _hasLoaded = false;

  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;

  /// All services: built-in + custom, sorted by order
  List<ServiceModel> get allServices {
    final builtInOrdered = List<ServiceModel>.from(_builtInServices);
    final customOrdered = List<ServiceModel>.from(_customServices);
    customOrdered.sort((a, b) => a.order.compareTo(b.order));
    final result = [...builtInOrdered, ...customOrdered];
    result.sort((a, b) => a.order.compareTo(b.order));
    return result;
  }

  /// Only custom services (for admin)
  List<ServiceModel> get customServices => List.unmodifiable(_customServices);

  /// Check if a pageId is a custom service (from Firebase)
  bool isCustomService(String pageId) {
    return _customServices.any((s) => s.pageId == pageId);
  }

  Future<void> loadServices() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      _customServices = await _firebaseService.getAllServices();
    } catch (e) {
      _customServices = [];
    } finally {
      _isLoading = false;
      _hasLoaded = true;
      notifyListeners();
    }
  }

  Future<bool> addService(ServiceModel service) async {
    final success = await _firebaseService.addService(service);
    if (success) {
      await loadServices();
    }
    return success;
  }

  Future<bool> updateService(ServiceModel service) async {
    final success = await _firebaseService.updateService(service);
    if (success) {
      await loadServices();
    }
    return success;
  }

  Future<bool> deleteService(String serviceId) async {
    final success = await _firebaseService.deleteService(serviceId);
    if (success) {
      await loadServices();
    }
    return success;
  }
}
