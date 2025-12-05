import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';

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

class ServicesContentSection extends StatefulWidget {
  const ServicesContentSection({super.key});

  @override
  State<ServicesContentSection> createState() => _ServicesContentSectionState();
}

class _ServicesContentSectionState extends State<ServicesContentSection>
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
  final List<Map<String, String>> serviceData = [
    {
      'title': 'CONSULTATION',
      'description': 'Our real estate consulting services are designed to provide clients with strategic insights and expert guidance across all stages of projects development, acquisition, and investment.',
      'route': ConsultationScreen.routeName,
    },
    {
      'title': 'RETAIL LEASING',
      'description': 'We provide comprehensive support across all stages of the retail leasing process, offering a wide selection of units in prime locations with flexible space configurations. By curating the right tenant mix — including brands, services, and experiences — we foster strong customer engagement and maintain a balanced, high- performing commercial environment.',
      'route': RetailLeasingScreen.routeName,
    },
    {
      'title': 'MEDICAL LEASING',
      'description': 'We offer dedicated medical leasing services tailored to meet the unique requirements of healthcare providers, medical practitioners, and institutional tenants. With a deep understanding of the complexities of medical real estate, we help clients secure optimal spaces that align with both clinical needs and long-term business objectives.',
      'route': MedicalLeasingScreen.routeName,
    },
    {
      'title': 'CORPORATE LEASING',
      'description': 'We have extensive experience in commercial real estate leasing transactions. Whether you are looking for an office space, an entire building, or even an industrial facility, we provide all that and more — with a variety of spaces tailored to different needs and in strategic locations close to business hubs.',
      'route': CorporateLeasingScreen.routeName,
    },
    {
      'title': 'FACILITY MANAGEMENT',
      'description': 'To ensure the seamless operation, safety, and sustainability of commercial properties, we provide comprehensive property and facility management solutions. Our services cover day- to-day operations, preventive maintenance, and the optimization of building systems and infrastructure.',
      'route': FacilityManagementScreen.routeName,
    },
    {
      'title': 'FRANCHISE INVESTMENT',
      'description': 'For investors seeking stable, and scalable opportunities in the franchise sector, we provide expert guidance in identifying, evaluating, and securing high-performing franchise brands. From market research and brand vetting to location sourcing and lease negotiation.',
      'route': FranchiseInvestmentScreen.routeName,
    },
    {
      'title': 'PRIMARY INVESTMENT',
      'description': 'We specialize in sourcing and securing high- potential real estate assets at early development stages or during market entry. By collaborating closely with investors, we identify opportunities in emerging markets, growth corridors, and strategically located assets with strong long-term return potential.',
      'route': PrimaryInvestmentScreen.routeName,
    },
    {
      'title': 'MARKETING',
      'description': 'We provide comprehensive marketing solutions tailored for developers, agents, and real estate projects seeking to promote their listings effectively and achieve measurable results. Our strategy is built on a deep understanding of each unit’s unique features, enabling us to craft targeted, results-driven campaigns that reach the right audience.',
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
          currentIndex = (currentIndex + 1) % serviceData.length; // Cycle through 0-8
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
          height: 1200.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(Assets.imagesLearnServicesBackground), // your background image asset
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              'EXPLORE OUR SERVICES',
              style: TextStyle(
                fontFamily: 'OptimalBold',
                color: Colors.white,
                fontSize: 60.sp,
                fontWeight: FontWeight.bold, // سيختار ملف Optimal-Bold تلقائيًا
                letterSpacing: 2,
              ),
            ),

            SizedBox(height: 80.h),

            // Service indicator (1-9)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(serviceData.length, (index) {
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
                          width: 18, // Same width as box
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFFFFFFFF),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: isActive ? const Color(0xFFC63424) : Colors.transparent,
                                border: Border.all(color: const Color(0xFFF4ED47), width: 2),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            // Connecting line between boxes
                            if (index < serviceData.length - 1)
                              Container(
                                width: 50,
                                height: 3,
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

            SizedBox(height: 60.h),

            // Service highlight section
            Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 1400.w),
              child: Column(
                children: [
                  // Service title with slide animation

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "IT'S A ",
                        style: TextStyle(
                          fontFamily: 'OptimalBold',
                          color: Colors.white,
                          fontSize: 60.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          serviceData[currentIndex]['title']!,
                          style: TextStyle(
                            fontFamily: 'OptimalBold',
                            color: currentIndex % 2 == 0 ? const Color(0xFFC63424) : const Color(0xFFF4ED47),
                            fontSize: 60.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),


                      Text(
                        " SERVICE",
                        style: TextStyle(
                          fontFamily: 'OptimalBold',
                          color: Colors.white,
                          fontSize: 60.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Gap(60.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left content
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(right: 40.w),
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Text(
                              serviceData[currentIndex]['description']!,
                              textAlign: TextAlign.justify,
                              maxLines: 8,                    // ✅ limit to 6 lines
                              overflow: TextOverflow.ellipsis, // ✅ show "..."
                              style: TextStyle(
                                fontFamily: 'AloeveraDisplaySemiBold',
                                color: Colors.white,
                                fontSize: 26.sp,
                                height: 2,

                              ),
                            ),
                          ),
                        ),
                      ),


                      Gap(40.w),
                      // Right visual with slide animation
                      Expanded(
                        flex: 2,
                        child:  SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            height: 400.h,
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
                                  bottom: 20.h,
                                  right: 20.w,
                                  child: ButtonStyles.learnMoreButton(
                                    onPressed: () {
                                      context.go(serviceData[currentIndex]['route']!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      );

  }
}
