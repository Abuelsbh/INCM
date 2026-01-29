import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
import '../../../core/Language/locales.dart';
import '../../../Utilities/font_helper.dart';
import '../../../generated/assets.dart';

class RetailLeasingScreen extends StatelessWidget {
  static const String routeName = '/services/retail-leasing';

  const RetailLeasingScreen({super.key});

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
                        'retail-leasing',
                        'background-image',
                        fit: BoxFit.contain,
                      ),
                      builder: (context, snapshot) {
                        DecorationImage? decorationImage = snapshot.data;
                        
                        // Fallback to asset if Firebase image not available
                        if (decorationImage == null) {
                          decorationImage = DecorationImage(
                            image: AssetImage(isMobile ? Assets.imagesService7Mob : Assets.imagesService7),
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
                                isMobile ? Assets.imagesService7Mob : Assets.imagesService7,
                                width: double.infinity,
                                fit: BoxFit.none,
                                color: Colors.transparent,
                              ),
                              // هنا المحتوى اللي انت عايزه فوق الصورة
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    isMobile ? 10.w : 150.w,
                                    isMobile ? 65.h : 180.h,
                                    isMobile ? 10.w : 150.w,
                                  isMobile ? 10.w : 50.w,),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        DynamicText(
                                          pageId: 'retail-leasing',
                                          sectionId: 'hero-title-1',
                                          defaultValue: 'RETAIL_HERO_TITLE_1',
                                          style: TextStyle(
                                            fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                            color: Colors.white,
                                            fontSize: isMobile ? 18.sp : 70.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DynamicText(
                                          pageId: 'retail-leasing',
                                          sectionId: 'hero-title-2',
                                          defaultValue: 'RETAIL_HERO_TITLE_2',
                                          style: TextStyle(
                                            fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                            color: const Color(0xFFF4ED47),
                                            fontSize: isMobile ? 18.sp : 75.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(0.w),
                                    DynamicText(
                                      pageId: 'retail-leasing',
                                      sectionId: 'hero-subtitle',
                                      defaultValue: 'RETAIL_HERO_SUBTITLE',
                                      style: TextStyle(
                                        fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                                        color: Colors.white,
                                        fontSize: isMobile ? 8.sp : 32.sp,
                                      ),
                                    ),
                              Gap(isMobile ? 30.h : 100.h),
                              // Description paragraphs section
                              Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      pageId: 'retail-leasing',
                                      sectionId: 'description-1',
                                      defaultValue: 'RETAIL_DESCRIPTION_1',
                                    ),
                                    SizedBox(height: isMobile ? 225.h : 1000.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      pageId: 'retail-leasing',
                                      sectionId: 'description-2',
                                      defaultValue: 'RETAIL_DESCRIPTION_2',
                                    ),
                                    // SizedBox(height: isMobile ? 10.h : 30.h),
                                    // _buildDescriptionBox2(
                                    //   context: context,
                                    //   isMobile: isMobile,
                                    //   text1: 'We have a huge inventory in',
                                    //   text2: ' prime locations in New Cairo, Fifth Settlement, the New Administrative Capital, and many other areas.',
                                    // ),
                                  ],
                                ),
                              ),
                              Gap(isMobile ? 40.h : 240.h),
                              // Our Services Include Section
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 20.w : 40.w,
                                  vertical: isMobile ? 0.h : 40.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FutureBuilder<String>(
                                      future: ContentHelper.getText(
                                        context,
                                        'retail-leasing',
                                        'services-title',
                                        defaultValue: 'OUR_SERVICES',
                                      ),
                                      builder: (context, servicesSnapshot) {
                                        return FutureBuilder<String>(
                                          future: ContentHelper.getText(
                                            context,
                                            'retail-leasing',
                                            'services-include',
                                            defaultValue: 'INCLUDE',
                                          ),
                                          builder: (context, includeSnapshot) {
                                            String servicesText = servicesSnapshot.data ?? 'OUR_SERVICES';
                                            String includeText = includeSnapshot.data ?? 'INCLUDE';
                                            
                                            // Translate if the value is a translation key
                                            if (servicesText == 'OUR_SERVICES' || (servicesText.contains('_') && servicesText == servicesText.toUpperCase())) {
                                              servicesText = servicesText.tr(context);
                                            }
                                            if (includeText == 'INCLUDE' || (includeText.contains('_') && includeText == includeText.toUpperCase())) {
                                              includeText = includeText.tr(context);
                                            }
                                            
                                            return RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '$servicesText ',
                                                    style: TextStyle(
                                                      fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                      color: Colors.white,
                                                      fontSize: isMobile ? 12.sp : 70.sp,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: includeText,
                                                    style: TextStyle(
                                                      fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                      color: const Color(0xFFF4ED47),
                                                      fontSize: isMobile ? 12.sp : 70.sp,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(height: isMobile? 10.h: 40.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      pageId: 'retail-leasing',
                                      sectionId: 'service-1',
                                      defaultValue: 'RETAIL_SERVICE_1',
                                      width: 1200.w
                                    ),
                                    SizedBox(height: isMobile ? 10.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      pageId: 'retail-leasing',
                                      sectionId: 'service-2',
                                      defaultValue: 'RETAIL_SERVICE_2',
                                      width: 1200.w
                                    ),
                                    SizedBox(height: isMobile ? 10.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      pageId: 'retail-leasing',
                                      sectionId: 'service-3',
                                      defaultValue: 'RETAIL_SERVICE_3',
                                      width: 1200.w
                                    ),
                                    SizedBox(height: isMobile ? 10.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      pageId: 'retail-leasing',
                                      sectionId: 'service-4',
                                      defaultValue: 'RETAIL_SERVICE_4',
                                      width: 1200.w
                                    ),
                                    SizedBox(height: isMobile ? 10.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      pageId: 'retail-leasing',
                                      sectionId: 'service-5',
                                      defaultValue: 'RETAIL_SERVICE_5',
                                      width: 1200.w
                                    ),
                                  ],
                                ),
                              ),
                              Gap(isMobile ? 20.h : 180.h),
                              ClientsLogosSection(
                                backgroundColor: Colors.grey[900]!,
                                pageId: 'retail-leasing', // Fetch logos from Firebase for this page
                                logos: [
                                  Assets.logosRetail1,
                                  Assets.logosRetail2,
                                  Assets.logosRetail3,
                                  Assets.logosRetail4,
                                  Assets.logosRetail5,
                                  Assets.logosRetail6,
                                  Assets.logosRetail7,
                                  Assets.logosRetail8,
                                  Assets.logosRetail9,
                                ], // Fallback logos if Firebase is not available
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
                  const ContentServiceSection(),

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
  }) {
    // Use Firebase if pageId and sectionId are provided, otherwise use static text
    final String displayText = defaultValue ?? text ?? '';
    
    return Container(
      width: width,
      padding: EdgeInsets.all(isMobile ? 8.w : 24.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Center(
        child: (pageId != null && sectionId != null)
            ? DynamicText(
                pageId: pageId,
                sectionId: sectionId,
                defaultValue: displayText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 10.sp : 42.sp,
                  height: isMobile ? 1.5 : 1.8,
                ),
                textAlign: TextAlign.center,
              )
            : Text(
                displayText,
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 10.sp : 42.sp,
                  height: isMobile ? 1.5 : 1.8,
                ),
              ),
      ),
    );
  }



  Widget _buildDescriptionBox2({
    required BuildContext context, required bool isMobile, required String text1, required String text2, double? width}) {
    return Container(
      width: width,
      padding: EdgeInsets.all(isMobile ? 6.w : 24.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Center(
        child: RichText(
          textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
          text: TextSpan(
            children: [
              TextSpan(
                text: text1,
                style: TextStyle(
                  color: const Color(0xFFF4ED47),
                  fontSize: isMobile ? 9.sp : 42.sp,
                  height: isMobile ? 1.5 : 1.8,
                ),
              ),
              TextSpan(
                text: text2,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 9.sp : 42.sp,
                  height: isMobile ? 1.5 : 1.8,
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}

