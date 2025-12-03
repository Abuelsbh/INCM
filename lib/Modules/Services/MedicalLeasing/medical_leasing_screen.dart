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

class MedicalLeasingScreen extends StatelessWidget {
  static const String routeName = '/services/medical-leasing';

  const MedicalLeasingScreen({super.key});

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
                        image: AssetImage(isMobile ? Assets.imagesService4Mob : Assets.imagesService4Web),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          isMobile ? Assets.imagesService4Mob : Assets.imagesService4Web,
                          width: double.infinity,
                          fit: BoxFit.none,
                          color: Colors.transparent,
                        ),
                        // هنا المحتوى اللي انت عايزه فوق الصورة
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              isMobile ? 10.w : 50.w,
                              isMobile ? 70.h : 200.h,
                              isMobile ? 10.w : 50.w,
                              20.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: isMobile ?  MainAxisAlignment.center : MainAxisAlignment.start ,
                                crossAxisAlignment: isMobile ?  CrossAxisAlignment.center : CrossAxisAlignment.start ,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'MEDICAL',
                                          style: TextStyle(
                                            fontFamily: 'OptimalBold',
                                            color: Colors.white,
                                            fontSize: isMobile ? 20.sp : 70.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' SERVICE',
                                          style: TextStyle(
                                            fontFamily: 'OptimalBold',
                                            color: const Color(0xFFF4ED47),
                                            fontSize: isMobile ? 20.sp : 75.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Gap(isMobile ? 0.h : 40.h),
                              if(!isMobile)
                              Container(
                                height: 2.h,
                                width: 350,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4ED47),
                                  borderRadius: BorderRadius.circular(32.r),
                                ),
                              ),
                              Gap(isMobile ? 10.h : 40.h),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 800, // set your desired max width here
                                ),
                                child: Text(
                                  'Meeting your specific requirements for a medical unit can be challenging but we make It possible.',
                                  style: TextStyle(
                                    fontFamily: 'AloeveraDisplaySemiBold',
                                    color: Colors.white,
                                    fontSize: isMobile ? 12.sp : 38.sp,
                                  ),
                                ),
                              ),
                              Gap(isMobile ? 20.h : 70.h),
                              // Description paragraphs section
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: 800, // set your desired max width here
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: isMobile ? 220.w : double.infinity,
                                      child: _buildDescriptionBox(
                                        context: context,
                                        isMobile: isMobile,
                                        text: 'We offer dedicated medical leasing services tailored to meet the unique requirements of healthcare providers, medical practitioners, and institutional tenants.',
                                      ),

                                    ),
                                    SizedBox(height: 10.h),
                                    SizedBox(
                                      width: isMobile ? 280.w : double.infinity,
                                      child: _buildDescriptionBox(
                                        context: context,
                                        isMobile: isMobile,
                                        text: 'With a deep understanding of the complexities of medical real estate, we help clients secure optimal spaces that align with both clinical needs and long term business objectives.',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(isMobile ? 10.h : 160.h),
                              // Our Services Include Section
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 20.w : 40.w,
                                  vertical: isMobile ? 10.h: 40.h,
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
                                              fontSize: isMobile ? 22.sp : 70.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'INCLUDES',
                                            style: TextStyle(
                                              fontFamily: 'OptimalBold',
                                              color: const Color(0xFFF4ED47),
                                              fontSize: isMobile ? 22.sp : 70.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    _buildDescriptionBox(
                                        context: context,
                                        isMobile: isMobile,
                                        text: 'Exclusive healthcare projects for medical professionals',
                                        width: 1200.w
                                    ),
                                    SizedBox(height: 10.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Safe, modern, and compliant environments ensuring health and care standards',
                                      width: 1200.w
                                    ),
                                    SizedBox(height: 10.h),
                                    _buildDescriptionBox(
                                      context: context,
                                      isMobile: isMobile,
                                      text: 'Tailored medical units designed to meet all your requirements',
                                      width: 1200.w
                                    ),


                                  ],
                                ),
                              ),
                              Gap(isMobile ? 0.h : 120.h),
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
      padding: EdgeInsets.all(isMobile ? 8.w : 12.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 12.sp : 40.sp,
            height: isMobile? 1.3:1.8,
          ),
        ),
      ),
    );
  }
}

