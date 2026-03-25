import 'dart:async';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:incm/Modules/AllLogos/all_logos_screen.dart';
import 'package:provider/provider.dart';
import '../core/Language/locales.dart';
import '../core/Language/app_languages.dart';
import '../Utilities/font_helper.dart';
import 'package:incm/Modules/Career/career_screen.dart';
import 'package:incm/Modules/Lease/lease_screen.dart';
import 'package:incm/Modules/Sell/sell_screen.dart';
import '../Modules/About/about_screen.dart';
import '../Modules/Buy/buy_screen.dart';
import '../Modules/Home/home_screen.dart';
import '../Modules/Contacts/contacts_screen.dart';
import '../Modules/Services/Consultation/consultation_screen.dart';
import '../Modules/Services/CorporateLeasing/corporate_leasing_screen.dart';
import '../Modules/Services/FacilityManagement/facility_management_screen.dart';
import '../Modules/Services/FranchiseInvestment/franchise_investment_screen.dart';
import '../Modules/Services/Marketing/marketing_screen.dart';
import '../Modules/Services/MedicalLeasing/medical_leasing_screen.dart';
import '../Modules/Services/PrimaryInvestment/primary_investment_screen.dart';
import '../Modules/Services/RetailLeasing/retail_leasing_screen.dart';
import '../Modules/Admin/admin_panel_screen.dart';
import '../Modules/ExclusiveLeasingProjects/exclusive_leasing_projects_screen.dart';
import '../core/Content/services_provider.dart';
import '../generated/assets.dart';
import 'custom_button.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isMenuOpen = false;
  bool isServicesHovered = false;
  bool isDropdownHovered = false;
  final GlobalKey _servicesKey = GlobalKey();
  OverlayEntry? _servicesOverlay;
  Timer? _closeTimer;

  List<Map<String, String>> get services {
    final servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    final allServices = servicesProvider.allServices;
    final isArabic = Provider.of<AppLanguage>(context, listen: false).appLang == Languages.ar;
    return allServices.map((s) {
      final name = s.nameKey != null
          ? s.nameKey!.tr(context)
          : (isArabic ? s.nameAr : s.nameEn);
      return {'name': name, 'route': s.route};
    }).toList();
  }

  void _scrollToSection(String sectionId) {
    if (sectionId == 'home') {
      context.go(HomeScreen.routeName);
    }
    else if (sectionId == 'contacts') {
      context.go(ContactsScreen.routeName);
    }
  }

  void _showServicesDropdown() {
    if (_servicesOverlay != null) return; // Already shown
    
    // Cancel any existing close timer
    _closeTimer?.cancel();
    _closeTimer = null;
    
    final RenderBox? renderBox = _servicesKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _servicesOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: position.dy + size.height + 2.h,
          left: position.dx + (size.width / 2) - 125.w,
          child: Material(
            elevation: 10,
            color: Colors.transparent,
            child: MouseRegion(
              onEnter: (_) {
                // Cancel close timer when mouse enters dropdown
                _closeTimer?.cancel();
                _closeTimer = null;
                setState(() {
                  isDropdownHovered = true;
                  isServicesHovered = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isDropdownHovered = false;
                  isServicesHovered = false; // Leave Services area → close menu
                });
                // Close dropdown when mouse leaves Services area (trigger or dropdown)
                _scheduleClose();
              },
              child: Container(
                width: 250.w,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - position.dy - size.height - 20.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xFFF4ED47).withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...services.asMap().entries.map((entry) {
                      final index = entry.key;
                      final service = entry.value;
                      final isLast = index == services.length - 1;
                      return _ServicesDropdownItem(
                        serviceName: service['name']!,
                        onTap: () {
                          _hideServicesDropdown();
                          context.go(service['route']!);
                        },
                        showBorder: !isLast,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_servicesOverlay!);
  }

  void _scheduleClose() {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(milliseconds: 150), () {
      if (mounted && !isDropdownHovered && !isServicesHovered) {
        _hideServicesDropdown();
      }
    });
  }

  void _hideServicesDropdown() {
    _closeTimer?.cancel();
    _closeTimer = null;
    _servicesOverlay?.remove();
    _servicesOverlay = null;
    if (mounted) {
      setState(() {
        isServicesHovered = false;
        isDropdownHovered = false;
      });
    }
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    _hideServicesDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Overlay to close menu when clicking outside
        if (isMenuOpen && MediaQuery.of(context).size.width <= 768)
          Positioned.fill(
            top: 80.h,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isMenuOpen = false;
                });
              },
              child: AnimatedOpacity(
                opacity: isMenuOpen ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          ),

        // App Bar
        SafeArea(
          bottom: false,
          child: Container(
            height: 80.h,
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                // Logo Section (Left) - INCOMERCIAL with tagline
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                      onTap: () => _scrollToSection('home'),
                      child: Image.asset(Assets.imagesIncomercialLogo, width: 400.w,height: 100.h,fit: BoxFit.cover,)
                  ),
                ),


                // Desktop Menu Items (Center) with separators
                if (MediaQuery.of(context).size.width > 768)
                  Expanded(
                    flex: 14,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMenuItemWithSeparator('HOME'.tr(context), true, () {context.go(HomeScreen.routeName);}),
                        _buildMenuItemWithSeparator('ABOUT_US'.tr(context), true, () {context.go(AboutScreen.routeName);}),
                        _buildServicesMenuItem(),
                        _buildMenuItemWithSeparator('BUY'.tr(context), true, () {context.go(BuyScreen.routeName);}),
                        _buildMenuItemWithSeparator('SELL'.tr(context), true, () {context.go(SellScreen.routeName);}),
                        _buildMenuItemWithSeparator('LEASE'.tr(context), true, () {context.go(LeaseScreen.routeName);}),
                        _buildMenuItemWithSeparator('EXCLUSIVE_LEASING_PROJECTS'.tr(context), true, () {context.go(ExclusiveLeasingProjectsScreen.routeName);}),
                        _buildMenuItemWithSeparator('OUR_CLIENTS'.tr(context), true, () {context.go(AllLogosScreen.routeName);}),
                        _buildMenuItemWithSeparator('CAREERS'.tr(context), false, () {context.go(CareerScreen.routeName);}),
                      ],
                    ),
                  ),

                // Language Toggle & Contact Button (Right side)
                if (MediaQuery.of(context).size.width > 768)
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Language Toggle Button
                        Consumer<AppLanguage>(
                          builder: (context, appLanguage, _) {
                            return InkWell(
                              onTap: () {
                                appLanguage.changeLanguage();
                              },
                              child: Container(
                                height: 36.sp,
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4ED47).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(
                                    color: const Color(0xFFF4ED47),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  appLanguage.appLang == Languages.ar ? 'EN' : 'AR',
                                  style: TextStyle(
                                    color: const Color(0xFFF4ED47),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 8.w),
                        // Contact Us Button
                        ButtonStyles.exploreUsButton(
                          context: context,
                          onPressed: () => _scrollToSection('contacts'),
                        ),
                      ],
                    ),
                  ),

                SizedBox(width: MediaQuery.of(context).size.width > 768 ? 32.w : 16.w),

                // Mobile Menu Button (Right)
                if (MediaQuery.of(context).size.width <= 768)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isMenuOpen = !isMenuOpen;
                      });
                    },
                    icon: Icon(
                      isMenuOpen ? Icons.close : Icons.menu,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

      // Side Menu (Mobile)
        if (MediaQuery.of(context).size.width <= 768)
          _buildSideMenu(context),
      ],
    );
  }

  Widget _buildSideMenu(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      top: 80.h,
      right: isMenuOpen ? 0 : -280.w,
      bottom: 0,
      width: 280.w,
      child: GestureDetector(
        onTap: () {}, // Prevent closing when tapping inside menu
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.98),
                Colors.black.withOpacity(0.95),
              ],
            ),
            border: Border(
              left: BorderSide(
                color: const Color(0xFFF4ED47).withOpacity(0.3),
                width: 2,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(-5, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Menu Header
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFF4ED47).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu,
                      color: const Color(0xFFF4ED47),
                      size: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'MENU'.tr(context),
                      style: TextStyle(
                        fontFamily: getLocalizedFont(context, 'OptimalBold'),
                        color: const Color(0xFFF4ED47),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  children: [
                    _buildSideMenuItem('HOME'.tr(context), Icons.home, 'home', (){ 
                      setState(() => isMenuOpen = false);
                      context.go(HomeScreen.routeName);
                    }),
                    _buildSideMenuItem('ABOUT_US'.tr(context), Icons.info, 'about', () { 
                      setState(() => isMenuOpen = false);
                      context.go(AboutScreen.routeName);
                    }),
                    _buildSideMenuItem('SERVICES'.tr(context), Icons.work, 'services', () {}),
                    _buildSideMenuItem('EXCLUSIVE_LEASING_PROJECTS'.tr(context), Icons.apartment, 'exclusive', () {
                      setState(() => isMenuOpen = false);
                      context.go(ExclusiveLeasingProjectsScreen.routeName);
                    }),
                    _buildSideMenuItem('CONTACTS'.tr(context), Icons.contact_phone, 'contacts',() {}),
                    // Admin Panel (only in debug mode or for development)
                    if (kDebugMode)
                      _buildSideMenuItem('ADMIN_PANEL'.tr(context), Icons.admin_panel_settings, 'admin', () {
                        setState(() => isMenuOpen = false);
                        context.go(AdminPanelScreen.routeName);
                      }),
                    // Language Toggle
                    Consumer<AppLanguage>(
                      builder: (context, appLanguage, _) {
                        return _buildSideMenuItem(
                          appLanguage.appLang == Languages.ar ? 'EN' : 'AR',
                          Icons.language,
                          'language',
                          () {
                            appLanguage.changeLanguage();
                            setState(() {
                              isMenuOpen = false;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            const Color(0xFFF4ED47).withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'INCM_REAL_ESTATE'.tr(context),
                      style: TextStyle(
                        fontFamily: 'Optimal',
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSideMenuItem(String text, IconData icon, String sectionId, VoidCallback? onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: ()=> onTap,
        splashColor: const Color(0xFFF4ED47).withOpacity(0.2),
        highlightColor: const Color(0xFFF4ED47).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4ED47).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFF4ED47),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Optimal',
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: const Color(0xFFF4ED47).withOpacity(0.6),
                size: 14.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildMenuItemWithSeparator(String text, bool showSeparator,  VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _HoverMenuItem(
            text: text,
            onTap: onTap,
          ),
          if (showSeparator) ...[
            SizedBox(width: 20.w),
            Container(
              height: 12.h,
              width: 2.w,
              color: const Color(0xFFF4ED47),
            ),
            SizedBox(width: 20.w),
          ],
        ],
      ),
    );
  }

  Widget _buildServicesMenuItem() {
    return MouseRegion(
      key: _servicesKey,
      onEnter: (_) {
        // Cancel any existing close timer
        _closeTimer?.cancel();
        _closeTimer = null;
        setState(() => isServicesHovered = true);
        if (MediaQuery.of(context).size.width > 768) {
          _showServicesDropdown();
        }
      },
      onExit: (_) {
        setState(() => isServicesHovered = false);
        // Schedule close if mouse is not on dropdown
        _scheduleClose();
      },
      child: InkWell(
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _HoverMenuItem(
              text: 'SERVICES'.tr(context),
              onTap: () {},
            ),
            SizedBox(width: 20.w),
            Container(
              height: 12.h,
              width: 2.w,
              color: const Color(0xFFF4ED47),
            ),
            SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }

}

// Hover Menu Item Widget
class _HoverMenuItem extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _HoverMenuItem({
    required this.text,
    required this.onTap,
  });

  @override
  State<_HoverMenuItem> createState() => _HoverMenuItemState();
}

class _HoverMenuItemState extends State<_HoverMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -2.0, 0.0))
              : Matrix4.identity(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  fontFamily: 'AloeveraDisplay',
                  color: _isHovered ? const Color(0xFFC63424) : Colors.white,
                  fontSize: 20.sp,
                  fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w500
                ),
                child: Text(widget.text),
              ),
              SizedBox(height: 4.h),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 2.h,
                width: _isHovered ? 40.w : 0,
                decoration: BoxDecoration(
                  color: const Color(0xFFC63424),
                  borderRadius: BorderRadius.circular(1.r),
                  boxShadow: _isHovered
                      ? [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Services Dropdown Item Widget
class _ServicesDropdownItem extends StatefulWidget {
  final String serviceName;
  final VoidCallback onTap;
  final bool showBorder;

  const _ServicesDropdownItem({
    required this.serviceName,
    required this.onTap,
    required this.showBorder,
  });

  @override
  State<_ServicesDropdownItem> createState() => _ServicesDropdownItemState();
}

class _ServicesDropdownItemState extends State<_ServicesDropdownItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFFF4ED47).withOpacity(0.1) : Colors.transparent,
            border: widget.showBorder
                ? Border(
                    bottom: BorderSide(
                      color: const Color(0xFFF4ED47).withOpacity(0.1),
                      width: 0.5,
                    ),
                  )
                : null,
          ),
          child: Text(
            widget.serviceName.toUpperCase(),
            style: TextStyle(
              fontFamily: 'AloeveraDisplay',
              color: _isHovered ? const Color(0xFFF4ED47) : Colors.white,
              fontSize: 16.sp,
              fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}