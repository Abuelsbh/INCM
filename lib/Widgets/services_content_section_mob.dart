import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';

import '../core/Language/locales.dart';
import '../generated/assets.dart';
import 'custom_button.dart';
import '../Modules/Services/Consultation/consultation_screen.dart';
import '../Modules/Services/RetailLeasing/retail_leasing_screen.dart';
import '../Modules/Services/MedicalLeasing/medical_leasing_screen.dart';
import '../Modules/Services/CorporateLeasing/corporate_leasing_screen.dart';
import '../Modules/Services/FacilityManagement/facility_management_screen.dart';
import '../Modules/Services/FranchiseInvestment/franchise_investment_screen.dart';
import '../Modules/Services/PrimaryInvestment/primary_investment_screen.dart';
import '../Modules/Services/Marketing/marketing_screen.dart';

class ServicesContentSectionMob extends StatefulWidget {
  const ServicesContentSectionMob({super.key});

  @override
  State<ServicesContentSectionMob> createState() => _ServicesContentSectionState();
}

class _ServicesContentSectionState extends State<ServicesContentSectionMob>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  Timer? _timer;
  int timeRemaining = 5;
  bool isTimerRunning = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Service content data
  List<Map<String, String>> getServiceData(BuildContext context) => [
    {
      'title': 'CONSULTATION',
      'description': 'CONSULTATION_DESCRIPTION'.tr(context),
      'route': ConsultationScreen.routeName,
    },
    {
      'title': 'RETAIL_LEASING',
      'description': 'RETAIL_LEASING_DESCRIPTION'.tr(context),
      'route': RetailLeasingScreen.routeName,
    },
    {
      'title': 'MEDICAL_LEASING',
      'description': 'MEDICAL_LEASING_DESCRIPTION'.tr(context),
      'route': MedicalLeasingScreen.routeName,
    },
    {
      'title': 'CORPORATE_LEASING',
      'description': 'CORPORATE_LEASING_DESCRIPTION'.tr(context),
      'route': CorporateLeasingScreen.routeName,
    },
    {
      'title': 'FACILITY_MANAGEMENT',
      'description': 'FACILITY_MANAGEMENT_DESCRIPTION'.tr(context),
      'route': FacilityManagementScreen.routeName,
    },
    {
      'title': 'FRANCHISE_INVESTMENT',
      'description': 'FRANCHISE_INVESTMENT_DESCRIPTION'.tr(context),
      'route': FranchiseInvestmentScreen.routeName,
    },
    {
      'title': 'PRIMARY_INVESTMENT',
      'description': 'PRIMARY_INVESTMENT_DESCRIPTION'.tr(context),
      'route': PrimaryInvestmentScreen.routeName,
    },
    {
      'title': 'MARKETING',
      'description': 'MARKETING_DESCRIPTION'.tr(context),
      'route': MarketingScreen.routeName,
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

    // Slide animation for content (slide in from left)
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Start from left
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

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _startTimer() {
    // Always cancel existing timer first to prevent multiple timers
    _cancelTimer();
    
    if (!mounted) return;
    
    isTimerRunning = true;
    timeRemaining = 5; // Reset time
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !isTimerRunning) {
        timer.cancel();
        return;
      }
      
      setState(() {
        timeRemaining--;
        if (timeRemaining <= 0) {
          currentIndex = (currentIndex + 1) % getServiceData(context).length; // Cycle through 0-8
          timeRemaining = 5; // Reset for next cycle
          _animationController.reset();
          _animationController.forward();
          _slideController.reset();
          _slideController.forward();
        }
      });
    });
  }

  void _restartTimer() {
    if (!mounted) return;
    _cancelTimer();
    _startTimer();
  }

  void _toggleTimer() {
    if (!mounted) return;
    setState(() {
      isTimerRunning = !isTimerRunning;
      if (isTimerRunning) {
        _startTimer();
      } else {
        _cancelTimer();
      }
    });
  }

  void _onPaginationTap(int index) {
    if (!mounted) return;
    
    setState(() {
      currentIndex = index;
    });
    
    // Cancel and restart timer after manual selection
    _restartTimer();
    
    _animationController.reset();
    _animationController.forward();
    _slideController.reset();
    _slideController.forward();
  }

  @override
  void dispose() {
    _cancelTimer();
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
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'EXPLORE_OUR_SERVICES'.tr(context),
              style: TextStyle(
                fontFamily: 'OptimalBold',
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold, // سيختار ملف Optimal-Bold تلقائيًا
                letterSpacing: 2,
              ),
            ),

            Gap(40.h),

            // Service indicator (1-9)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(getServiceData(context).length, (index) {
                final isActive = index == currentIndex;

                return MouseRegion(
                  onEnter: (_) {
                    // Pause timer on hover
                    _timer?.cancel();
                    isTimerRunning = false;
                  },
                  onExit: (_) {
                    // Resume timer when mouse leaves
                    if (mounted) {
                      _restartTimer();
                    }
                  },
                  child: GestureDetector(
                    onTap: () => _onPaginationTap(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Number above the box - perfectly centered
                        SizedBox(
                          width: 12, // Same width as box
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),

                        // Box itself with connecting line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: isActive ? Colors.red : Colors.transparent,
                                border: Border.all(color: const Color(0xFFF4ED47), width: 2),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            // Connecting line between boxes
                            if (index < getServiceData(context).length - 1)
                              Container(
                                width: 30,
                                height: 2,
                                color: const Color(0xFFF4ED47),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            Gap(40.h),

            // Service highlight section
            Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 1200.w),
              child: Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'ITS_A'.tr(context),
                        style: TextStyle(
                          fontFamily: 'OptimalBold',
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          getServiceData(context)[currentIndex]['title']!.tr(context),
                          style: TextStyle(
                            fontFamily: 'OptimalBold',
                            color: currentIndex % 2 == 0 ? const Color(0xFFC63424) : const Color(0xFFF4ED47),
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),


                      Text(
                        'SERVICE'.tr(context),
                        style: TextStyle(
                          fontFamily: 'OptimalBold',
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Gap(30.h),
                  Center(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child:
                      Text(
                        getServiceData(context)[currentIndex]['description']!,
                        //textAlign: TextAlign.justify,
                        maxLines: 9,                    // ✅ limit to 6 lines
                        overflow: TextOverflow.ellipsis, // ✅ show "..."
                        style: TextStyle(
                          fontFamily: 'AloeveraDisplaySemiBold',
                          color: Colors.white,
                          fontSize: 14.sp,
                          height: 1.3,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  Gap(12.h),
                  SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      height: 280.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4ED47),
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
                                      color: const Color(0xFFF4ED47),
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
                              context: context,
                              onPressed: () {
                                context.go(getServiceData(context)[currentIndex]['route']!);
                              },
                            ),
                          ),
                        ],
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
