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
      key: const Key('performance-highlights-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        height: 900.h,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesPerformanceBackground), // your background image asset
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // dark overlay for readability
              BlendMode.darken,
            ),
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
        AnimatedOpacity(
          opacity: _hasAnimated ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.white, // اللون الافتراضي للنص
              ),
              children: const [
                TextSpan(
                  text: 'PERFORMANCE ',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: 'HIGHLIGHTS:',
                  style: TextStyle(color: Color(0xFFFFC700)), // أصفر
                ),
              ],
            ),
          ),
        ),


        SizedBox(height: 50.h),
        
        // Metrics Grid
        Container(

          constraints: BoxConstraints(maxWidth: 1200.w),
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
                    SizedBox(height: 100.h),
                    _buildMetricCard(
                      '+100',
                      'Of assets under active facility management',
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: 500.w),
              
              // Right column metrics
              Expanded(
                child: Column(
                  children: [
                    _buildMetricCard(
                      '+100',
                      'Franchise agreements established across key markets',
                    ),
                    SizedBox(height: 100.h),
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

    return AnimatedOpacity(
      opacity: _hasAnimated ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      child: SizedBox(
        width: 200.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0, 
                end: _hasAnimated ? targetValue.toDouble() : 0,
              ),
              duration: const Duration(seconds: 3),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Text(
                  "${hasPlus ? '+' : ''}${value.toInt().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Assets.fontsOptimal,
                    color: const Color(0xFFFFC700),
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Assets.fontsAloeveraDisplaySemiBold,
                color: Colors.white,
                fontSize: 20.sp,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
