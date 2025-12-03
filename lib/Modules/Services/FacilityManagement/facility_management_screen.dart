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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(isMobile ? Assets.imagesService5Mob : Assets.imagesService5Web),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          isMobile ? Assets.imagesService5Mob : Assets.imagesService5Web,
                          width: double.infinity,
                          fit: BoxFit.none,
                          color: Colors.transparent,
                        ),
                        Positioned(
                          top: isMobile ? 110.h : 350.h,
                          right: isMobile ? 28.w : 240.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('FACILITY',
                                style: TextStyle(
                                  fontFamily: 'OptimalBold',
                                  color: Colors.black,
                                  fontSize: isMobile ? 16.sp : 60.sp,
                                  fontWeight: FontWeight.bold,
                                ),),

                              Gap(isMobile ? 4.h : 20.h),
                              Text('MANAGEMENT',
                                style: TextStyle(
                                  fontFamily: 'OptimalBold',
                                  color: Colors.black,
                                  fontSize: isMobile ? 16.sp : 60.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Gap(isMobile ? 8.h : 40.h),
                              SizedBox(
                                width: isMobile ? 120.w : 450.w,
                                child: Text(
                                  'Day-to-day operations are our responsibility, so you can focus on growing your business.',
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
                              isMobile ? 60.h : 300.h,
                              isMobile ? 10.w : 50.w,
                              20.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('FACILITY',
                                    style: TextStyle(
                                      fontFamily: 'OptimalBold',
                                      color: Colors.white,
                                      fontSize: isMobile ? 18.sp : 70.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(' MANAGEMENT',
                                    style: TextStyle(
                                      fontFamily: 'OptimalBold',
                                      color: const Color(0xFFF4ED47),
                                      fontSize: isMobile ? 18.sp : 75.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: isMobile ? 200.w: 1050.w, // set your desired max width here
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [


                                    SizedBox(height: isMobile ? 24.h : 50.h),
                                    // _buildDescriptionBox(
                                    //   context: context,
                                    //   isMobile: isMobile,
                                    //   text: 'To ensure the seamless operation, safety, and sustainability of commercial properties, we provide comprehensive property and facility management solutions.',
                                    // ),
                                    //
                                    // SizedBox(height: isMobile ? 8.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Our services cover day-to-day operations, preventive maintenance, and the optimization of building systems and infrastructure, ensuring your property runs efficiently and reliably.',
                                    ),

                                    SizedBox(height: isMobile ? 8.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Our experienced team focuses on operational excellence, cost-efficiency, and long-term asset performance, helping you maximize the return on investment (ROI).',
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
                                            text: 'OUR SERVICE ',
                                            style: TextStyle(
                                              fontFamily: 'OptimalBold',
                                              color: Colors.white,
                                              fontSize: isMobile ? 18.sp : 70.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'INCLUDES',
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
                                    SizedBox(height: isMobile ? 10.h : 40.h),


                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text:  'Comprehensive operational support to keep your property running smoothly.',
                                      width: 1200.w,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: isMobile ? 8.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Strategic asset management to optimize performance and maximize ROI.',
                                      width: 1200.w,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: isMobile ? 8.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Strategic asset management to optimize performance and maximize ROI.',
                                      width: 1200.w,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Gap(isMobile ? 10.h : 120.h),
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
    double? width,
    bool isBold = false,
    Color? highlightColor,
    TextAlign? textAlign
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10.w : 28.w, vertical:  isMobile ? 8.w : 32.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF4ED47).withOpacity(0.2),
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
          ),
        ),
      ),
    );
  }

}

