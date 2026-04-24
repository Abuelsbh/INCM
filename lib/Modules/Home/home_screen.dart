import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rush/rush.dart';
import '../../Modules/AllLogos/all_logos_screen.dart';
import '../../Modules/ExclusiveLeasingProjects/exclusive_leasing_projects_screen.dart';
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
import '../../Widgets/home_media_section.dart';
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
import '../../core/Language/locales.dart';
import '../../core/Contact/contact_info_provider.dart';
import '../../core/responsive/native_layout.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactInfoProvider>().fetchContactInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 600;

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          bottomNavigationBar: useNativeBottomNavigationBar(context) ? const BottomNavBarWidget(selected: SelectedBottomNavBar.home) : null,
          body: isDesktop ? Stack(
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
                      // صورة/فيديو من الداشبورد — يظهر فقط لو تمت إضافته
                      const HomeMediaSection(),
                      // About Us Section
                      const AboutContentSection(),
                      //SizedBox(height: 100.h),
                      // Exclusive Projects Section — logos from Firebase for this page only
                      Container(
                        height: 380.h,
                        margin: EdgeInsets.all(12.w),
                        child: ClientsLogosSection(
                          title: 'OUR_EXCLUSIVE_PROJECTS',
                          exclusiveLeasingProjectLogosFromContent: true,
                          fetchAllServices: false,
                          backgroundColor: Colors.grey[900]!,
                          visibleLogosCount: 5,
                          onLearnMorePressed: () {
                            context.go(ExclusiveLeasingProjectsScreen.routeName);
                          },
                        ),
                      ),
                      // Services Section
                      const ServicesContentSection(),
                      // Performance Highlights Section
                      const PerformanceHighlightsSection(),
                      //SizedBox(height: 100.h),
                      Container(
                        height: 380.h,
                        margin: EdgeInsets.all(12.w),
                        child: ClientsLogosSection(
                          backgroundColor: Colors.grey[900]!,
                          fetchAllServices: true, // Fetch logos from Firebase from all 8 services
                          visibleLogosCount: 5,
                          onLearnMorePressed: () {
                            context.go(AllLogosScreen.routeName);
                          },
                        ),
                      ),

                      //SizedBox(height: 100.h),

                      // Contacts Section
                      const ContactsContentSection(),
                      //SizedBox(height: 50.h),

                      // Animated Logos Footer
                      //const AnimatedLogosFooterV2(),
                      if (kIsWeb) const FooterSection()
                    ],
                  ),
                ),
              ),

              // ✅ الـAppBar: ويب واسع = شريط الموقع، تطبيق أصلي/موبايل ويب = شريط التطبيق
              useWebDesktopAppBar(context)
              ? const Positioned(
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
                      const HomeMediaSection(),
                      const AboutContentSectionMob(),
                      // Exclusive Projects Section — logos from Firebase for this page only
                      Container(
                        height: 210.h,
                        margin: EdgeInsets.all(12.w),
                        child: ClientsLogosSection(
                          title: 'OUR_EXCLUSIVE_PROJECTS',
                          exclusiveLeasingProjectLogosFromContent: true,
                          fetchAllServices: false,
                          backgroundColor: Colors.grey[900]!,
                          visibleLogosCount: 5,
                          onLearnMorePressed: () {
                            context.go(ExclusiveLeasingProjectsScreen.routeName);
                          },
                        ),
                      ),
                      const ServicesContentSectionMob(),
                      const PerformanceHighlightsSectionMob(),
                      //const AnimatedLogosFooterV2(),
                      Container(
                        height: 210.h,
                        margin: EdgeInsets.all(12.w),
                        child: ClientsLogosSection(
                          backgroundColor: Colors.grey[900]!,
                          fetchAllServices: true, // Fetch logos from Firebase from all 8 services
                          visibleLogosCount: 5,
                          onLearnMorePressed: () {
                            context.go(AllLogosScreen.routeName);
                          },
                        ),
                      ),
                      const ContactsContentSectionMob(),
                      if(kIsWeb)
                        const FooterSectionMob()
                    ],
                  ),
                ),
              ),

              // ✅ الـAppBar: ويب واسع = شريط الموقع، تطبيق أصلي/موبايل ويب = شريط التطبيق
              useWebDesktopAppBar(context)
              ? const Positioned(
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