import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rush/rush.dart';
import '../../Widgets/about_content_section_mob.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/contacts_content_section_mob.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../Widgets/footer_section.dart';
import '../../Widgets/footer_section_mob.dart';
import '../../Widgets/home_search_section_mob.dart';
import '../../Widgets/home_welcome_section.dart';
import '../../Widgets/home_search_section.dart';
import '../../Widgets/about_content_section.dart';
import '../../Widgets/performance_highlights_section.dart';
import '../../Widgets/performance_highlights_section_mob.dart';
import '../../Widgets/services_content_section.dart';
import '../../Widgets/contacts_content_section.dart';
import '../../Widgets/animated_logos_footer.dart';
import '../../Widgets/services_content_section_mob.dart';
import '../../Widgets/floating_contact_buttons.dart';
import '../../Widgets/scroll_to_top_button.dart';

// Global key for accessing scroll controller
final GlobalKey<_HomeScreenState> homeScreenKey = GlobalKey<_HomeScreenState>();

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  HomeScreen({Key? key}) : super(key: key ?? homeScreenKey);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  
  // Static method to scroll to section
  static void scrollToSection(String sectionId) {
    homeScreenKey.currentState?._scrollToSection(sectionId);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  
  // Keys for each section
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _contactsKey = GlobalKey();

  void _scrollToSection(String sectionId) {
    GlobalKey? targetKey;
    
    switch (sectionId) {
      case 'home':
        targetKey = _homeKey;
        break;
      case 'about':
        targetKey = _aboutKey;
        break;
      case 'services':
        targetKey = _servicesKey;
        break;
      case 'contacts':
        targetKey = _contactsKey;
        break;
    }
    
    if (targetKey?.currentContext != null) {
      // Add small delay to ensure layout is complete
      Future.delayed(const Duration(milliseconds: 100), () {
        if (targetKey?.currentContext != null) {
          Scrollable.ensureVisible(
            targetKey!.currentContext!,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            alignment: 0.0, // Scroll to top of section
          );
        }
      });
    } else {
      // If context not available, try scrolling using scroll controller
      Future.delayed(const Duration(milliseconds: 100), () {
        double offset = 0;
        switch (sectionId) {
          case 'home':
            offset = 0;
            break;
          case 'about':
            offset = 800.h;
            break;
          case 'services':
            offset = 1800.h;
            break;
          case 'contacts':
            offset = 2800.h;
            break;
        }
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: MediaQuery.of(context).size.width < 600 && !kIsWeb ? const BottomNavBarWidget(selected: SelectedBottomNavBar.home) : null,
        body: MediaQuery.of(context).size.width >= 600 ? Stack(
          children: [
            // المحتوى القابل للتمرير
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  // هنا تقدر تحدد الأجهزة المسموح لها بالـscroll
                  PointerDeviceKind.touch, // تسمح باللمس فقط، وتمنع الماوس
                },
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Home Section
                    // Container(
                    //   key: _homeKey,
                    //   child: const HomeWelcomeSection(),
                    // ),
                    //SizedBox(height: 100.h),
                    const HomeSearchSection(),
                    //SizedBox(height: 100.h),
      
                    // About Us Section
                    Container(
                      key: _aboutKey,
                      child: const AboutContentSection(),
                    ),
                    //SizedBox(height: 100.h),
                    // Services Section
                    Container(
                      key: _servicesKey,
                      child: const ServicesContentSection(),
                    ),
                    // Performance Highlights Section
                    const PerformanceHighlightsSection(),
                    //SizedBox(height: 100.h),
                    const AnimatedLogosFooterV2(),

                    //SizedBox(height: 100.h),
      
                    // Contacts Section
                    Container(
                      key: _contactsKey,
                      child: const ContactsContentSection(),
                    ),
                    //SizedBox(height: 50.h),
      
                    // Animated Logos Footer
                    //const AnimatedLogosFooterV2(),
                    const FooterSection()
                  ],
                ),
              ),
            ),
      
            // ✅ الـAppBar الشفاف فوق الكل
            MediaQuery.of(context).size.width >= 600 ?
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBar(),
            ) : const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBarMob(),
            ),
            
            // الأيقونات الثابتة للتواصل
            const FloatingContactButtons(),
            
            // زر العودة لأعلى الصفحة
            ScrollToTopButton(scrollController: _scrollController),
          ],
        ) : Stack(
          children: [
            // المحتوى القابل للتمرير
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  // هنا تقدر تحدد الأجهزة المسموح لها بالـscroll
                  PointerDeviceKind.touch, // تسمح باللمس فقط، وتمنع الماوس
                },
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const HomeSearchSectionMob(),
                    Container(
                      key: _aboutKey,
                      child: const AboutContentSectionMob(),
                    ),
                    Container(
                      key: _servicesKey,
                      child: const ServicesContentSectionMob(),
                    ),
                    const PerformanceHighlightsSectionMob(),
                    const AnimatedLogosFooterV2(),

                    Container(
                      key: _contactsKey,
                      child: const ContactsContentSectionMob(),
                    ),
                    if(kIsWeb)
                      const FooterSectionMob()
                  ],
                ),
              ),
            ),
      
            // ✅ الـAppBar الشفاف فوق الكل
            MediaQuery.of(context).size.width >= 600 ?
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBar(),
            ) : const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBarMob(),
            ),
            
            // الأيقونات الثابتة للتواصل
            const FloatingContactButtons(),
            
            // زر العودة لأعلى الصفحة
            ScrollToTopButton(scrollController: _scrollController),
          ],
        )
      
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}