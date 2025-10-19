import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../generated/assets.dart';
import 'animated_logos_footer.dart';

class PerformanceHighlightsSection extends StatefulWidget {
  const PerformanceHighlightsSection({super.key});

  @override
  State<PerformanceHighlightsSection> createState() => _PerformanceHighlightsSectionState();
}

class _PerformanceHighlightsSectionState extends State<PerformanceHighlightsSection> {
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
      key: const Key('performance-highlights-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        height: 1200.h,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesPerformanceBackground), // your background image asset
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.h),
        child: _buildPerformanceSection(),
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        AnimatedScale(
          scale: _isVisible ? 1.0 : 0.8,
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'OptimalBold',
                  fontSize: 50.sp,
                  letterSpacing: 2,
                  color: Colors.white, // اللون الافتراضي للنص
                ),
                children: const [
                  TextSpan(
                    text: 'ACHIEVEMENTS ',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: 'HIGHLIGHTS:',
                    style: TextStyle(color: Color(0xFFF4ED47)), // أصفر
                  ),
                ],
              ),
            ),
          ),
        ),


        SizedBox(height: 120.h),
        
        // Metrics Grid
        Container(


          child: Row(
            children: [
              // Left column metrics
              Expanded(
                child: Column(
                  children: [
                    _buildMetricCard(
                      '+2,000',
                      'Successful lease agreements across commercial units',
                    ),
                    SizedBox(height: 150.h),
                    _buildMetricCard(
                      '+100',
                      'Of assets under active facility management',
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: 700.w),
              
              // Right column metrics
              Expanded(
                child: Column(
                  children: [
                    _buildMetricCard(
                      '+100',
                      'Franchise agreements established across key markets',
                    ),
                    SizedBox(height: 150.h),
                    _buildMetricCard(
                      '+120',
                      'Real estate consulting engagements completed',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String number, String description) {
    // Extract the numeric value (remove '+' and commas)
    final int targetValue = int.tryParse(number.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final bool hasPlus = number.startsWith('+');

    return AnimatedSlide(
      offset: _isVisible ? Offset.zero : const Offset(0, 0.3),
      duration: const Duration(milliseconds: 2000),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 2000),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: 300.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: 0, 
                  end: _isVisible ? targetValue.toDouble() : 0,
                ),
                duration: const Duration(seconds: 2),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Text(
                    "${hasPlus ? '+' : ''}${value.toInt().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'OptimalBold',
                      color: const Color(0xFFF4ED47),
                      fontSize: 50.sp,
                    ),
                  );
                },
              ),
              SizedBox(height: 8.h),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'AloeveraDisplayRegular',
                  color: Colors.white,
                  fontSize: 28.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
