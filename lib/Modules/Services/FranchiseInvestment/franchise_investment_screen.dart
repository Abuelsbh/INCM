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

class FranchiseInvestmentScreen extends StatelessWidget {
  static const String routeName = '/services/franchise-investment';

  const FranchiseInvestmentScreen({super.key});

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
                        image: AssetImage(Assets.imagesService8),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          Assets.imagesService8,
                          width: double.infinity,
                          fit: BoxFit.none,
                          color: Colors.transparent,
                        ),
                        // هنا المحتوى اللي انت عايزه فوق الصورة
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              isMobile ? 10.w : 150.w,
                              isMobile ? 55.h : 150.h,
                              isMobile ? 10.w : 150.w,
                              20.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('FRANCHISE',
                                style: TextStyle(
                                  fontFamily: 'OptimalBold',
                                  color: Colors.white,
                                  fontSize: isMobile ? 16.sp : 70.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text('INVESTMENT SERVICE',
                                style: TextStyle(
                                  fontFamily: 'OptimalBold',
                                  color: const Color(0xFFF4ED47),
                                  fontSize: isMobile ? 16.sp : 75.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gap(isMobile ? 2.h : 40.h),
                              SizedBox(
                                width: isMobile ? double.infinity : double.infinity,
                                child: Text(
                                  'A franchise lets you start your success story ahead of the rest.',
                                  style: TextStyle(
                                    fontFamily: 'AloeveraDisplaySemiBold',
                                    color: Colors.white,
                                    fontSize: isMobile ? 10.sp : 38.sp,
                                    height: isMobile ? 2 : 1.6,
                                  ),
                                ),
                              ),

                              Gap(isMobile ? 12.h : 180.h),

                              _buildDescriptionBox(
                                context: context,
                                isMobile: isMobile,
                                text: 'For investors seeking stable, and scalable opportunities in the franchise sector, we provide expert guidance in identifying, evaluating, and securing high-performing franchise brands.',
                                highlightText: 'For investors seeking',
                              ),

                              SizedBox(height: isMobile ? 8.h : 50.h),
                              _buildDescriptionBox(
                                context: context,
                                isMobile: isMobile,
                                text: 'From market research and brand vetting to location sourcing and lease negotiation, we offer end to end support throughout the entire investment process',
                                highlightText: 'From market research and brand vetting to',
                              ),
                              // Description paragraphs section
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: isMobile ? 180.w : 1100.w,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [


                                    SizedBox(height: isMobile ? 8.h : 50.h),
                                    _buildDescriptionBox(
                                      width: 600,
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'We offer a smart and secure investment opportunity, providing access to successful brands, proven operational methods, a trusted name, and high ROI.',
                                      highlightText: 'We offer',
                                    ),
                                  ],
                                ),
                              ),

                              Gap(isMobile ? 100.h : 600.h),
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
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'OUR SERVICES ',
                                            style: TextStyle(
                                              fontFamily: 'OptimalBold',
                                              color: Colors.white,
                                              fontSize: isMobile ? 18.sp : 70.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'INCLUDE',
                                            style: TextStyle(
                                              fontFamily: 'OptimalBold',
                                              color: const Color(0xFFF4ED47),
                                              fontSize: isMobile ? 18.sp : 70.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: isMobile ? 10.h : 60.h),

                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: '. Access to a curated portfolio of over 100 successful international brands. \n\n. Expert guidance to select the brand that best fits your goals, budget, and growth potential. \n\n. Comprehensive end-to-end support-from initial setup and operational training to launch and beyond.',
                                      width: 1200.w
                                    ),
                                  ],
                                ),
                              ),

                              Gap(isMobile ? 40.h : 420.h),
                              ClientsLogosSection(
                                backgroundColor: Colors.grey[900]!,
                                logos: [
                                  Assets.logosLogo2,
                                  Assets.logosLogo3,
                                  Assets.logosLogo4,
                                  Assets.logosLogo6,
                                  Assets.logosLogo2,
                                  Assets.logosLogo2,
                                  Assets.logosLogo3,
                                  Assets.logosLogo4,
                                  Assets.logosLogo6,
                                  Assets.logosLogo2,
                                ],
                                visibleLogosCount: 5,
                              ),
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

  Widget _buildDescriptionBox({
    required BuildContext context,
    required bool isMobile,
    required String text,
    String? highlightText,
    double? width,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8.w : 28.w, vertical: isMobile ? 4.w : 32.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(isMobile ? 20.r : 50.r),
      ),
      child: highlightText != null
          ? _buildHighlightedText(text, highlightText, isMobile)
          : Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 10.sp : 42.sp,
        ),
      ),
    );
  }

  Widget _buildHighlightedText(String text, String highlightText, bool isMobile) {
    final highlightIndex = text.toLowerCase().indexOf(highlightText.toLowerCase());
    
    if (highlightIndex == -1) {
      return Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 10.sp : 32.sp,
          height: isMobile ? 1.3 : 1.8,
        ),
      );
    }

    final beforeText = text.substring(0, highlightIndex);
    final highlightedText = text.substring(highlightIndex, highlightIndex + highlightText.length);
    final afterText = text.substring(highlightIndex + highlightText.length);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: beforeText,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 10.sp : 42.sp,
              height: isMobile ? 1.3 : 1.8,
            ),
          ),
          TextSpan(
            text: highlightedText,
            style: TextStyle(
              color: const Color(0xFFF4ED47),
              fontSize: isMobile ? 10.sp : 42.sp,
              height: isMobile ? 1.3 : 1.8,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: afterText,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 10.sp : 42.sp,
              height: isMobile ? 1.3 : 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
