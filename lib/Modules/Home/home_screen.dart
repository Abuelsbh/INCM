import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rush/rush.dart';
import '../../Widgets/about_content_section_mob.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/clients_logos_section.dart';
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
import '../../generated/assets.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

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
                    const AboutContentSection(),
                    //SizedBox(height: 100.h),
                    // Services Section
                    const ServicesContentSection(),
                    // Performance Highlights Section
                    const PerformanceHighlightsSection(),
                    //SizedBox(height: 100.h),
                    Container(
                      height: 280.h,
                      margin: EdgeInsets.all(24.w),
                      child: ClientsLogosSection(
                        backgroundColor: Colors.grey[900]!,
                        logos: [
                          Assets.logosLogo2,
                          Assets.logosLogo3,
                          Assets.logosLogo4,
                          Assets.logosLogo6,
                          Assets.logosLogo2,
                          Assets.logosLogo2,
                          Assets.logosLogo3,
                          Assets.logosLogo4,
                          Assets.logosLogo6,
                          Assets.logosLogo2,
                        ],
                        visibleLogosCount: 5,
                      ),
                    ),

                    //SizedBox(height: 100.h),
      
                    // Contacts Section
                    const ContactsContentSection(),
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
                    const AboutContentSectionMob(),
                    const ServicesContentSectionMob(),
                    const PerformanceHighlightsSectionMob(),
                    //const AnimatedLogosFooterV2(),
                    Container(
                      height: 140.h,
                      margin: EdgeInsets.all(24.w),
                      child: ClientsLogosSection(
                        backgroundColor: Colors.grey[900]!,
                        logos: [
                          Assets.logosLogo2,
                          Assets.logosLogo3,
                          Assets.logosLogo4,
                          Assets.logosLogo6,
                          Assets.logosLogo2,
                          Assets.logosLogo2,
                          Assets.logosLogo3,
                          Assets.logosLogo4,
                          Assets.logosLogo6,
                          Assets.logosLogo2,
                        ],
                        visibleLogosCount: 5,
                      ),
                    ),
                    const ContactsContentSectionMob(),
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