import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../generated/assets.dart';
import '../core/Language/locales.dart';
import 'animated_contact_info.dart';

class FooterSection extends StatefulWidget {
  const FooterSection({super.key});

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection> with SingleTickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFF000000), // أسود
      end: const Color(0xFFC63424), // أحمر
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));

    // تشغيل animation بشكل متكرر
    _colorController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _openLink(String link) async {
    final Uri googleMapsUri = Uri.parse(link);

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450.h,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(Assets.imagesFollowUsBackground), // your background image asset
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: EdgeInsets.all(60.w),
            child: Row(
              children: [
                // Left side - Contact info and social media
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Follow Us
                      // Social media icons
                      Row(
                        children: [
                          Text(
                            'FOLLOW_US'.tr,
                            style: TextStyle(
                              fontFamily: 'AloeveraDisplayBold',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 28.sp,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(width: 28.w),
                          AnimatedContactInfo(icon: Assets.iconsFace, text: '',isClickable: true,
                            onTap: () => _openLink('https://www.facebook.com/Incomercial.egypt'),iconSize: 40.r,),
                          SizedBox(width: 8.w),
                          AnimatedContactInfo(icon: Assets.iconsInsta, text: '',isClickable: true,
                            onTap: () => _openLink('https://www.instagram.com/incomercial.egypt/'),iconSize: 40.r,),
                          SizedBox(width: 8.w),
                          AnimatedContactInfo(icon: Assets.iconsLinked, text: '',isClickable: true,
                            onTap: () => _openLink('https://www.linkedin.com/company/incomercial-egypt/'),iconSize: 40.r,),
                          SizedBox(width: 8.w),
                          AnimatedContactInfo(icon: Assets.iconsTik, text: '',isClickable: true,
                            onTap: () => _openLink('https://www.tiktok.com/@incomercial.egypt'),iconSize: 40.r,),
                        ],
                      ),


                      SizedBox(height: 40.h),

                      // Contact information
                      AnimatedContactInfo(
                        icon: Assets.iconsMail,
                        text: 'Incomercial@gmail.com',
                        isClickable: true,
                        onTap: () => _sendEmail('Incomercial@gmail.com'),
                      ),

                      SizedBox(height: 16.h),

                      AnimatedContactInfo(
                        icon: Assets.iconsLocation,
                        text: '14 A/2 Admin building, New Cairo, Egypt',
                        isClickable: true,
                        onTap: () => _openLink('https://maps.app.goo.gl/xcCQnFRxJymzVune6'),
                      ),

                      SizedBox(height: 16.h),

                      AnimatedContactInfo(
                        icon: Assets.iconsCall,
                        text: '0111-032-7777',
                        isClickable: true,
                        onTap: () => _makePhoneCall('0111-032-7777'),
                      ),
                    ],
                  ),
                ),

                // Right side - App download
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _colorController,
                        builder: (context, child) {
                          return Text(
                            'DOWNLOAD_OUR_APP'.tr,
                            style: TextStyle(
                              fontFamily: 'AloeveraDisplayBold',
                              color: _colorAnimation.value ?? const Color(0xFF000000),
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 10.h),

                      // QR Code placeholder
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //
                      //
                      //     Gap(30.w),
                      //     Container(
                      //       width: 60.w,
                      //       height: 60.h,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(8.r),
                      //
                      //       ),
                      //       child: Center(
                      //         child: Image.asset(
                      //           Assets.iconsAppStore,
                      //           width: 60.w,
                      //           height: 60.h,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      Image.asset(Assets.imagesDownloadAppStore,height: 80.h, width: 300.w,),
                      Image.asset(Assets.imagesDownloadGooglePlay,height: 120.h, width: 450.w,)

                    ],
                  ),
                ),
              ],
            ),
          ),

          // Copyright
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Center(
                  child: Text(
                    'INCOMERCIAL_REAL_ESTATE_2025'.tr,
                    style: TextStyle(
                      color: const Color(0xFF000000),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Gap(10.h),
                Center(
                  child: Text(
                    'POWERED_BY'.tr,
                    style: TextStyle(
                      color: const Color(0xFF000000),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة لفتح البريد الإلكتروني
  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  // دالة لفتح رابط الاتصال
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }


}
