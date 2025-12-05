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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(isMobile ? Assets.imagesService3Mob : Assets.imagesService3Web),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          isMobile ? Assets.imagesService3Mob : Assets.imagesService3Web,
                          width: double.infinity,
                          fit: BoxFit.none,
                          color: Colors.transparent,
                        ),
                        Positioned(
                          top: isMobile ? 100.h : 320.h,
                          right: isMobile ? 40.w : 260.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('MARKETING',
                                style: TextStyle(
                                  fontFamily: 'OptimalBold',
                                  color: Colors.black,
                                  fontSize: isMobile ? 16.sp : 80.sp,
                                  fontWeight: FontWeight.bold,
                                ),),

                              Gap(isMobile ? 4.h : 20.h),
                              Text('SERVICE',
                                style: TextStyle(
                                  fontFamily: 'OptimalBold',
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
                                child: Text(
                                  'YOU MAY OFFER A HIGHLY COMPETITIVE SERVICE, BUT WITHOUT MARKETING, WHO WILL KNOW?',
                                  style: TextStyle(
                                    fontFamily: 'AloeveraDisplaySemiBold',
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
                              isMobile ? 80.h : 300.h,
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
                              //           fontFamily: 'OptimalBold',
                              //           color: Colors.white,
                              //           fontSize: isMobile ? 32.sp : 70.sp,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //       TextSpan(
                              //         text: ' SERVICE',
                              //         style: TextStyle(
                              //           fontFamily: 'OptimalBold',
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
                              //       fontFamily: 'AloeveraDisplaySemiBold',
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
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'We provide comprehensive marketing solutions tailored for developers, agents, and real estate projects seeking to promote their listings effectively and achieve measurable results.',
                                    ),

                                    if(!isMobile)
                                      Column(
                                        children: [
                                          SizedBox(height: isMobile ? 8.h : 30.h),
                                          _buildDescriptionBox(
                                            context: context,
                                            isMobile: isMobile,
                                            text: 'Our Strategy is built on a deep understanding of each unit\'s unique features, enabling us to craft targeted, results-driven campaigns that reach the right audience.',
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
                                    SizedBox(height: isMobile ? 170.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Our Strategy is built on a deep understanding of each unit\'s unique features, enabling us to craft targeted, results-driven campaigns that reach the right audience.',
                                    ),
                                  ],
                                ),

                              Gap(isMobile ? 20.h : 300.h),
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
                                    Text('OUR SERVICE INCLUDES',
                                      style: TextStyle(
                                        fontFamily: 'OptimalBold',
                                        color: const Color(0xFFF4ED47),
                                        fontSize: isMobile ? 18.sp : 70.sp,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),

                                    SizedBox(height: isMobile ? 10.h : 40.h),


                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text:  'Strategic marketing consultation and planning.',
                                      width: 1200.w,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: isMobile ? 8.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Brand creation, including company profile and visual identity.',
                                      width: 1200.w,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: isMobile ? 8.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Digital marketing campaigns across relevant platforms.',
                                      width: 1200.w,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Gap(isMobile ? 14.h : 40.h),
                              ClientsLogosSection(
                                backgroundColor: Colors.grey[900]!,
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
    double? width,
    bool isBold = false,
    Color? highlightColor,
    TextAlign? textAlign
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 6.w : 28.w, vertical:  isMobile ? 8.w : 32.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(isMobile ? 20.r : 50.r),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: textAlign,
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

