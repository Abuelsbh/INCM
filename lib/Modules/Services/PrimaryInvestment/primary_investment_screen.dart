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
import '../../../core/responsive/native_layout.dart';
import '../../../core/Language/app_languages.dart';
import '../../../generated/assets.dart';
import '../../../Utilities/font_helper.dart';

class PrimaryInvestmentScreen extends StatelessWidget {
  static const String routeName = '/services/primary-investment';

  const PrimaryInvestmentScreen({super.key});

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
                  Container(
                    width: double.infinity,
                    child: FutureBuilder<DecorationImage?>(
                      future: ContentHelper.getHeroDecorationImage(
                        context,
                        'primary-investment',
                        isMobile: isMobile,
                        fit: BoxFit.fill,
                      ),
                      builder: (context, snapshot) {
                        DecorationImage? decorationImage = snapshot.data;
                        
                        // Fallback to asset if Firebase image not available
                        if (decorationImage == null) {
                          decorationImage = DecorationImage(
                            image: AssetImage(Assets.imagesLearnServices),
                            fit: BoxFit.contain,
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
                              Image.asset(
                                Assets.imagesLearnServices,
                                width: double.infinity,
                                fit: BoxFit.none,
                                color: Colors.transparent,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    isMobile ? 10.w : 50.w,
                                    isMobile ? 60.h : 240.h,
                                    isMobile ? 10.w : 50.w,
                                    20.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    DynamicText(
                                      pageId: 'primary-investment',
                                      sectionId: 'hero-title-1',
                                      defaultValue: 'PRIMARY_HERO_TITLE_1',
                                      style: TextStyle(
                                        fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                        color: Colors.white,
                                        fontSize: isMobile ? 18.sp : 70.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Gap(isMobile ? 5.h : 240.h),
                                    // Description paragraphs section
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: isMobile ? 60.w : 240.w, vertical: isMobile ? 0.h : 80.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Builder(
                                                builder: (context) {
                                                  final isArabic =
                                                      Provider.of<AppLanguage>(context, listen: false).appLang ==
                                                          Languages.ar;
                                                  return !isArabic ? Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      DynamicText(
                                                        pageId: 'primary-investment',
                                                        sectionId: 'hero-title-2',
                                                        defaultValue: 'PRIMARY_HERO_TITLE_2',
                                                        style: TextStyle(
                                                          fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                          color: Colors.white,
                                                          fontSize: isMobile ? 12.sp : 70.sp,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      DynamicText(
                                                        pageId: 'primary-investment',
                                                        sectionId: 'hero-title-3',
                                                        defaultValue: 'PRIMARY_HERO_TITLE_3',
                                                        style: TextStyle(
                                                          fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                          color: const Color(0xFFF4ED47),
                                                          fontSize: isMobile ? 12.sp : 75.sp,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ): Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      DynamicText(
                                                        pageId: 'primary-investment',
                                                        sectionId: 'hero-title-3',
                                                        defaultValue: 'PRIMARY_HERO_TITLE_3',
                                                        style: TextStyle(
                                                          fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                          color: const Color(0xFFF4ED47),
                                                          fontSize: isMobile ? 12.sp : 75.sp,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      DynamicText(
                                                        pageId: 'primary-investment',
                                                        sectionId: 'hero-title-2',
                                                        defaultValue: 'PRIMARY_HERO_TITLE_2',
                                                        style: TextStyle(
                                                          fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                          color: Colors.white,
                                                          fontSize: isMobile ? 12.sp : 70.sp,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),

                                                    ],
                                                  );
                                                }
                                              )

                                            ],
                                          ),
                                          Gap(isMobile ? 5.w : 20.w),
                                          Container(
                                            height: isMobile ? 60.h : 150.h,
                                            width: isMobile ? 0.5.w : 2.w,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(32.r),
                                            ),
                                          ),
                                          Gap(isMobile ? 5.w : 20.w),
                                          Container(
                                            width: isMobile ? 140.w : 600.w,
                                            child: DynamicText(
                                              pageId: 'primary-investment',
                                              sectionId: 'hero-subtitle',
                                              defaultValue: 'PRIMARY_HERO_SUBTITLE',
                                              style: TextStyle(
                                                fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                color: Colors.white,
                                                fontSize: isMobile ? 8.sp : 36.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: isMobile ? 80.h : 700.h),
                                    Builder(
                                      builder: (context) {
                                        final isArabic =
                                            Provider.of<AppLanguage>(context, listen: false).appLang ==
                                                Languages.ar;
                                        return _buildDescriptionBox(
                                          context: context,
                                          isMobile: isMobile,
                                          pageId: 'primary-investment',
                                          sectionId: 'description-1',
                                          defaultValue: 'PRIMARY_DESCRIPTION_1',
                                          textAlign: isArabic ? TextAlign.center : null
                                        );
                                      }
                                    ),
                                    SizedBox(height: isMobile ? 20.h : 100.h),
                                    Builder(
                                      builder: (context) {
                                        final isArabic =
                                            Provider.of<AppLanguage>(context, listen: false).appLang ==
                                                Languages.ar;
                                        return _buildDescriptionBox(
                                          context: context,
                                          isMobile: isMobile,
                                          pageId: 'primary-investment',
                                          sectionId: 'description-2',
                                          defaultValue: 'PRIMARY_DESCRIPTION_2',
                                            textAlign: isArabic ? TextAlign.center : null
                                        );
                                      }
                                    ),
                                    Gap(isMobile ? 10.h : 240.h),
                                    // Our Services Include Section
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 20.w : 40.w,
                                        vertical: isMobile ? 8.h : 40.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          DynamicText(
                                            pageId: 'primary-investment',
                                            sectionId: 'services-title',
                                            defaultValue: 'PRIMARY_SERVICE_TITLE',
                                            style: TextStyle(
                                              fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                              color: const Color(0xFFF4ED47),
                                              fontSize: isMobile ? 20.sp : 70.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: isMobile ? 10.h : 40.h),
                                          _buildDescriptionBox(
                                            context: context,
                                            isMobile: isMobile,
                                            pageId: 'primary-investment',
                                            sectionId: 'service-1',
                                            defaultValue: 'PRIMARY_SERVICE_1',
                                            width: 1500.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gap(isMobile ? 10.h : 280.h),
                                    ClientsLogosSection(
                                      pageId: 'primary-investment',
                                      backgroundColor: Colors.grey[900]!,
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
                  const ContentServiceSection(sourceTag: 'Primary investment'),
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
    Color? textColor,
    double? width,
    TextAlign? textAlign,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.all(isMobile ? 8.w : 24.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: (pageId != null && sectionId != null)
          ? DynamicText(
              pageId: pageId,
              sectionId: sectionId,
              textAlign: textAlign,
              defaultValue: defaultValue ?? text ?? '',
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: isMobile ? 10.sp : 40.sp,
                height: 2,
              ),
            )
          : Text(
              text ?? defaultValue ?? '',
              textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: isMobile ? 10.sp : 40.sp,
                height: 2,
              ),
            ),
    );
  }
}
