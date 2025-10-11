import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../generated/assets.dart';
import 'custom_button.dart';

class AboutContentSection extends StatefulWidget {
  const AboutContentSection({super.key});

  @override
  State<AboutContentSection> createState() => _AboutContentSectionState();
}

class _AboutContentSectionState extends State<AboutContentSection> {
  bool _hasAnimated = false;

  void _onVisibilityChanged(VisibilityInfo info) {
    // Start animation when at least 30% of the widget is visible
    if (!_hasAnimated && info.visibleFraction >= 0.3) {
      setState(() {
        _hasAnimated = true;
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
        height: 1200.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesAboutUsBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Content positioned on the left side like in the image
            Positioned(
              left: 80.w,
              top: 200.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ABOUT US title (all yellow like in image)
                  AnimatedOpacity(
                    opacity: _hasAnimated ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'ABOUT ',
                        style: TextStyle(
                          color: const Color(0xFFFFC700), // أصفر
                          fontSize: 60.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),
                      TextSpan(
                        text: 'US',
                        style: TextStyle(
                          color: Colors.white, // أبيض
                          fontSize: 60.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                    ),
                  ),

                Gap(20.h),

                // Text content with semi-transparent dark background
                AnimatedOpacity(
                  opacity: _hasAnimated ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeInOut,
                  child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  padding: EdgeInsets.all(30.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC700).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'We provide solutions based on experience, with professional support and specialized analysis of the real estate market to help you make informed decisions. We provide solutions based on experience, along with professional support and specialized analysis of the real estate market to help you make informed decisions.',
                    textAlign: TextAlign.center, // ✅ يجعل النص في المنتصف
                    style: TextStyle(
                      fontFamily: Assets.fontsAloeveraDisplaySemiBold,
                      color: Colors.white,
                      fontSize: 36.sp,
                      height: 1.8,
                      letterSpacing: 1,
                    ),
                  ),
                  ),
                ),
              ],
            ),
          ),

          // LEARN MORE button positioned at bottom right
          Positioned(
            bottom: 80.h,
            right: 80.w,
            child: AnimatedOpacity(
              opacity: _hasAnimated ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeInOut,
              child: ButtonStyles.learnMoreButton(
                onPressed: () {
                  // Add learn more action
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
