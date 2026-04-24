import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:incm/Utilities/shared_preferences.dart';
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
import '../../../generated/assets.dart';
import '../../../core/Language/locales.dart';
import '../../../core/Language/app_languages.dart';
import '../../../Utilities/font_helper.dart';
import 'package:provider/provider.dart';

class CorporateLeasingScreen extends StatelessWidget {
  static const String routeName = '/services/corporate-leasing';

  const CorporateLeasingScreen({super.key});

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
                        'corporate-leasing',
                        isMobile: isMobile,
                        fit: BoxFit.fill,
                      ),
                      builder: (context, snapshot) {
                        DecorationImage? decorationImage = snapshot.data;

                        // Fallback to asset if Firebase image not available
                        if (decorationImage == null) {
                          decorationImage = DecorationImage(
                            image: AssetImage(Assets.imagesLearnServices),
                            fit: BoxFit.fill,
                          );
                        }

                        return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: decorationImage,
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(isMobile ? 20.w : 60.w, isMobile ? 65.h : 220.h, 20.w, isMobile ? 0.h:120.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ترتيب العناوين حسب اللغة
                                  // بالإنجليزية: CORPORATE ثم LEASING
                                  // بالعربية: الإيجار ثم الشركات (العكس)
                                  Builder(
                                    builder: (context) {
                                      final isArabic =
                                          Provider.of<AppLanguage>(context, listen: false).appLang ==
                                              Languages.ar;

                                      return Align(
                                        alignment: Alignment.centerLeft, // ثابت على الشمال دايمًا
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, // مكانه شمال
                                          mainAxisSize: MainAxisSize.min,
                                          children: isArabic
                                              ? [
                                            // =======================
                                            // Arabic (RTL text - Left container)
                                            // =======================
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: DynamicText(
                                                pageId: 'corporate-leasing',
                                                sectionId: 'hero-title-2',
                                                defaultValue: 'LEASING'.tr(context),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: 'NotoKufiArabicSemiBold',
                                                  color: const Color(0xFFF4ED47),
                                                  fontSize: isMobile ? 17.sp : 90.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: DynamicText(
                                                pageId: 'corporate-leasing',
                                                sectionId: 'hero-title-1',
                                                defaultValue: 'CORPORATE'.tr(context),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontFamily: 'NotoKufiArabicSemiBold',
                                                  color: Colors.white,
                                                  fontSize: isMobile ? 17.sp : 80.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ]
                                              : [
                                            // =======================
                                            // English (LTR)
                                            // =======================
                                            Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: DynamicText(
                                                pageId: 'corporate-leasing',
                                                sectionId: 'hero-title-1',
                                                defaultValue: 'CORPORATE'.tr(context),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: Colors.white,
                                                  fontSize: isMobile ? 17.sp : 80.sp,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 2,
                                                ),
                                              ),
                                            ),
                                            Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: DynamicText(
                                                pageId: 'corporate-leasing',
                                                sectionId: 'hero-title-2',
                                                defaultValue: 'LEASING'.tr(context),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                  color: const Color(0xFFF4ED47),
                                                  fontSize: isMobile ? 17.sp : 90.sp,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 2,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: isMobile? 18.h: 80.h),
                                  Builder(
                                    builder: (context) {
                                      final isArabic =
                                          Provider.of<AppLanguage>(context, listen: false).appLang ==
                                              Languages.ar;

                                      return Align(
                                        alignment: Alignment.centerLeft, // مكان ثابت شمال
                                        child: SizedBox(
                                          width: isMobile ? 170.w : 800.w,
                                          child: Directionality(
                                            textDirection:
                                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                                            child: DynamicText(
                                              pageId: 'corporate-leasing',
                                              sectionId: 'hero-subtitle',
                                              defaultValue: 'YOUR_WORKSPACE_SHAPES',
                                              textAlign:
                                              isArabic ? TextAlign.right : TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                                                color: Colors.white,
                                                fontSize: isMobile ? 9.sp : 40.sp,
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
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
                                                // Translate if the value looks like a translation key
                                                String servicesText = servicesSnapshot.data ?? 'OUR_SERVICES';
                                                if (servicesText == 'OUR_SERVICES' || (servicesText.contains('_') && servicesText == servicesText.toUpperCase())) {
                                                  servicesText = servicesText.tr(context);
                                                }

                                                String includeText = includeSnapshot.data ?? 'INCLUDE';
                                                if (includeText == 'INCLUDE' || (includeText.contains('_') && includeText == includeText.toUpperCase())) {
                                                  includeText = includeText.tr(context);
                                                }

                                                return RichText(
                                                  textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '$servicesText ',
                                                        style: TextStyle(
                                                          fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                          color: Colors.white,
                                                          fontSize: isMobile ? 22.sp : 70.sp,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: includeText,
                                                        style: TextStyle(
                                                          fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                          color: const Color(0xFFF4ED47),
                                                          fontSize: isMobile ? 22.sp : 70.sp,
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
                                        Gap(isMobile ? 10.h : 140.h),
                                        ClientsLogosSection(
                                          pageId: 'corporate-leasing', // Fetch logos from Firebase for this page
                                          backgroundColor: Colors.grey[900]!,
                                          logos: const [Assets.logosINCM],
                                          visibleLogosCount: 5,
                                        ),
                                      ],
                                    ),
                                  ),


                                  //Gap(isMobile? 10.h : 350.h),
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                  const ContentServiceSection(sourceTag: 'Corporate leasing'),
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
                //textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
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
                fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                color: Colors.white,
                fontSize: isMobile ? 10.sp : 32.sp,
                height: 1.6,
              ),
            ),
            Expanded(
              child: Text(
                text,
                //textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
                softWrap: true,
                style: TextStyle(
                  fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
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

