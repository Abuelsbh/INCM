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
import '../../../Widgets/dynamic_content_widget.dart';
import '../../../core/Content/content_helper.dart';
import '../../../core/Language/app_languages.dart';
import '../../../generated/assets.dart';
import '../../../Utilities/font_helper.dart';

class FacilityManagementScreen extends StatelessWidget {
  static const String routeName = '/services/facility-management';

  const FacilityManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final ScrollController scrollController = ScrollController();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: MediaQuery.of(context).size.width < 600 && !kIsWeb
            ? const BottomNavBarWidget(selected: SelectedBottomNavBar.aboutUs)
            : null,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: FutureBuilder<DecorationImage?>(
                      future: ContentHelper.getDecorationImage(
                        context,
                        'facility-management',
                        'background-image',
                        fit: BoxFit.contain,
                      ),
                      builder: (context, snapshot) {
                        DecorationImage? decorationImage = snapshot.data;

                        // Fallback to asset if Firebase image not available
                        if (decorationImage == null) {
                          decorationImage = DecorationImage(
                            image: AssetImage(isMobile ? Assets.imagesService5Mob : Assets.imagesService5Web),
                            fit: BoxFit.fill,
                          );
                        }

                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: decorationImage,
                          ),
                          child: Stack(
                            children: [
                              // Fallback image for height calculation
                              // Image.asset(
                              //   isMobile ? Assets.imagesService5Mob : Assets.imagesService5Web,
                              //   width: double.infinity,
                              //
                              // ),
                              Positioned(
                                top: isMobile ? 110.h : 350.h,
                                right: isMobile ? 28.w : 220.w,
                                child: Column(

                                  children: [
                                    Builder(
                                      builder: (context) {
                                        final isArabic =
                                            Provider.of<AppLanguage>(context, listen: false).appLang ==
                                                Languages.ar;
                                        return !isArabic ? Column(
                                          children: [
                                            DynamicText(
                                              pageId: 'facility-management',
                                              sectionId: 'hero-title-1',
                                              defaultValue: 'FACILITY_HERO_TITLE_1',
                                              style: TextStyle(
                                                fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                color: Colors.black,
                                                fontSize: isMobile ? 16.sp : 60.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Gap(isMobile ? 4.h : 20.h),
                                            DynamicText(
                                              pageId: 'facility-management',
                                              sectionId: 'hero-title-2',
                                              defaultValue: 'FACILITY_HERO_TITLE_2',
                                              style: TextStyle(
                                                fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                color: Colors.black,
                                                fontSize: isMobile ? 16.sp : 60.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ) : Column(
                                          children: [
                                            DynamicText(
                                              pageId: 'facility-management',
                                              sectionId: 'hero-title-2',
                                              defaultValue: 'FACILITY_HERO_TITLE_2',
                                              style: TextStyle(
                                                fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                color: Colors.black,
                                                fontSize: isMobile ? 16.sp : 60.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            Gap(isMobile ? 4.h : 20.h),
                                            DynamicText(
                                              pageId: 'facility-management',
                                              sectionId: 'hero-title-1',
                                              defaultValue: 'FACILITY_HERO_TITLE_1',
                                              style: TextStyle(
                                                fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                color: Colors.black,
                                                fontSize: isMobile ? 16.sp : 60.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    ),

                                    Gap(isMobile ? 8.h : 40.h),
                                    SizedBox(
                                      width: isMobile ? 120.w : 450.w,
                                      child: DynamicText(
                                        pageId: 'facility-management',
                                        sectionId: 'hero-subtitle',
                                        defaultValue: 'FACILITY_HERO_SUBTITLE',
                                        style: TextStyle(
                                          fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                                          color: Colors.black,
                                          fontSize: isMobile ? 10.sp : 36.sp,
                                          height: isMobile ? 2 : 3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    isMobile ? 10.w : 50.w,
                                    isMobile ? 60.h : 300.h,
                                    isMobile ? 10.w : 50.w,
                                    20.h),
                                child: Directionality( textDirection: TextDirection.ltr, child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        DynamicText(
                                          pageId: 'facility-management',
                                          sectionId: 'hero-title-1',
                                          defaultValue: 'FACILITY_HERO_TITLE_1',
                                          style: TextStyle(
                                            fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                            color: Colors.white,
                                            fontSize: isMobile ? 18.sp : 70.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Gap(8.w),
                                        DynamicText(
                                          pageId: 'facility-management',
                                          sectionId: 'hero-title-2',
                                          defaultValue: 'FACILITY_HERO_TITLE_2',
                                          style: TextStyle(
                                            fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                            color: const Color(0xFFF4ED47),
                                            fontSize: isMobile ? 18.sp : 75.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: isMobile ? 200.w : 1050.w,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: isMobile ? 24.h : 50.h),
                                          _buildDescriptionBox(
                                            context: context,
                                            isMobile: isMobile,
                                            pageId: 'facility-management',
                                            sectionId: 'description-1',
                                            defaultValue: 'FACILITY_DESCRIPTION_1',
                                          ),
                                          SizedBox(height: isMobile ? 8.h : 30.h),
                                          _buildDescriptionBox(
                                            context: context,
                                            isMobile: isMobile,
                                            pageId: 'facility-management',
                                            sectionId: 'description-2',
                                            defaultValue: 'FACILITY_DESCRIPTION_2',
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gap(isMobile ? 150.h : 600.h),
                                    // Our Services Include Section
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 20.w : 40.w,
                                        vertical: isMobile ? 10.h : 10.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          DynamicText(
                                            pageId: 'facility-management',
                                            sectionId: 'services-title',
                                            defaultValue: 'FACILITY_SERVICE_TITLE',
                                            style: TextStyle(
                                              fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                              color: const Color(0xFFF4ED47),
                                              fontSize: isMobile ? 18.sp : 70.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: isMobile ? 10.h : 40.h),
                                          _buildDescriptionBox(
                                            context: context,
                                            isMobile: isMobile,
                                            pageId: 'facility-management',
                                            sectionId: 'service-1',
                                            defaultValue: 'FACILITY_SERVICE_1',
                                            width: 1200.w,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: isMobile ? 8.h : 30.h),
                                          _buildDescriptionBox(
                                            context: context,
                                            isMobile: isMobile,
                                            pageId: 'facility-management',
                                            sectionId: 'service-2',
                                            defaultValue: 'FACILITY_SERVICE_2',
                                            width: 1200.w,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: isMobile ? 8.h : 30.h),
                                          _buildDescriptionBox(
                                            context: context,
                                            isMobile: isMobile,
                                            pageId: 'facility-management',
                                            sectionId: 'service-3',
                                            defaultValue: 'FACILITY_SERVICE_3',
                                            width: 1200.w,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gap(isMobile ? 10.h : 100.h),
                                    ClientsLogosSection(
                                      pageId: 'facility-management',
                                      backgroundColor: Colors.grey[900]!,
                                      visibleLogosCount: 5,
                                    ),
                                  ],
                                )),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const ContentServiceSection(),
                  // Footer
                  if(MediaQuery.of(context).size.width >= 600)
                    const FooterSection()
                  else if(kIsWeb)
                    const FooterSectionMob(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: isMobile ? const CustomAppBarMob() : const CustomAppBar(),
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
    bool isBold = false,
    Color? highlightColor,
    TextAlign? textAlign,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10.w : 28.w, vertical: isMobile ? 8.w : 32.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4ED47).withOpacity(0.2),
        borderRadius: BorderRadius.circular(isMobile ? 20.r : 50.r),
      ),
      child: Center(
        child: (pageId != null && sectionId != null)
            ? DynamicText(
                pageId: pageId,
                sectionId: sectionId,
                defaultValue: defaultValue ?? text ?? '',
                style: TextStyle(
                  color: highlightColor ?? Colors.white,
                  fontSize: isMobile ? 10.sp : 42.sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: textAlign,
              )
            : Text(
                text ?? defaultValue ?? '',
                textAlign: textAlign,
                textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
                style: TextStyle(
                  color: highlightColor ?? Colors.white,
                  fontSize: isMobile ? 10.sp : 42.sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
      ),
    );
  }
}
