import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../generated/assets.dart';
import 'animated_contact_info.dart';

class FooterSectionMob extends StatefulWidget {
  const FooterSectionMob({super.key});

  @override
  State<FooterSectionMob> createState() => _FooterSectionMobState();
}

class _FooterSectionMobState extends State<FooterSectionMob> {
  Future<void> _openLink(String link) async {
    final Uri googleMapsUri = Uri.parse(link);

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    }
  }
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      print("Running on Web");
    } else {
      print("Running as Mobile App");
    }
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesFollowUsBackgroundMob),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: EdgeInsets.all(10.w),
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
                            'FOLLOW US',
                            style: TextStyle(
                              color: const Color(0xFFC63424),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // _buildSocialIcon(Assets.iconsFace),
                          // SizedBox(width: 10.w),
                          // _buildSocialIcon(Assets.iconsInsta),
                          // SizedBox(width: 10.w),
                          // _buildSocialIcon(Assets.iconsLinked),
                          // SizedBox(width: 10.w),
                          // _buildSocialIcon(Assets.iconsTik),
                          // SizedBox(width: 28.w),



                          AnimatedContactInfo(icon: Assets.iconsFace, text: '',isClickable: true,
                            onTap: () => _openLink('https://www.facebook.com/Incomercial.egypt'),iconSize: 24.r,),
                          SizedBox(width: 8.w),
                          AnimatedContactInfo(icon: Assets.iconsInsta, text: '',isClickable: true,
                            onTap: () => _openLink('https://www.instagram.com/incomercial.egypt/'),iconSize: 24.r,),
                          SizedBox(width: 8.w),
                          AnimatedContactInfo(icon: Assets.iconsLinked, text: '',isClickable: true,
                            onTap: () => _openLink('https://www.linkedin.com/company/incomercial-egypt/'),iconSize: 24.r,),
                          SizedBox(width: 8.w),
                          AnimatedContactInfo(icon: Assets.iconsTik, text: '',isClickable: true,
                            onTap: () => _openLink('https://www.tiktok.com/@incomercial.egypt'),iconSize: 24.r,),

                        ],
                      ),


                      SizedBox(height: 6.h),


                      _AnimatedContactInfoMob(
                        icon: Assets.iconsMail,
                        text: 'Incomercial@gmail.com',
                        isClickable: true,
                        onTap: () => _sendEmail('Incomercial@gmail.com'),
                      ),

                      SizedBox(height: 4.h),

                      _AnimatedContactInfoMob(
                        icon: Assets.iconsLocation,
                        text: '14 A/2 Admin building, New Cairo, Egypt',
                        isClickable: true,
                        onTap: () => _openLink('https://maps.app.goo.gl/xcCQnFRxJymzVune6'),
                      ),


                      SizedBox(height: 4.h),

                      _AnimatedContactInfoMob(
                        icon: Assets.iconsCall,
                        text: '0111-032-7777',
                        isClickable: true,
                        onTap: () => _makePhoneCall('0111-032-7777'),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),

          // Copyright
          // Copyright
          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Center(
                  child: Text(
                    'INCOMERCIAL REAL ESTATE 2025',
                    style: TextStyle(
                      color: const Color(0xFF000000),
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Powered by E-code Wave',
                    style: TextStyle(
                      color: const Color(0xFF000000),
                      fontSize: 6.sp,
                      fontWeight: FontWeight.w500,
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

  Widget _buildSocialIcon(String icon) {
    return Container(
      width: 24.w,
      height: 24.h,
      child:  Image.asset(
        icon,

        height: 20.r,
        width: 20.r,
      ),
    );
  }

}

// Widget منفصل للتأثيرات الحركية - نسخة الموبايل
class _AnimatedContactInfoMob extends StatefulWidget {
  final String icon;
  final String text;
  final bool isClickable;
  final VoidCallback? onTap;

  const _AnimatedContactInfoMob({
    Key? key,
    required this.icon,
    required this.text,
    this.isClickable = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<_AnimatedContactInfoMob> createState() => _AnimatedContactInfoMobState();
}

class _AnimatedContactInfoMobState extends State<_AnimatedContactInfoMob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.3), // يتحرك للأعلى قليلاً
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: const Color(0xFF000000),
      end: const Color(0xFFC63424), // يتغير للون الأحمر
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isClickable && widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (widget.isClickable) {
          _controller.forward();
        }
      },
      onExit: (_) {
        if (widget.isClickable) {
          _controller.reverse();
        }
      },
      child: GestureDetector(
        onTap: _handleTap,
        child: Row(
          children: [
            Image.asset(
              widget.icon,
              color: const Color(0xFF000000),
              height: 20.r,
              width: 20.r,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: SlideTransition(
                position: _offsetAnimation,
                child: AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return Text(
                      widget.text,
                      style: TextStyle(
                        color: _colorAnimation.value ?? const Color(0xFF000000),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
