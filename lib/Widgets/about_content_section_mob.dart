import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../generated/assets.dart';
import 'custom_button.dart';

class AboutContentSectionMob extends StatefulWidget {
  const AboutContentSectionMob({super.key});

  @override
  State<AboutContentSectionMob> createState() => _AboutContentSectionState();
}

class _AboutContentSectionState extends State<AboutContentSectionMob> {
  bool _isVisible = false;

  void _onVisibilityChanged(VisibilityInfo info) {
    // Show animation when at least 30% visible, hide when less than 10%
    if (info.visibleFraction >= 0.3 && !_isVisible) {
      setState(() {
        _isVisible = true;
      });
    } else if (info.visibleFraction < 0.1 && _isVisible) {
      setState(() {
        _isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('about-content-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        width: double.infinity,
        height: 786.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesAboutUsBackgroundMob),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(80.h),
            // ABOUT US title (all yellow like in image)
            AnimatedSlide(
              offset: _isVisible ? Offset.zero : const Offset(0, -0.3),
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeInOut,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'ABOUT ',
                        style: TextStyle(
                          fontFamily: 'OptimalBold',
                          color: const Color(0xFFF4ED47), // أصفر
                          fontSize: 28.sp,
                          letterSpacing: 3,
                        ),
                      ),
                      TextSpan(
                        text: 'US',
                        style: TextStyle(
                          fontFamily: 'OptimalBold',
                          color: Colors.white, // أبيض
                          fontSize: 28.sp,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Gap(20.h),

            // Text content with semi-transparent dark background
            AnimatedScale(
              scale: _isVisible ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeInOut,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4ED47).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'We provide solutions based on experience, with professional support and specialized analysis of the real estate market to help you make informed decisions. We provide solutions based on experience, along with professional support and specialized analysis of the real estate market to help you make informed decisions.',
                    textAlign: TextAlign.center, // ✅ يجعل النص في المنتصف
                    style: TextStyle(
                      fontFamily: 'AloeveraDisplaySemiBold',
                      color: Colors.white,
                      fontSize: 16.sp,
                      height: 1.8,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),

           const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Align(
                alignment: Alignment.bottomRight,
                child: AnimatedSlide(
                  offset: _isVisible ? Offset.zero : const Offset(0.5, 0),
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.easeInOut,
                    child: ButtonStyles.learnMoreButtonMob(
                      onPressed: () {
                        // Add learn more action
                      },
                    ),
                  ),
                ),
              ),
            ),
            Gap(40.h),
          ],
        ),


      ),
    );
  }
}
