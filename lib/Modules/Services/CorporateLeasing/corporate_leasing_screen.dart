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
import '../../../Widgets/scroll_to_top_button.dart';
import '../../../Widgets/footer_section.dart';
import '../../../Widgets/footer_section_mob.dart';
import '../../../Widgets/dynamic_content_widget.dart';
import '../../../core/Content/content_helper.dart';
import '../../../generated/assets.dart';
import '../../../core/Language/locales.dart';

class CorporateLeasingScreen extends StatelessWidget {
  static const String routeName = '/services/corporate-leasing';

  const CorporateLeasingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final ScrollController scrollController = ScrollController();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
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
                          'corporate-leasing',
                          'background-image',
                          fit: BoxFit.contain,
                        ),
                        builder: (context, snapshot) {
                          DecorationImage? decorationImage = snapshot.data;

                          // Fallback to asset if Firebase image not available
                          if (decorationImage == null) {
                            decorationImage = DecorationImage(
                              image: AssetImage(Assets.imagesService1),
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
                                // الصورة الشفافة لحساب الارتفاع (fallback)
                                Image.asset(
                                  Assets.imagesService1,
                                  width: double.infinity,
                                  fit: BoxFit.none,
                                  color: Colors.transparent,
                                ),

                          // هنا المحتوى اللي انت عايزه فوق الصورة
                          Padding(
                            padding: EdgeInsets.fromLTRB(isMobile ? 20.w : 60.w, isMobile ? 65.h : 300.h, 20.w, isMobile ? 0.h:120.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // العنوان الأول - من Firebase
                                DynamicText(
                                  pageId: 'corporate-leasing',
                                  sectionId: 'hero-title-1',
                                  defaultValue: 'CORPORATE',
                                  style: TextStyle(
                                    fontFamily: 'OptimalBold',
                                    color: Colors.white,
                                    fontSize: isMobile ? 17.sp : 80.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                // العنوان الثاني - من Firebase
                                DynamicText(
                                  pageId: 'corporate-leasing',
                                  sectionId: 'hero-title-2',
                                  defaultValue: 'LEASING',
                                  style: TextStyle(
                                    fontFamily: 'OptimalBold',
                                    color: const Color(0xFFF4ED47),
                                    fontSize: isMobile ? 17.sp : 90.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                SizedBox(height: isMobile? 18.h: 80.h),
                                SizedBox(
                                  width: isMobile ? 170.w : 900.w,
                                  child: DynamicText(
                                    pageId: 'corporate-leasing',
                                    sectionId: 'hero-subtitle',
                                    defaultValue: 'YOUR_WORKSPACE_SHAPES',
                                    style: TextStyle(
                                      fontFamily: 'AloeveraDisplaySemiBold',
                                      color: Colors.white,
                                      fontSize: isMobile ? 9.sp : 42.sp,
                                      height: 1.2,
                                    ),
                                  ),
                                ),

                                Gap(isMobile? 150.h : 700.h),
                                // Experience and Strategic Locations Section
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildBulletPoint(
                                        context,
                                        isMobile,
                                        'corporate-leasing',
                                        'experience-text',
                                        'WE_HAVE_EXTENSIVE_EXPERIENCE'.tr(context),
                                      ),
                                      SizedBox(height: 10.h),
                                      _buildBulletPoint(
                                        context,
                                        isMobile,
                                        'corporate-leasing',
                                        'locations-text',
                                        'STRATEGIC_LOCATIONS'.tr(context),
                                      ),
                                    ],
                                  ),
                                ),

                                Gap(isMobile? 10.h : 300.h),
                                // Our Services Include Section
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 0.w : 40.w,
                                    vertical: isMobile ? 10 : 40.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<String>(
                                        future: ContentHelper.getText(
                                          context,
                                          'corporate-leasing',
                                          'services-title',
                                          defaultValue: 'OUR_SERVICES',
                                        ),
                                        builder: (context, servicesSnapshot) {
                                          return FutureBuilder<String>(
                                            future: ContentHelper.getText(
                                              context,
                                              'corporate-leasing',
                                              'services-include',
                                              defaultValue: 'INCLUDE',
                                            ),
                                            builder: (context, includeSnapshot) {
                                              return RichText(
                                                textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '${servicesSnapshot.data ?? 'OUR_SERVICES'.tr(context)} ',
                                                      style: TextStyle(
                                                        fontFamily: 'OptimalBold',
                                                        color: Colors.white,
                                                        fontSize: isMobile ? 22.sp : 70.sp,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 2,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: includeSnapshot.data ?? 'INCLUDE'.tr(context),
                                                      style: TextStyle(
                                                        fontFamily: 'OptimalBold',
                                                        color: const Color(0xFFF4ED47),
                                                        fontSize: isMobile ? 22.sp : 70.sp,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      SizedBox(height: isMobile? 10.h:40.h),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(horizontal: isMobile ? 10.w : 30.w, vertical: isMobile ? 10.h : 40.h),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[900]!.withOpacity(1),
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _buildServiceItem(
                                              context,
                                              isMobile,
                                              'corporate-leasing',
                                              'service-1',
                                              'LARGE_INVENTORY'.tr(context),
                                            ),
                                            SizedBox(height: isMobile ? 8.h:20.h),
                                            _buildServiceItem(
                                              context,
                                              isMobile,
                                              'corporate-leasing',
                                              'service-2',
                                              'FLEXIBLE_PAYMENT'.tr(context),
                                            ),
                                            SizedBox(height: isMobile ? 8.h:20.h),
                                            _buildServiceItem(
                                              context,
                                              isMobile,
                                              'corporate-leasing',
                                              'service-3',
                                              'SMART_SOLUTIONS'.tr(context),
                                            ),
                                            SizedBox(height: isMobile ? 8.h:20.h),
                                            _buildServiceItem(
                                              context,
                                              isMobile,
                                              'corporate-leasing',
                                              'service-4',
                                              'FULL_SUPPORT'.tr(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(isMobile ? 10.h : 120.h),
                                      ClientsLogosSection(
                                        pageId: 'corporate-leasing', // Fetch logos from Firebase for this page
                                        backgroundColor: Colors.grey[900]!,
                                        logos: [
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
                                        ],
                                        visibleLogosCount: 5,
                                      ),
                                    ],
                                  ),
                                ),


                                Gap(isMobile? 10.h : 350.h),
                              ],
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
      ),
    );
  }

  Widget _buildBulletPoint(
    BuildContext context,
    bool isMobile,
    String pageId,
    String sectionId,
    String defaultText,
  ) {
    return FutureBuilder<String>(
      future: ContentHelper.getText(
        context,
        pageId,
        sectionId,
        defaultValue: defaultText,
      ),
      builder: (context, snapshot) {
        final text = snapshot.data ?? defaultText;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• ',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 10.sp : 40.sp,
                height: 1.8,
              ),
            ),
            Expanded(
              child: RichText(
                textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 10.sp : 22.sp,
                    height: isMobile ? 1.2 : 1.8,
                  ),
                  children: _buildHighlightedText(text, isMobile),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<TextSpan> _buildHighlightedText(String text, bool isMobile) {
    final spans = <TextSpan>[];
    
    // Key phrases to highlight in yellow
    final highlightPhrases = [
      'extensive experience',
      'commercial real estate leasing transactions',
      'strategic locations',
      'customized solutions',
      'high standards',
    ];
    
    String remainingText = text;
    int currentIndex = 0;
    
    while (currentIndex < remainingText.length) {
      int? nextHighlightIndex;
      String? highlightPhrase;
      
      // Find the earliest highlight phrase
      for (final phrase in highlightPhrases) {
        final index = remainingText.toLowerCase().indexOf(
          phrase.toLowerCase(),
          currentIndex,
        );
        if (index != -1 && (nextHighlightIndex == null || index < nextHighlightIndex)) {
          nextHighlightIndex = index;
          highlightPhrase = phrase;
        }
      }
      
      if (nextHighlightIndex != null && highlightPhrase != null) {
        // Add text before highlight
        if (nextHighlightIndex > currentIndex) {
          spans.add(
            TextSpan(
              text: remainingText.substring(currentIndex, nextHighlightIndex),
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 10.sp : 40.sp,
              ),
            ),
          );
        }
        
        // Add highlighted text
        final highlightEnd = nextHighlightIndex + highlightPhrase.length;
        spans.add(
          TextSpan(
            text: remainingText.substring(nextHighlightIndex, highlightEnd),
            style: TextStyle(
              color: const Color(0xFFF4ED47),
              fontSize: isMobile ? 10.sp : 40.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        
        currentIndex = highlightEnd;
      } else {
        // Add remaining text
        spans.add(
          TextSpan(
            text: remainingText.substring(currentIndex),
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 10.sp : 40.sp,
            ),
          ),
        );
        break;
      }
    }
    
    return spans;
  }

  Widget _buildServiceItem(
    BuildContext context,
    bool isMobile,
    String pageId,
    String sectionId,
    String defaultText,
  ) {
    return FutureBuilder<String>(
      future: ContentHelper.getText(
        context,
        pageId,
        sectionId,
        defaultValue: defaultText,
      ),
      builder: (context, snapshot) {
        final text = snapshot.data ?? defaultText;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• ',
              style: TextStyle(
                fontFamily: 'AloeveraDisplaySemiBold',
                color: Colors.white,
                fontSize: isMobile ? 10.sp : 32.sp,
                height: 1.6,
              ),
            ),
            Expanded(
              child: Text(
                text,
                textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
                style: TextStyle(
                  fontFamily: 'AloeveraDisplaySemiBold',
                  color: Colors.white,
                  fontSize: isMobile ? 10.sp : 32.sp,
                  height: 1.6,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

