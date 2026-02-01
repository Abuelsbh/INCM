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
import '../../../core/Language/locales.dart';
import '../../../generated/assets.dart';
import '../../../Utilities/font_helper.dart';

class ConsultationScreen extends StatelessWidget {
  static const String routeName = '/services/consultation';

  const ConsultationScreen({super.key});

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
                        'consultation',
                        'background-image',
                        fit: BoxFit.contain,
                      ),
                      builder: (context, snapshot) {
                        DecorationImage? decorationImage = snapshot.data;

                        // Fallback to asset if Firebase image not available
                        if (decorationImage == null) {
                          decorationImage = DecorationImage(
                            image: AssetImage(isMobile ? Assets.imagesServices2Mob : Assets.imagesService2Web),
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
                                  isMobile ? Assets.imagesServices2Mob : Assets.imagesService2Web,
                                  width: double.infinity,
                                  fit: BoxFit.none,
                                  color: Colors.transparent,
                                ),
                                // هنا المحتوى اللي انت عايزه فوق الصورة
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    isMobile ? 10.w : 50.w,
                                    isMobile ? 85.h : 170.h,
                                    isMobile ? 10.w : 50.w,
                                    isMobile ? 10.w : 20.w,),
                                  child: Builder(
                                    builder: (context) {
                                      final isArabic =
                                          Provider.of<AppLanguage>(context, listen: false).appLang ==
                                              Languages.ar;
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          isArabic?
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              DynamicText(
                                                pageId: 'consultation',
                                                sectionId: 'hero-title-2',
                                                defaultValue: 'CONSULTATION_HERO_TITLE_2',
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: const Color(0xFFF4ED47),
                                                  fontSize: isMobile ? 18.sp : 75.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Gap(6.w),
                                              DynamicText(
                                                pageId: 'consultation',
                                                sectionId: 'hero-title-1',
                                                defaultValue: 'CONSULTATION_HERO_TITLE_1',
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: Colors.white,
                                                  fontSize: isMobile ? 18.sp : 70.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),


                                            ],
                                          ) : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              DynamicText(
                                                pageId: 'consultation',
                                                sectionId: 'hero-title-1',
                                                defaultValue: 'CONSULTATION_HERO_TITLE_1',
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: Colors.white,
                                                  fontSize: isMobile ? 18.sp : 70.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              DynamicText(
                                                pageId: 'consultation',
                                                sectionId: 'hero-title-2',
                                                defaultValue: 'CONSULTATION_HERO_TITLE_2',
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: const Color(0xFFF4ED47),
                                                  fontSize: isMobile ? 18.sp : 75.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Gap(12.h),
                                          SizedBox(
                                            width: isMobile ? 260.w : double.infinity,
                                            child: DynamicText(
                                              pageId: 'consultation',
                                              sectionId: 'hero-subtitle',
                                              defaultValue: 'CONSULTATION_HERO_SUBTITLE',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                                                color: const Color(0xFFF4ED47),
                                                fontSize: isMobile ? 10.sp :38.sp,
                                                height: isMobile ? 1 : 1.6,
                                              ),
                                            ),
                                          ),

                                          Gap(isMobile ? 50.h : 70.h),
                                          // Description paragraphs section

                                          if(!isMobile)
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                _buildDescriptionBox(
                                                  context: context,
                                                  isMobile: isMobile,
                                                  pageId: 'consultation',
                                                  sectionId: 'description-1',
                                                  defaultValue: 'CONSULTATION_DESCRIPTION_1',
                                                ),
                                                // SizedBox(height: isMobile ? 24.h : 30.h),
                                                // _buildDescriptionBox(
                                                //   context: context,
                                                //   isMobile: isMobile,
                                                //   text: 'Whether you\'re a developer, investor, or property owner, we deliver data-driven analysis, market intelligence, and tailored advice to support informed decision-making and maximize asset value and return on investment (ROI) - all backed by the expertise of our team.',
                                                // ),

                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                      maxWidth: 750, // set your desired max width here
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [

                                                        SizedBox(height: isMobile ? 24.h : 200.h),
                                                        // _buildDescriptionBox(
                                                        //   context: context,
                                                        //   isMobile: isMobile,
                                                        //   text: 'We are involved from the very beginning - starting from the land only - in designing the project, planning space divisions and sections, and organizing entrances, exits, circulation, and pathways. From the mall\'s overall layout to on-site construction, we supervise every step of the process to ensure precision and quality.',
                                                        // ),
                                                        // SizedBox(height: isMobile ? 24.h : 30.h),
                                                        _buildDescriptionBox(
                                                          context: context,
                                                          isMobile: isMobile,
                                                          pageId: 'consultation',
                                                          sectionId: 'description-2',
                                                          defaultValue: 'CONSULTATION_DESCRIPTION_2',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),


                                          if(isMobile)
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: isMobile ? 400 : 260, // set your desired max width here
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  _buildDescriptionBox(
                                                    context: context,
                                                    isMobile: isMobile,
                                                    pageId: 'consultation',
                                                    sectionId: 'description-1',
                                                    defaultValue: 'CONSULTATION_DESCRIPTION_1',
                                                  ),
                                                  SizedBox(height: isMobile ? 24.h : 30.h),
                                                  _buildDescriptionBox(
                                                    context: context,
                                                    isMobile: isMobile,
                                                    pageId: 'consultation',
                                                    sectionId: 'description-2',
                                                    defaultValue: 'CONSULTATION_DESCRIPTION_2',
                                                  ),

                                                ],
                                              ),
                                            ),

                                          Gap(isMobile ? 430.h : 320.h),
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
                                                FutureBuilder<String>(
                                                  future: ContentHelper.getText(
                                                    context,
                                                    'consultation',
                                                    'services-title',
                                                    defaultValue: 'OUR_SERVICES',
                                                  ),
                                                  builder: (context, servicesSnapshot) {
                                                    return FutureBuilder<String>(
                                                      future: ContentHelper.getText(
                                                        context,
                                                        'consultation',
                                                        'services-include',
                                                        defaultValue: 'INCLUDE',
                                                      ),
                                                      builder: (context, includeSnapshot) {
                                                        // Check if data is null, empty, or looks like a translation key/default value, then use translation
                                                        final String? servicesData = servicesSnapshot.data;
                                                        final String servicesText = (servicesData == null || 
                                                          servicesData.isEmpty || 
                                                          servicesData == 'OUR_SERVICES' || 
                                                          servicesData == 'OUR SERVICE' ||
                                                          (servicesData.contains('_') && servicesData == servicesData.toUpperCase()))
                                                            ? 'OUR_SERVICES'.tr(context)
                                                            : servicesData;
                                                        
                                                        final String? includeData = includeSnapshot.data;
                                                        final String includeText = (includeData == null || 
                                                          includeData.isEmpty || 
                                                          includeData == 'INCLUDE' || 
                                                          includeData == 'INCLUDES' ||
                                                          (includeData.contains('_') && includeData == includeData.toUpperCase()))
                                                            ? 'INCLUDE'.tr(context)
                                                            : includeData;
                                                        
                                                        return RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: '$servicesText ',
                                                                style: TextStyle(
                                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                                  color: Colors.white,
                                                                  fontSize: isMobile ? 18.sp : 70.sp,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: includeText,
                                                                style: TextStyle(
                                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                                  color: const Color(0xFFF4ED47),
                                                                  fontSize: isMobile ? 18.sp : 70.sp,
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
                                                SizedBox(height: isMobile ? 10.h : 40.h),


                                                if(!isMobile)
                                                  _buildDescriptionBox(
                                                    context: context,
                                                    isMobile: isMobile,
                                                    pageId: 'consultation',
                                                    sectionId: 'service-1',
                                                    defaultValue: 'CONSULTATION_SERVICE_1',
                                                    width: 1200.w,
                                                    textAlign: TextAlign.center,
                                                  ),

                                                if(isMobile)
                                                  Column(
                                                    children: [
                                                      _buildDescriptionBox(
                                                        context: context,
                                                        isMobile: isMobile,
                                                        pageId: 'consultation',
                                                        sectionId: 'service-1',
                                                        defaultValue: 'CONSULTATION_SERVICE_1',
                                                        width: 1200.w,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                      SizedBox(height: isMobile ? 10.h : 40.h),
                                                      _buildDescriptionBox(
                                                        context: context,
                                                        isMobile: isMobile,
                                                        pageId: 'consultation',
                                                        sectionId: 'service-2',
                                                        defaultValue: 'CONSULTATION_SERVICE_2',
                                                        width: 1200.w,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),

                                                SizedBox(height: isMobile ? 8.h : 30.h),
                                                _buildDescriptionBox(
                                                  context: context,
                                                  isMobile: isMobile,
                                                  pageId: 'consultation',
                                                  sectionId: 'service-3',
                                                  defaultValue: 'CONSULTATION_SERVICE_3',
                                                  width: 1200.w,
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: isMobile ? 8.h : 30.h),
                                                _buildDescriptionBox(
                                                  context: context,
                                                  isMobile: isMobile,
                                                  pageId: 'consultation',
                                                  sectionId: 'service-4',
                                                  defaultValue: 'CONSULTATION_SERVICE_4',
                                                  width: 1200.w,
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: isMobile ? 8.h : 30.h),
                                                _buildDescriptionBox(
                                                  context: context,
                                                  isMobile: isMobile,
                                                  pageId: 'consultation',
                                                  sectionId: 'service-5',
                                                  defaultValue: 'CONSULTATION_SERVICE_5',
                                                  width: 1200.w,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),

                                          Gap(isMobile ? 20.h : 120.h),
                                          ClientsLogosSection(
                                            backgroundColor: Colors.grey[900]!,
                                            pageId: 'consultation',
                                            logos: [
                                              Assets.logosConsultation1,
                                              Assets.logosConsultation2,
                                              Assets.logosConsultation3,
                                              Assets.logosConsultation4,
                                              Assets.logosConsultation5,
                                              Assets.logosConsultation6,
                                              Assets.logosConsultation7,
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
                                            ],
                                            visibleLogosCount: 5,
                                          ),
                                        ],
                                      );
                                    }
                                  ),
                                ),
                              ],
                            ));
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
    TextAlign? textAlign,
  }) {
    // Use Firebase if pageId and sectionId are provided, otherwise use static text
    final String displayText = defaultValue ?? text ?? '';

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12.w : 28.w, vertical:  isMobile ? 8.w : 32.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(isMobile ? 20.r : 50.r),
      ),
      child: Center(
        child: (pageId != null && sectionId != null)
            ? DynamicText(
                pageId: pageId,
                sectionId: sectionId,
                defaultValue: displayText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 11.sp : 42.sp,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: textAlign ?? TextAlign.justify,
              )
            : Text(
                displayText,
                textAlign: textAlign ?? TextAlign.justify,
                textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 11.sp : 42.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
      ),
    );
  }


}

