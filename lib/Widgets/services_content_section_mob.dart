import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:async';

import '../generated/assets.dart';
import 'custom_button.dart';

class ServicesContentSectionMob extends StatefulWidget {
  const ServicesContentSectionMob({super.key});

  @override
  State<ServicesContentSectionMob> createState() => _ServicesContentSectionState();
}

class _ServicesContentSectionState extends State<ServicesContentSectionMob>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  Timer? _timer;
  int timeRemaining = 10;
  bool isTimerRunning = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Service content data
  final List<Map<String, String>> serviceData = [
    {
      'title': 'LEASING',
      'description': 'We provide solutions based on experience, along with professional support and specialized analysis of the real estate market to help you make well informed decisions.',
    },
    {
      'title': 'PROPERTY',
      'description': 'Comprehensive property management services ensuring optimal performance and maintenance of your real estate assets with professional care and attention.',
    },
    {
      'title': 'CONSULTING',
      'description': 'Expert consulting to guide your real estate decisions with market insights, investment strategies, and professional recommendations.',
    },
    {
      'title': 'FRANCHISE',
      'description': 'Complete franchise development and management services to expand your business presence across multiple locations successfully.',
    },
    {
      'title': 'ASSET',
      'description': 'Professional property valuation services using industry-standard methodologies to determine accurate market values for your assets.',
    },
    {
      'title': 'MARKET',
      'description': 'In-depth real estate market research and analysis to identify trends, opportunities, and risks in your target markets.',
    },
    {
      'title': 'INVESTMENT',
      'description': 'Strategic investment guidance to maximize returns and minimize risks in your real estate portfolio with expert insights.',
    },
    {
      'title': 'DEVELOPMENT',
      'description': 'End-to-end real estate development services from planning and design to construction and delivery of quality properties.',
    },
    {
      'title': 'TENANT',
      'description': 'Professional tenant management services ensuring smooth operations, timely communications, and positive relationships.',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Fade animation for pagination
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();

    // Slide animation for content
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start from right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();

    _startTimer();
  }

  void _startTimer() {
    isTimerRunning = true;
    timeRemaining = 10; // Reset time
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isTimerRunning) {
        setState(() {
          timeRemaining--;
          if (timeRemaining <= 0) {
            currentIndex = (currentIndex + 1) % 9; // Cycle through 0-8
            timeRemaining = 10; // Reset for next cycle
            _animationController.reset();
            _animationController.forward();
            _slideController.reset();
            _slideController.forward();
          }
        });
      }
    });
  }

  void _toggleTimer() {
    setState(() {
      isTimerRunning = !isTimerRunning;
      if (isTimerRunning) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _onPaginationTap(int index) {
    setState(() {
      currentIndex = index;
    });
    // Restart timer after manual selection
    _timer?.cancel();
    _startTimer();
    _animationController.reset();
    _animationController.forward();
    _slideController.reset();
    _slideController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
          height: 786.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(Assets.imagesLearnServicesBackground), // your background image asset
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // dark overlay for readability
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(60.h),
            Text(
              'EXPLORE OUR SERVICES',
              style: TextStyle(
                fontFamily: Assets.fontsOptimal, // 👈 أضف هذا
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold, // سيختار ملف Optimal-Bold تلقائيًا
                letterSpacing: 2,
              ),
            ),

            Gap(40.h),

            // Service indicator (1-9)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(9, (index) {
                  final isActive = index == currentIndex;

                  return MouseRegion(
                    onEnter: (_) => _timer?.cancel(), // Pause timer on hover
                    onExit: (_) => _startTimer(), // Resume timer when mouse leaves
                    child: GestureDetector(
                      onTap: () => _onPaginationTap(index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Number above the box
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),

                          // Box itself
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: isActive ? Colors.red : Colors.transparent,
                                  border: Border.all(color: const Color(0xFFFFC700), width: 2),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                              // Connecting line between boxes
                              if (index < 8)
                                Container(
                                  width: 30,
                                  height: 2,
                                  color: const Color(0xFFFFC700),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            SizedBox(height: 40.h),

            // Service highlight section
            Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 1200.w),
              child: Column(
                children: [
                  // Service title with slide animation
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _slideController,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "IT' A ",
                              style: TextStyle(
                                fontFamily: Assets.fontsOptimal,
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: serviceData[currentIndex]['title']!,
                              style: TextStyle(
                                fontFamily: Assets.fontsOptimal,
                                color: const Color(0xFF8B0000),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            TextSpan(
                              text: " SERVICES",
                              style: TextStyle(
                                fontFamily: Assets.fontsOptimal,
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gap(30.h),
                  Center(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _slideController,
                        child: Text(
                          serviceData[currentIndex]['description']!,
                          style: TextStyle(
                            fontFamily: Assets.fontsAloeveraDisplaySemiBold,
                            color: Colors.white,
                            fontSize: 16.sp,
                            height: 1.6,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(12.h),
                  SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _slideController,
                        child: Container(
                          height: 300.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFC700),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // خلفية مزخرفة أو تدرج
                              Positioned.fill(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2.r),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFFFFC700),
                                          width: 1,            // Border thickness
                                        ),
                                        borderRadius: BorderRadius.circular(2), // Optional: rounded corners
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(2), // Same radius to clip image corners
                                        child: Image.asset(
                                          Assets.imagesLearnServices,
                                          fit: BoxFit.cover,
                                          key: ValueKey(currentIndex), // Force rebuild on index change
                                        ),
                                      ),
                                    )

                                ),
                              ),

                              // زر LEARN MORE في الأسفل إلى اليمين
                              Positioned(
                                bottom: 10.h,
                                right: 10.w,
                                child: ButtonStyles.learnMoreButtonMob(
                                  onPressed: () {
                                    // Add learn more action
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      );

  }
}
