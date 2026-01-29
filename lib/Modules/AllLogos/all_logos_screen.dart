import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../core/Language/locales.dart';
import '../../Utilities/font_helper.dart';
import '../../core/Firebase/firebase_logos_service.dart';
import '../../Models/logo_model.dart';
import '../../Widgets/base64_image_widget.dart';

class AllLogosScreen extends StatefulWidget {
  static const String routeName = '/all-logos';

  const AllLogosScreen({Key? key}) : super(key: key);

  @override
  State<AllLogosScreen> createState() => _AllLogosScreenState();
}

class _AllLogosScreenState extends State<AllLogosScreen> {
  final FirebaseLogosService _logosService = FirebaseLogosService();
  late Future<Map<String, List<LogoModel>>> _logosFuture;

  // Map pageId (from Firebase) to i18n keys.
  // This keeps headlines localized (AR/EN) instead of hardcoded Arabic.
  final Map<String, String> _serviceNameKeys = {
    'corporate-leasing': 'CORPORATE_LEASING',
    'retail-leasing': 'RETAIL_LEASING',
    'medical-leasing': 'MEDICAL_LEASING',
    'facility-management': 'FACILITY_MANAGEMENT',
    'franchise-investment': 'FRANCHISE_INVESTMENT',
    'primary-investment': 'PRIMARY_INVESTMENT',
    'marketing': 'MARKETING',
    'consultation': 'CONSULTATION',
  };

  @override
  void initState() {
    super.initState();
    _logosFuture = _loadLogos();
  }

  Future<Map<String, List<LogoModel>>> _loadLogos() async {
    try {
      final logos = await _logosService.getAllServicesLogos();
      
      // Group logos by service (pageId)
      final Map<String, List<LogoModel>> groupedLogos = {};
      for (var logo in logos) {
        if (logo.imageBase64.isNotEmpty) {
          if (!groupedLogos.containsKey(logo.pageId)) {
            groupedLogos[logo.pageId] = [];
          }
          groupedLogos[logo.pageId]!.add(logo);
        }
      }

      return groupedLogos;
    } catch (e) {
      debugPrint('Error loading logos: $e');
      rethrow;
    }
  }

  void _retryLoadLogos() {
    setState(() {
      _logosFuture = _loadLogos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: MediaQuery.of(context).size.width < 600 && !kIsWeb ? const BottomNavBarWidget(selected: SelectedBottomNavBar.sellYourUnit) : null,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: isMobile ? 80.h : 120.h),
                  // Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Text(
                      'OUR_CLIENTS'.tr(context),
                      style: TextStyle(
                        fontFamily: getLocalizedFont(context, 'OptimalBold'),
                        color: const Color(0xFFF4ED47),
                        fontSize: isMobile ? 28.sp : 60.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Use FutureBuilder for async loading
                  FutureBuilder<Map<String, List<LogoModel>>>(
                    future: _logosFuture,
                    builder: (context, snapshot) {
                      // Loading state
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingState(isMobile);
                      }
                      
                      // Error state
                      if (snapshot.hasError) {
                        return Padding(
                          padding: EdgeInsets.all(40.h),
                          child: Column(
                            children: [
                              Text(
                                'ERROR_LOADING_LOGOS'.tr(context),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 16.sp : 20.sp,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              ElevatedButton(
                                onPressed: _retryLoadLogos,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF4ED47),
                                  foregroundColor: Colors.black,
                                ),
                                child: Text('RETRY'.tr(context)),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      // Success state
                      final logosByService = snapshot.data ?? {};
                      
                      if (logosByService.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(40.h),
                          child: Text(
                            'NO_LOGOS_AVAILABLE'.tr(context),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 16.sp : 20.sp,
                            ),
                          ),
                        );
                      }
                      
                      // Logos grouped by service
                      return Column(
                        children: logosByService.entries.map((entry) {
                          final pageId = entry.key;
                          final logos = entry.value;
                          final serviceNameKey = _serviceNameKeys[pageId];
                          final serviceName = serviceNameKey != null ? serviceNameKey.tr(context) : pageId;
                          
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: isMobile ? 30.h : 50.h,
                              left: isMobile ? 12.w : 40.w,
                              right: isMobile ? 12.w : 40.w,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Service Title
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: isMobile ? 15.h : 25.h,
                                    left: isMobile ? 8.w : 0,
                                  ),
                                  child: Text(
                                    serviceName,
                                    style: TextStyle(
                                      fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                      color: const Color(0xFFF4ED47),
                                      fontSize: isMobile ? 22.sp : 40.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Logos Grid for this service
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isMobile ? 2 : 4,
                                    crossAxisSpacing: isMobile ? 12.w : 30.w,
                                    mainAxisSpacing: isMobile ? 12.h : 30.h,
                                    childAspectRatio: isMobile ? 1.2 : 1.5,
                                  ),
                                  itemCount: logos.length,
                                  itemBuilder: (context, index) {
                                    return _buildLogoItem(
                                      context,
                                      logos[index],
                                      isMobile,
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  SizedBox(height: isMobile ? 40.h : 80.h),
                ],
              ),
            ),
            // App Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: isMobile
                  ? const CustomAppBarMob()
                  : const CustomAppBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoItem(BuildContext context, LogoModel logo, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 8.w : 16.w),
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withOpacity(0.4),
        borderRadius: BorderRadius.circular(isMobile ? 12.r : 20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Base64ImageWidget(
        base64String: logo.imageBase64,
                fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildLoadingState(bool isMobile) {
    // Create skeleton loading that mimics the actual layout
    final serviceNames = _serviceNameKeys.values.map((k) => k.tr(context)).toList();
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12.w : 40.w,
        vertical: 20.h,
      ),
      child: Column(
        children: [
          // Loading indicator with text
          Padding(
            padding: EdgeInsets.only(bottom: 40.h),
            child: Column(
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFFF4ED47),
                  strokeWidth: 3,
                ),
                SizedBox(height: 20.h),
                Text(
                  'LOADING_LOGOS'.tr(context),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: isMobile ? 14.sp : 18.sp,
                    fontFamily: getLocalizedFont(context, 'OptimalBold'),
                  ),
                ),
              ],
            ),
          ),
          // Skeleton placeholders for services
          ...List.generate(
            serviceNames.length > 3 ? 3 : serviceNames.length,
            (serviceIndex) {
              return Padding(
                padding: EdgeInsets.only(bottom: isMobile ? 30.h : 50.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service title skeleton
                    Container(
                      width: isMobile ? 150.w : 250.w,
                      height: isMobile ? 25.h : 40.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[800]!.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    SizedBox(height: isMobile ? 15.h : 25.h),
                    // Logos grid skeleton
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile ? 2 : 4,
                        crossAxisSpacing: isMobile ? 12.w : 30.w,
                        mainAxisSpacing: isMobile ? 12.h : 30.h,
                        childAspectRatio: isMobile ? 1.2 : 1.5,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return _buildSkeletonLogoItem(isMobile);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLogoItem(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 8.w : 16.w),
      decoration: BoxDecoration(
        color: Colors.grey[800]!.withOpacity(0.3),
        borderRadius: BorderRadius.circular(isMobile ? 12.r : 20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[700]!.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }
}

