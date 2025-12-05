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
import '../../../generated/assets.dart';
import '../../../core/Language/locales.dart';

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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.imagesService1),
                        fit: BoxFit.contain, // الخلفية بحجمها الطبيعي
                      ),
                    ),
                    child: Stack(
                      children: [
                        // الصورة الشفافة لحساب الارتفاع
                        Image.asset(
                          Assets.imagesService1,
                          width: double.infinity,
                          fit: BoxFit.none,
                          color: Colors.transparent,
                        ),

                        // هنا المحتوى اللي انت عايزه فوق الصورة
                        Padding(
                          padding: EdgeInsets.fromLTRB(isMobile ? 20.w : 60.w, isMobile ? 60.h : 300.h, 20.w, isMobile ? 0.h:120.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                'CORPORATE'.tr,
                                style: TextStyle(
                                  fontFamily: 'OptimalBold',
                                  color: Colors.white,
                                  fontSize: isMobile ? 17.sp : 80.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                'LEASING'.tr,
                                style: TextStyle(
                                  fontFamily: 'OptimalBold',
                                  color: const Color(0xFFF4ED47),
                                  fontSize: isMobile ? 17.sp : 90.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(height: isMobile? 8.h: 80.h),
                              SizedBox(
                                width: isMobile ? 170.w : 900.w,
                                child: Text(
                                  'YOUR_WORKSPACE_SHAPES'.tr,
                                  style: TextStyle(
                                    fontFamily: 'AloeveraDisplaySemiBold',
                                    color: Colors.white,
                                    fontSize: isMobile ? 9.sp : 42.sp,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              
                              Gap(isMobile? 120.h : 700.h),
                              // Experience and Strategic Locations Section
                              Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildBulletPoint(
                                      context,
                                      isMobile,
                                      'WE_HAVE_EXTENSIVE_EXPERIENCE'.tr,
                                    ),
                                    SizedBox(height: 10.h),
                                    _buildBulletPoint(
                                      context,
                                      isMobile,
                                      'STRATEGIC_LOCATIONS'.tr,
                                    ),
                                  ],
                                ),
                              ),

                              Gap(isMobile? 20.h : 300.h),
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
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'OUR_SERVICES'.tr + ' ',
                                            style: TextStyle(
                                              fontFamily: 'OptimalBold',
                                              color: Colors.white,
                                              fontSize: isMobile ? 22.sp : 70.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'INCLUDE'.tr,
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
                                            'LARGE_INVENTORY'.tr,
                                          ),
                                          SizedBox(height: isMobile ? 8.h:20.h),
                                          _buildServiceItem(
                                            context,
                                            isMobile,
                                            'FLEXIBLE_PAYMENT'.tr,
                                          ),
                                          SizedBox(height: isMobile ? 8.h:20.h),
                                          _buildServiceItem(
                                            context,
                                            isMobile,
                                            'SMART_SOLUTIONS'.tr,
                                          ),
                                          SizedBox(height: isMobile ? 8.h:20.h),
                                          _buildServiceItem(
                                            context,
                                            isMobile,
                                            'FULL_SUPPORT'.tr,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),


                              Gap(isMobile? 10.h : 350.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const ContentServiceSection(),
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

  Widget _buildBulletPoint(BuildContext context, bool isMobile, String text) {
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

  Widget _buildServiceItem(BuildContext context, bool isMobile, String text) {
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
  }
}

