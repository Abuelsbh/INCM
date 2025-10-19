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
              //left: 80.w,
              child: Padding(
                padding: EdgeInsets.only(left: 80.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                                  fontSize: 60.sp,
                                  letterSpacing: 3,
                                ),
                              ),
                              TextSpan(
                                text: 'US',
                                style: TextStyle(
                                  fontFamily: 'OptimalBold',
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
                        width: MediaQuery.of(context).size.width * 0.35,
                        padding: EdgeInsets.all(30.w),
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
                            fontSize: 34.sp,
                            height: 1.8,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                            ),
              ),
          ),

          // LEARN MORE button positioned at bottom right
          Positioned(
            bottom: 80.h,
            right: 80.w,
            child: AnimatedSlide(
              offset: _isVisible ? Offset.zero : const Offset(0.5, 0),
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeInOut,
                child: ButtonStyles.learnMoreButton(
                  onPressed: () {
                    // Add learn more action
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
