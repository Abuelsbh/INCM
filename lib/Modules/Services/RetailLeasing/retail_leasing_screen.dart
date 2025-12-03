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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(isMobile ? Assets.imagesService7Mob : Assets.imagesService7),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Stack(
                      children: [
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
                                  Text('RETAIL',
                                    style: TextStyle(
                                      fontFamily: 'OptimalBold',
                                      color: Colors.white,
                                      fontSize: isMobile ? 18.sp : 70.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(' LEASING SERVICE',
                                    style: TextStyle(
                                      fontFamily: 'OptimalBold',
                                      color: const Color(0xFFF4ED47),
                                      fontSize: isMobile ? 18.sp : 75.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),


                                ],
                              ),
                              Gap(0.w),
                              Text(
                                'Your Ideal unit, always ready - exactly where you want it',
                                style: TextStyle(
                                  fontFamily: 'AloeveraDisplaySemiBold',
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
                                    _buildDescriptionBox2(
                                      context: context,
                                      isMobile: isMobile,
                                      text1: 'We provide comprehensive support',
                                      text2: ' across all stages of the retail leasing process, offering a wide selection of units in prime locations with flexible space configurations.',
                                    ),
                                    // SizedBox(height: isMobile ? 10.h : 30.h),
                                    // _buildDescriptionBox2(
                                    //   context: context,
                                    //   isMobile: isMobile,
                                    //   text1: 'By curating the right tenant mix -',
                                    //   text2: ' including brands, services, and experiences - we foster strong customer engagement and maintain a balanced, high-performing commercial environment.',
                                    // ),
                                    SizedBox(height: isMobile ? 200.h : 1000.h),
                                    _buildDescriptionBox2(
                                      context: context,
                                      isMobile: isMobile,
                                      text1: 'Through our strategic',
                                      text2: 'By curating the right tenant mix — including brands, services, and experiences — we foster strong customer engagement and maintain a balanced, high-performing commercial environment.',
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
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'OUR SERVICES ',
                                            style: TextStyle(
                                              fontFamily: 'OptimalBold',
                                              color: Colors.white,
                                              fontSize: isMobile ? 12.sp : 70.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'INCLUDE',
                                            style: TextStyle(
                                              fontFamily: 'OptimalBold',
                                              color: const Color(0xFFF4ED47),
                                              fontSize: isMobile ? 12.sp : 70.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: isMobile? 10.h: 40.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Diverse commercial units in prime locations',
                                      width: 1200.w
                                    ),
                                    SizedBox(height: isMobile ? 10.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Creating the perfect tenant mix to ensure higher traffic',
                                      width: 1200.w
                                    ),
                                    SizedBox(height: isMobile ? 10.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Customized solutions in pricing and space, tailored to suit every need',
                                      width: 1200.w
                                    ),
                                    SizedBox(height: isMobile ? 10.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Access to exclusive projects',
                                      width: 1200.w
                                    ),
                                    SizedBox(height: isMobile ? 10.h : 30.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'After-leasing service and follow-up',
                                      width: 1200.w
                                    ),
                                  ],
                                ),
                              ),
                              Gap(isMobile ? 20.h : 180.h),
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
    required BuildContext context, required bool isMobile, required String text, double? width}) {
    return Container(
      width: width,
      padding: EdgeInsets.all(isMobile ? 8.w : 24.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          text,
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

