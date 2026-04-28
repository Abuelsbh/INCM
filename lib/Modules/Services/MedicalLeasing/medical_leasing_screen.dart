import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../../Widgets/bottom_navbar_widget.dart';
import '../../../Widgets/clients_logos_section.dart';
import '../../../Widgets/content_service_section.dart';
import '../../../Widgets/custom_app_bar.dart';
import '../../../Widgets/custom_app_bar_mob.dart';
import '../../../Widgets/floating_contact_buttons.dart';
import '../../../Widgets/scroll_to_top_button.dart';
import '../../../Widgets/footer_section.dart';
import '../../../Widgets/footer_section_mob.dart';
import '../../../Widgets/cached_cms_futures.dart';
import '../../../Widgets/dynamic_content_widget.dart';
import '../../../core/responsive/native_layout.dart';
import '../../../core/Language/app_languages.dart';
import '../../../generated/assets.dart';
import '../../../Utilities/font_helper.dart';

class MedicalLeasingScreen extends StatelessWidget {
  static const String routeName = '/services/medical-leasing';

  const MedicalLeasingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final ScrollController scrollController = ScrollController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: useNativeBottomNavigationBar(context)
            ? const BottomNavBarWidget(selected: SelectedBottomNavBar.aboutUs)
            : null,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      width: double.infinity,
                      child: CachedHeroDecorationScope(
                        pageId: 'medical-leasing',
                        isMobile: isMobile,
                        fit: BoxFit.fill,
                        builder: (context, decorationImage) {
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: decorationImage,
                            ),
                            child: Stack(
                              children: [
                                // Fallback image for height calculation
                                Image.asset(
                                  Assets.imagesLearnServices,
                                  width: double.infinity,
                                  fit: BoxFit.none,
                                  color: Colors.transparent,
                                ),
                                // هنا المحتوى اللي انت عايزه فوق الصورة
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      isMobile ? 10.w : 50.w,
                                      isMobile ? 50.h : 200.h,
                                      isMobile ? 10.w : 50.w,
                                      20.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          final isArabic =
                                              Provider.of<AppLanguage>(context, listen: false).appLang ==
                                                  Languages.ar;
                                          return isArabic ? Row(
                                            mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                                            crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                                            children: [
                                              DynamicText(
                                                pageId: 'medical-leasing',
                                                sectionId: 'hero-title-2',
                                                defaultValue: 'MEDICAL_HERO_TITLE_2',
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: const Color(0xFFF4ED47),
                                                  fontSize: isMobile ? 20.sp : 75.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Gap(8.w),
                                              DynamicText(
                                                pageId: 'medical-leasing',
                                                sectionId: 'hero-title-1',
                                                defaultValue: 'MEDICAL_HERO_TITLE_1',
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: Colors.white,
                                                  fontSize: isMobile ? 20.sp : 70.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ) : Row(
                                            mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                                            crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                                            children: [
                                              DynamicText(
                                                pageId: 'medical-leasing',
                                                sectionId: 'hero-title-1',
                                                defaultValue: 'MEDICAL_HERO_TITLE_1',
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: Colors.white,
                                                  fontSize: isMobile ? 20.sp : 70.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Gap(8.w),
                                              DynamicText(
                                                pageId: 'medical-leasing',
                                                sectionId: 'hero-title-2',
                                                defaultValue: 'MEDICAL_HERO_TITLE_2',
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: const Color(0xFFF4ED47),
                                                  fontSize: isMobile ? 20.sp : 75.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      ),

                                      Gap(isMobile ? 0.h : 40.h),
                                      Gap(isMobile ? 10.h : 40.h),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 800,
                                        ),
                                        child: DynamicText(
                                          pageId: 'medical-leasing',
                                          sectionId: 'hero-subtitle',
                                          defaultValue: 'MEDICAL_HERO_SUBTITLE',
                                          style: TextStyle(
                                            fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                                            color: Colors.white,
                                            fontSize: isMobile ? 12.sp : 38.sp,
                                          ),
                                        ),
                                      ),
                                      Gap(isMobile ? 10.h : 70.h),
                                      // Description paragraphs section
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 800,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: isMobile ? 200.w : double.infinity,
                                              child: _buildDescriptionBox(
                                                context: context,
                                                isMobile: isMobile,
                                                textAlign: TextAlign.start,
                                                pageId: 'medical-leasing',
                                                sectionId: 'description-1',
                                                defaultValue: 'MEDICAL_DESCRIPTION_1',
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            SizedBox(
                                              width: isMobile ? 280.w : double.infinity,
                                              child: _buildDescriptionBox(
                                                context: context,
                                                isMobile: isMobile,
                                                textAlign: TextAlign.start,
                                                pageId: 'medical-leasing',
                                                sectionId: 'description-2',
                                                defaultValue: 'MEDICAL_DESCRIPTION_2',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(isMobile ? 10.h : 160.h),
                                      // Our Services Include Section
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isMobile ? 20.w : 40.w,
                                          vertical: isMobile ? 10.h : 40.h,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            DynamicText(
                                              pageId: 'medical-leasing',
                                              sectionId: 'services-title',
                                              defaultValue: 'MEDICAL_SERVICE_TITLE',
                                              style: TextStyle(
                                                fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                color: const Color(0xFFF4ED47),
                                                fontSize: isMobile ? 22.sp : 70.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: isMobile ? 10.h : 20.h),
                                            _buildDescriptionBox(
                                              context: context,
                                              isMobile: isMobile,
                                              pageId: 'medical-leasing',
                                              sectionId: 'service-1',
                                              defaultValue: 'MEDICAL_SERVICE_1',
                                              width: 1200.w,
                                            ),
                                            SizedBox(height: 10.h),
                                            _buildDescriptionBox(
                                              context: context,
                                              isMobile: isMobile,
                                              pageId: 'medical-leasing',
                                              sectionId: 'service-2',
                                              defaultValue: 'MEDICAL_SERVICE_2',
                                              width: 1200.w,
                                            ),
                                            SizedBox(height: 10.h),
                                            _buildDescriptionBox(
                                              context: context,
                                              isMobile: isMobile,
                                              pageId: 'medical-leasing',
                                              sectionId: 'service-3',
                                              defaultValue: 'MEDICAL_SERVICE_3',
                                              width: 1200.w,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(isMobile ? 10.h : 40.h),

                                      ClientsLogosSection(
                                        pageId: 'medical-leasing',
                                        backgroundColor: Colors.grey[900]!,
                                        logos: const [Assets.logosINCM],
                                        visibleLogosCount: 5,
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const ContentServiceSection(sourceTag: 'Medical leasing'),
                  // Footer
                  if (kIsWeb)
                    (MediaQuery.sizeOf(context).width >= 600
                        ? const FooterSection()
                        : const FooterSectionMob()),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: useWebDesktopAppBar(context)
                  ? const CustomAppBar()
                  : const CustomAppBarMob(),
            ),
            const FloatingContactButtons(),
            ScrollToTopButton(scrollController: scrollController),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionBox({
    required BuildContext context,
    required bool isMobile,
    String? text,
    String? pageId,
    String? sectionId,
    String? defaultValue,
    double? width,
    TextAlign? textAlign
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: isMobile? 8.w: 12.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Center(
        child: (pageId != null && sectionId != null)
            ? DynamicText(
                pageId: pageId,
                sectionId: sectionId,
                defaultValue: defaultValue ?? text ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 12.sp : 40.sp,
                  height: isMobile ? 1.3 : 1.8,
                ),
                textAlign: textAlign??TextAlign.center,
              )
            : Text(
                text ?? defaultValue ?? '',
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 12.sp : 40.sp,
                  height: isMobile ? 1.3 : 1.8,
                ),
              ),
      ),
    );
  }
}
