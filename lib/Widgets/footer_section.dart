import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../generated/assets.dart';

class FooterSection extends StatefulWidget {
  const FooterSection({super.key});

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection> {
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
                            'FOLLOW US',
                            style: TextStyle(
                              color: const Color(0xFFC63424),
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(width: 28.w),
                          _buildSocialIcon(Assets.iconsFace),
                          SizedBox(width: 16.w),
                          _buildSocialIcon(Assets.iconsInsta),
                          SizedBox(width: 16.w),
                          _buildSocialIcon(Assets.iconsLinked),
                          SizedBox(width: 16.w),
                          _buildSocialIcon(Assets.iconsTik),
                        ],
                      ),


                      SizedBox(height: 40.h),

                      // Contact information
                      _AnimatedContactInfo(
                        icon: Assets.iconsMail,
                        text: 'Incomercial@gmail.com',
                        isClickable: true,
                        onTap: () => _sendEmail('Incomercial@gmail.com'),
                      ),

                      SizedBox(height: 16.h),

                      _AnimatedContactInfo(
                        icon: Assets.iconsLocation,
                        text: '14 A/2 Admin building, New Cairo, Egypt',
                        isClickable: false,
                      ),

                      SizedBox(height: 16.h),

                      _AnimatedContactInfo(
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
                      Text(
                        'DOWNLOAD OUR \nAPP NOW!',
                        style: TextStyle(
                          color: const Color(0xFF000000),
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // QR Code placeholder
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),

                            ),
                            child: Center(
                              child: Image.asset(
                                Assets.iconsGooglePlay,
                                width: 60.w,
                                height: 60.h,
                              ),
                            ),
                          ),

                          Gap(30.w),
                          Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),

                            ),
                            child: Center(
                              child: Image.asset(
                                Assets.iconsAppStore,
                                width: 60.w,
                                height: 60.h,
                              ),
                            ),
                          ),
                        ],
                      ),

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
                    'INCOMERCIAL REAL ESTATE 2025',
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
                    'Powered by E-code Wave',
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

  Widget _buildSocialIcon(String icon) {
    return Container(
      width: 40.w,
      height: 40.h,

      child: Image.asset(
        icon,
        height: 20.r,
        width: 20.r,
      ),
    );
  }

}

// Widget منفصل للتأثيرات الحركية
class _AnimatedContactInfo extends StatefulWidget {
  final String icon;
  final String text;
  final bool isClickable;
  final VoidCallback? onTap;

  const _AnimatedContactInfo({
    Key? key,
    required this.icon,
    required this.text,
    this.isClickable = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<_AnimatedContactInfo> createState() => _AnimatedContactInfoState();
}

class _AnimatedContactInfoState extends State<_AnimatedContactInfo>
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
      end: const Offset(0, -0.2), // يتحرك للأعلى قليلاً
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
              height: 22.r,
              width: 22.r,
            ),
            SizedBox(width: 12.w),
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
                        fontSize: 24.sp,
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
