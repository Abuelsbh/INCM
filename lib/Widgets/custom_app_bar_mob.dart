import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/Language/locales.dart';
import '../core/Language/app_languages.dart';
import '../Modules/About/about_screen.dart';
import '../Modules/Buy/buy_screen.dart';
import '../Modules/Career/career_screen.dart';
import '../Modules/Home/home_screen.dart';
import '../Modules/Contacts/contacts_screen.dart';
import '../Modules/Lease/lease_screen.dart';
import '../Modules/Sell/sell_screen.dart';
import '../Modules/Services/Consultation/consultation_screen.dart';
import '../Modules/Services/CorporateLeasing/corporate_leasing_screen.dart';
import '../Modules/Services/FacilityManagement/facility_management_screen.dart';
import '../Modules/Services/FranchiseInvestment/franchise_investment_screen.dart';
import '../Modules/Services/Marketing/marketing_screen.dart';
import '../Modules/Services/MedicalLeasing/medical_leasing_screen.dart';
import '../Modules/Services/PrimaryInvestment/primary_investment_screen.dart';
import '../Modules/Services/RetailLeasing/retail_leasing_screen.dart';
import '../generated/assets.dart';
import 'custom_button.dart';

class CustomAppBarMob extends StatefulWidget {
  const CustomAppBarMob({super.key});

  @override
  State<CustomAppBarMob> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBarMob> with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  bool isServicesExpanded = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  List<Map<String, String>> get services {
    return [
      {'name': 'CORPORATE_LEASING'.tr, 'route': CorporateLeasingScreen.routeName},
      {'name': 'CONSULTATION'.tr, 'route': ConsultationScreen.routeName},
      {'name': 'MARKETING'.tr, 'route': MarketingScreen.routeName},
      {'name': 'MEDICAL_LEASING'.tr, 'route': MedicalLeasingScreen.routeName},
      {'name': 'FACILITY_MANAGEMENT'.tr, 'route': FacilityManagementScreen.routeName},
      {'name': 'PRIMARY_INVESTMENT'.tr, 'route': PrimaryInvestmentScreen.routeName},
      {'name': 'RETAIL_LEASING'.tr, 'route': RetailLeasingScreen.routeName},
      {'name': 'FRANCHISE_INVESTMENT'.tr, 'route': FranchiseInvestmentScreen.routeName},
    ];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
      if (isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        isServicesExpanded = false; // Reset services expansion when menu closes
      }
    });
  }

  void _toggleServices() {
    setState(() {
      isServicesExpanded = !isServicesExpanded;
    });
  }

  void _navigateTo(String route) {
    _toggleMenu();
    Future.delayed(const Duration(milliseconds: 300), () {
      context.go(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFF4ED47).withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo Section
                    GestureDetector(
                      onTap: () => context.go(HomeScreen.routeName),
                      child: Image.asset(
                        kIsWeb ? Assets.imagesINCMLogo : Assets.imagesINCMLogoMob,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        width: kIsWeb ? 100.w : 50.w,
                      ),
                    ),
                    const Spacer(),

                    // Explore Us Button (Web only)
                    if (kIsWeb) ButtonStyles.getAppButton(
                        onPressed: () => {},
                        width: 55.w
                    ),
                    if (kIsWeb) SizedBox(width: 16.w),

                    // Menu Icon
                    InkWell(
                      onTap: _toggleMenu,
                      child: Icon(
                        isMenuOpen ? Icons.close : Icons.menu,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),

        // Slide-out Menu
        if (isMenuOpen)
          GestureDetector(
            onTap: _toggleMenu,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
            ),
          ),

        SlideTransition(
          position: _slideAnimation,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 280.w,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a1a),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(-5, 0),
                  ),
                ],
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with logo and language toggle
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xFFF4ED47).withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'AR_EN'.tr,
                              style: TextStyle(
                                color: const Color(0xFFF4ED47),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Language Toggle Button
                            // Consumer<AppLanguage>(
                            //   builder: (context, appLanguage, _) {
                            //     return InkWell(
                            //       onTap: () {
                            //         appLanguage.changeLanguage();
                            //       },
                            //       child: Container(
                            //         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            //         decoration: BoxDecoration(
                            //           color: const Color(0xFFF4ED47).withOpacity(0.2),
                            //           borderRadius: BorderRadius.circular(6.r),
                            //           border: Border.all(
                            //             color: const Color(0xFFF4ED47),
                            //             width: 1,
                            //           ),
                            //         ),
                            //         child: Text(
                            //           appLanguage.appLang == Languages.ar ? 'EN' : 'AR',
                            //           style: TextStyle(
                            //             color: const Color(0xFFF4ED47),
                            //             fontSize: 14.sp,
                            //             fontWeight: FontWeight.bold,
                            //             letterSpacing: 1,
                            //           ),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                      // Menu Items
                      _buildMenuItem('HOME'.tr, () => context.go(HomeScreen.routeName)),
                      _buildMenuItem('ABOUT_US'.tr, () => context.go(AboutScreen.routeName)),
                      _buildMenuItem('SERVICES'.tr, _toggleServices, hasDropdown: true),

                      // Services Submenu
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: isServicesExpanded ? services.length * 50.h : 0,
                        child: ClipRect(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: services.length,
                            itemBuilder: (context, index) {
                              return _buildSubMenuItem(
                                services[index]['name']!,
                                    () => _navigateTo(services[index]['route']!),
                              );
                            },
                          ),
                        ),
                      ),

                      _buildMenuItem('BUY'.tr, () => context.go(BuyScreen.routeName)),
                      _buildMenuItem('SELL'.tr, () => context.go(SellScreen.routeName)),
                      _buildMenuItem('CAREERS'.tr, () => context.go(CareerScreen.routeName)),
                      _buildMenuItem('CONTACT_US'.tr, () => _navigateTo(ContactsScreen.routeName)),
                      _buildMenuItem('LEASE'.tr, () => context.go(LeaseScreen.routeName)),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap, {bool hasDropdown = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Text(
              '- $title',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
            if (hasDropdown) ...[
              const Spacer(),
              AnimatedRotation(
                turns: isServicesExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubMenuItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 13.sp,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}