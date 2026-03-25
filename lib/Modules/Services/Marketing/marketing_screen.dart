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
import '../../../Widgets/footer_section.dart';
import '../../../Widgets/footer_section_mob.dart';
import '../../../Widgets/scroll_to_top_button.dart';
import '../../../Widgets/dynamic_content_widget.dart';
import '../../../core/Content/content_helper.dart';
import '../../../core/Language/app_languages.dart';
import '../../../generated/assets.dart';
import '../../../Utilities/font_helper.dart';

class MarketingScreen extends StatelessWidget {
  static const String routeName = '/services/marketing';

  const MarketingScreen({super.key});

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
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      width: double.infinity,
                      child: FutureBuilder<DecorationImage?>(
                        future: ContentHelper.getDecorationImage(
                          context,
                          'marketing',
                          'background-image',
                          fit: BoxFit.contain,
                        ),
                        builder: (context, snapshot) {
                          DecorationImage? decorationImage = snapshot.data;
                    
                          // Fallback to asset if Firebase image not available
                          if (decorationImage == null) {
                            decorationImage = DecorationImage(
                              image: AssetImage(isMobile ? Assets.imagesService3Mob : Assets.imagesService3Web),
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
                                    isMobile ? Assets.imagesService3Mob : Assets.imagesService3Web,
                                    width: double.infinity,
                                    fit: BoxFit.none,
                                    color: Colors.transparent,
                                  ),
                                  Positioned(
                                    top: isMobile ? 100.h : 340.h,
                                    right: isMobile ? 40.w : 260.w,
                                    child: Builder(
                                        builder: (context) {
                                          final isArabic =
                                              Provider.of<AppLanguage>(context, listen: false).appLang ==
                                                  Languages.ar;
                                          return isArabic ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              DynamicText(
                                                pageId: 'marketing',
                                                sectionId: 'hero-title-2',
                                                defaultValue: 'MARKETING_HERO_TITLE_2',
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: const Color(0xFFC63424),
                                                  fontSize: isMobile ? 16.sp : 75.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                    
                                              Gap(isMobile ? 4.h : 20.h),
                    
                                              DynamicText(
                                                pageId: 'marketing',
                                                sectionId: 'hero-title-1',
                                                defaultValue: 'MARKETING_HERO_TITLE_1',
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: Colors.black,
                                                  fontSize: isMobile ? 16.sp : 80.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                    
                                              Gap(isMobile ? 8.h : 40.h),
                                              Container(
                                                height: 2,
                                                width: isMobile ? 100.w : 450.w,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.circular(isMobile ? 20.r : 50.r),
                                                ),
                    
                                              ),
                                              Gap(isMobile ? 8.h : 40.h),
                                              SizedBox(
                                                width: isMobile ? 120.w : 450.w,
                                                child: DynamicText(
                                                  pageId: 'marketing',
                                                  sectionId: 'hero-subtitle',
                                                  defaultValue: 'MARKETING_HERO_SUBTITLE',
                                                  style: TextStyle(
                                                    fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                                                    color: Colors.black,
                                                    fontSize: isMobile ? 10.sp : 36.sp,
                                                    height: isMobile ? 2 : 3,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ) : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              DynamicText(
                                                pageId: 'marketing',
                                                sectionId: 'hero-title-1',
                                                defaultValue: 'MARKETING_HERO_TITLE_1',
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: Colors.black,
                                                  fontSize: isMobile ? 16.sp : 80.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                    
                                              Gap(isMobile ? 4.h : 20.h),
                                              DynamicText(
                                                pageId: 'marketing',
                                                sectionId: 'hero-title-2',
                                                defaultValue: 'MARKETING_HERO_TITLE_2',
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: const Color(0xFFC63424),
                                                  fontSize: isMobile ? 16.sp : 75.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                    
                                              Gap(isMobile ? 8.h : 40.h),
                                              Container(
                                                height: 2,
                                                width: isMobile ? 100.w : 450.w,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.circular(isMobile ? 20.r : 50.r),
                                                ),
                    
                                              ),
                                              Gap(isMobile ? 8.h : 40.h),
                                              SizedBox(
                                                width: isMobile ? 120.w : 450.w,
                                                child: DynamicText(
                                                  pageId: 'marketing',
                                                  sectionId: 'hero-subtitle',
                                                  defaultValue: 'MARKETING_HERO_SUBTITLE',
                                                  style: TextStyle(
                                                    fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                                                    color: Colors.black,
                                                    fontSize: isMobile ? 10.sp : 36.sp,
                                                    height: isMobile ? 2 : 3,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                    ),
                                  ),
                    
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      isMobile ? 10.w : 50.w,
                                      isMobile ? 80.h : 240.h,
                                      isMobile ? 10.w : 50.w,
                                      isMobile ? 10.w : 20.w,),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // RichText(
                                        //   text: TextSpan(
                                        //     children: [
                                        //       TextSpan(
                                        //         text: 'MARKETING',
                                        //         style: TextStyle(
                                        //           fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                        //           color: Colors.white,
                                        //           fontSize: isMobile ? 32.sp : 70.sp,
                                        //           fontWeight: FontWeight.bold,
                                        //         ),
                                        //       ),
                                        //       TextSpan(
                                        //         text: ' SERVICE',
                                        //         style: TextStyle(
                                        //           fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                        //           color: const Color(0xFFF4ED47),
                                        //           fontSize: isMobile ? 48.sp : 75.sp,
                                        //           fontWeight: FontWeight.bold,
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // SizedBox(height: 20.h),
                                        // SizedBox(
                                        //   width: isMobile ? double.infinity : 600.w,
                                        //   child: Text(
                                        //     'YOU MAY OFFER A HIGHLY COMPETITIVE SERVICE, BUT WITHOUT MARKETING, WHO WILL KNOW?',
                                        //     style: TextStyle(
                                        //       fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                                        //       color: Colors.white,
                                        //       fontSize: isMobile ? 14.sp : 32.sp,
                                        //       height: 1.6,
                                        //     ),
                                        //   ),
                                        // ),
                                        // Gap(isMobile ? 20.h : 70.h),
                                        // Description paragraphs section
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: isMobile ? 180.w : 900.w, // set your desired max width here
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildDescriptionBox(
                                                textAlign: TextAlign.start,
                                                context: context,
                                                isMobile: isMobile,
                                                pageId: 'marketing',
                                                sectionId: 'description-1',
                                                defaultValue: 'MARKETING_DESCRIPTION_1',
                                              ),

                                              if(!isMobile)
                                                Column(
                                                  children: [
                                                    SizedBox(height: isMobile ? 8.h : 30.h),
                                                    _buildDescriptionBox(
                                                      context: context,
                                                      isMobile: isMobile,
                                                      pageId: 'marketing',
                                                      sectionId: 'description-2',
                                                      defaultValue: 'MARKETING_DESCRIPTION_2',
                                                    ),
                                                  ],
                                                )
                    
                    
                                              // SizedBox(height: isMobile ? 8.h : 30.h),
                                              // _buildDescriptionBox(
                                              //   context: context,
                                              //   isMobile: isMobile,
                                              //   text: 'Our Services include the development of customized marketing plans backed by indepth market research, demographic analysis, and the latest industry trends.',
                                              // ),
                                            ],
                                          ),
                                        ),
                    
                                        if(isMobile)
                                          Column(
                                            children: [
                                              SizedBox(height: isMobile ? 200.h : 30.h),
                                              _buildDescriptionBox(
                                                context: context,
                                                isMobile: isMobile,
                                                pageId: 'marketing',
                                                sectionId: 'description-2',
                                                defaultValue: 'MARKETING_DESCRIPTION_2',
                                              ),
                                            ],
                                          ),

                                        Builder(
                                          builder: (context) {
                                            final isArabic =
                                                Provider.of<AppLanguage>(context, listen: false).appLang ==
                                                    Languages.ar;
                                            return Gap(isMobile ? 20.h : isArabic ? 240.h : 140.h);
                                          }
                                        ),
                                        // Our Services Include Section
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isMobile ? 20.w : 40.w,
                                            vertical: isMobile ? 0.h : 0.h,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Gap(isMobile ? 0 : 190.h),
                                              DynamicText(
                                                pageId: 'marketing',
                                                sectionId: 'services-title',
                                                defaultValue: 'MARKETING_SERVICE_TITLE',
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
                                                pageId: 'marketing',
                                                sectionId: 'service-1',
                                                defaultValue: 'MARKETING_SERVICE_1',
                                                width: 1400.w,
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: isMobile ? 8.h : 30.h),
                                              _buildDescriptionBox(
                                                context: context,
                                                isMobile: isMobile,
                                                pageId: 'marketing',
                                                sectionId: 'service-2',
                                                defaultValue: 'MARKETING_SERVICE_2',
                                                width: 1400.w,
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: isMobile ? 8.h : 30.h),
                                              _buildDescriptionBox(
                                                context: context,
                                                isMobile: isMobile,
                                                pageId: 'marketing',
                                                sectionId: 'service-3',
                                                defaultValue: 'MARKETING_SERVICE_3',
                                                width: 1400.w,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Gap(isMobile ? 14.h : 40.h),
                                        ClientsLogosSection(
                                          backgroundColor: Colors.grey[900]!,
                                          pageId: 'marketing',
                                          logos: [
                                            Assets.logosMarketing1,
                                            Assets.logosMarketing2,
                                            Assets.logosMarketing3,
                                            Assets.logosMarketing4,
                                            Assets.logosMarketing5,
                                            Assets.logosMarketing6,
                                          ],
                                          visibleLogosCount: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                    
                                ],
                              ));
                        },
                      ),
                    ),
                  ),
                  const ContentServiceSection(sourceTag: 'Marketing'),

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
    TextAlign? textAlign
  }) {
    // Use Firebase if pageId and sectionId are provided, otherwise use static text
    final String displayText = defaultValue ?? text ?? '';
    
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 6.w : 28.w, vertical:  isMobile ? 8.w : 32.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(isMobile ? 20.r : 50.r),
      ),
      child: Center(
        child: (pageId != null && sectionId != null)
            ? DynamicText(
                pageId: pageId,
                sectionId: sectionId,
                defaultValue: displayText,
                style: TextStyle(
                  color: highlightColor ?? Colors.white,
                  fontSize: isMobile ? 10.sp : 42.sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  height: 2,
                ),
                textAlign: textAlign,
              )
            : Text(
                displayText,
                textAlign: textAlign,
                textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
                style: TextStyle(
                  color: highlightColor ?? Colors.white,
                  fontSize: isMobile ? 10.sp : 42.sp,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  height: 2,
                ),
              ),
      ),
    );
  }
}

