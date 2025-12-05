import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rush/rush.dart';
import 'package:go_router/go_router.dart';
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
import '../../Widgets/custom_button.dart';
import '../../Utilities/router_config.dart';
import '../../Modules/AllLogos/all_logos_screen.dart';

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
                      margin: EdgeInsets.all(12.w),
                      child: ClientsLogosSection(
                        backgroundColor: Colors.grey[900]!,
                        logos: const [
                          // Consultation logos (40)
                          Assets.logosConsultation1,
                          Assets.logosConsultation2,
                          Assets.logosConsultation3,
                          Assets.logosConsultation4,
                          Assets.logosConsultation5,
                          Assets.logosConsultation6,
                          Assets.logosConsultation7,
                          Assets.logosConsultation8,
                          Assets.logosConsultation9,
                          Assets.logosConsultation10,
                          Assets.logosConsultation11,
                          Assets.logosConsultation12,
                          Assets.logosConsultation13,
                          Assets.logosConsultation14,
                          Assets.logosConsultation15,
                          Assets.logosConsultation16,
                          Assets.logosConsultation17,
                          Assets.logosConsultation18,
                          Assets.logosConsultation19,
                          Assets.logosConsultation20,
                          Assets.logosConsultation21,
                          Assets.logosConsultation22,
                          Assets.logosConsultation23,
                          Assets.logosConsultation24,
                          Assets.logosConsultation25,
                          Assets.logosConsultation26,
                          Assets.logosConsultation27,
                          Assets.logosConsultation28,
                          Assets.logosConsultation29,
                          Assets.logosConsultation30,
                          Assets.logosConsultation31,
                          Assets.logosConsultation32,
                          Assets.logosConsultation33,
                          Assets.logosConsultation34,
                          Assets.logosConsultation35,
                          Assets.logosConsultation36,
                          Assets.logosConsultation37,
                          Assets.logosConsultation38,
                          Assets.logosConsultation39,
                          Assets.logosConsultation40,
                          // Facility logos (29)
                          Assets.logosFacilityAisle,
                          Assets.logosFacilityAriana,
                          Assets.logosFacilityAttracta,
                          Assets.logosFacilityB,
                          Assets.logosFacilityBreakYard,
                          Assets.logosFacilityCapitaal,
                          Assets.logosFacilityCapital,
                          Assets.logosFacilityCloudnine,
                          Assets.logosFacilityEleven,
                          Assets.logosFacilityFive,
                          Assets.logosFacilityGar,
                          Assets.logosFacilityGlitz,
                          Assets.logosFacilityItiz,
                          Assets.logosFacilityJaya,
                          Assets.logosFacilityKernel,
                          Assets.logosFacilityMall,
                          Assets.logosFacilityNeux,
                          Assets.logosFacilityNova,
                          Assets.logosFacilityRayan,
                          Assets.logosFacilitySee90,
                          Assets.logosFacilitySolaria,
                          Assets.logosFacilityStar,
                          Assets.logosFacilityTerrace,
                          Assets.logosFacilityUmc,
                          Assets.logosFacilityV,
                          Assets.logosFacilityVitali,
                          Assets.logosFacilityVocoMall,
                          Assets.logosFacilityZoom,
                          Assets.logosFacilityUntitled1,
                          Assets.logosFacilityNabed,
                          // Franchise logos (14)
                          Assets.logosFranchise2,
                          Assets.logosFranchise3,
                          Assets.logosFranchise4,
                          Assets.logosFranchise5,
                          Assets.logosFranchise6,
                          Assets.logosFranchise7,
                          Assets.logosFranchise8,
                          Assets.logosFranchise9,
                          Assets.logosFranchise10,
                          Assets.logosFranchise11,
                          Assets.logosFranchise12,
                          Assets.logosFranchise13,
                          Assets.logosFranchise14,
                          Assets.logosFranchiseUntitled1,
                          // Primary logos (12)
                          Assets.logosPrimary1,
                          Assets.logosPrimary2,
                          Assets.logosPrimary3,
                          Assets.logosPrimary4,
                          Assets.logosPrimary5,
                          Assets.logosPrimary6,
                          Assets.logosPrimary7,
                          Assets.logosPrimary8,
                          Assets.logosPrimary9,
                          Assets.logosPrimary10,
                          Assets.logosPrimary11,
                          Assets.logosPrimary12,
                          // Retail logos (9)
                          Assets.logosRetail1,
                          Assets.logosRetail2,
                          Assets.logosRetail3,
                          Assets.logosRetail4,
                          Assets.logosRetail5,
                          Assets.logosRetail6,
                          Assets.logosRetail7,
                          Assets.logosRetail8,
                          Assets.logosRetail9,
                          // Marketing logos (6)
                          Assets.logosMarketing1,
                          Assets.logosMarketing2,
                          Assets.logosMarketing3,
                          Assets.logosMarketing4,
                          Assets.logosMarketing5,
                          Assets.logosMarketing6,
                        ],
                        visibleLogosCount: 5,
                      ),
                    ),
                    // Learn More Button
                    Padding(
                      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                      child: ButtonStyles.learnMoreButton(
                        onPressed: () {
                          GoRouter.of(context).push(AllLogosScreen.routeName);
                        },
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
                      height: 180.h,
                      margin: EdgeInsets.all(12.w),
                      child: ClientsLogosSection(
                        backgroundColor: Colors.grey[900]!,
                        logos: [
                          // Consultation logos (40)
                          Assets.logosConsultation1,
                          Assets.logosConsultation2,
                          Assets.logosConsultation3,
                          Assets.logosConsultation4,
                          Assets.logosConsultation5,
                          Assets.logosConsultation6,
                          Assets.logosConsultation7,
                          Assets.logosConsultation8,
                          Assets.logosConsultation9,
                          Assets.logosConsultation10,
                          Assets.logosConsultation11,
                          Assets.logosConsultation12,
                          Assets.logosConsultation13,
                          Assets.logosConsultation14,
                          Assets.logosConsultation15,
                          Assets.logosConsultation16,
                          Assets.logosConsultation17,
                          Assets.logosConsultation18,
                          Assets.logosConsultation19,
                          Assets.logosConsultation20,
                          Assets.logosConsultation21,
                          Assets.logosConsultation22,
                          Assets.logosConsultation23,
                          Assets.logosConsultation24,
                          Assets.logosConsultation25,
                          Assets.logosConsultation26,
                          Assets.logosConsultation27,
                          Assets.logosConsultation28,
                          Assets.logosConsultation29,
                          Assets.logosConsultation30,
                          Assets.logosConsultation31,
                          Assets.logosConsultation32,
                          Assets.logosConsultation33,
                          Assets.logosConsultation34,
                          Assets.logosConsultation35,
                          Assets.logosConsultation36,
                          Assets.logosConsultation37,
                          Assets.logosConsultation38,
                          Assets.logosConsultation39,
                          Assets.logosConsultation40,
                          // Facility logos (29)
                          Assets.logosFacilityAisle,
                          Assets.logosFacilityAriana,
                          Assets.logosFacilityAttracta,
                          Assets.logosFacilityB,
                          Assets.logosFacilityBreakYard,
                          Assets.logosFacilityCapitaal,
                          Assets.logosFacilityCapital,
                          Assets.logosFacilityCloudnine,
                          Assets.logosFacilityEleven,
                          Assets.logosFacilityFive,
                          Assets.logosFacilityGar,
                          Assets.logosFacilityGlitz,
                          Assets.logosFacilityItiz,
                          Assets.logosFacilityJaya,
                          Assets.logosFacilityKernel,
                          Assets.logosFacilityMall,
                          Assets.logosFacilityNeux,
                          Assets.logosFacilityNova,
                          Assets.logosFacilityRayan,
                          Assets.logosFacilitySee90,
                          Assets.logosFacilitySolaria,
                          Assets.logosFacilityStar,
                          Assets.logosFacilityTerrace,
                          Assets.logosFacilityUmc,
                          Assets.logosFacilityV,
                          Assets.logosFacilityVitali,
                          Assets.logosFacilityVocoMall,
                          Assets.logosFacilityZoom,
                          Assets.logosFacilityUntitled1,
                          Assets.logosFacilityNabed,
                          // Franchise logos (14)
                          Assets.logosFranchise2,
                          Assets.logosFranchise3,
                          Assets.logosFranchise4,
                          Assets.logosFranchise5,
                          Assets.logosFranchise6,
                          Assets.logosFranchise7,
                          Assets.logosFranchise8,
                          Assets.logosFranchise9,
                          Assets.logosFranchise10,
                          Assets.logosFranchise11,
                          Assets.logosFranchise12,
                          Assets.logosFranchise13,
                          Assets.logosFranchise14,
                          Assets.logosFranchiseUntitled1,
                          // Primary logos (12)
                          Assets.logosPrimary1,
                          Assets.logosPrimary2,
                          Assets.logosPrimary3,
                          Assets.logosPrimary4,
                          Assets.logosPrimary5,
                          Assets.logosPrimary6,
                          Assets.logosPrimary7,
                          Assets.logosPrimary8,
                          Assets.logosPrimary9,
                          Assets.logosPrimary10,
                          Assets.logosPrimary11,
                          Assets.logosPrimary12,
                          // Retail logos (9)
                          Assets.logosRetail1,
                          Assets.logosRetail2,
                          Assets.logosRetail3,
                          Assets.logosRetail4,
                          Assets.logosRetail5,
                          Assets.logosRetail6,
                          Assets.logosRetail7,
                          Assets.logosRetail8,
                          Assets.logosRetail9,
                          // Marketing logos (6)
                          Assets.logosMarketing1,
                          Assets.logosMarketing2,
                          Assets.logosMarketing3,
                          Assets.logosMarketing4,
                          Assets.logosMarketing5,
                          Assets.logosMarketing6,
                        ],
                        visibleLogosCount: 5,
                      ),
                    ),
                    // Learn More Button (Mobile)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                      child: ButtonStyles.learnMoreButtonMob(
                        onPressed: () {
                          GoRouter.of(context).push(AllLogosScreen.routeName);
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