import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:incm/Utilities/router_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/about_content_section.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../Widgets/floating_contact_buttons.dart';
import '../../Widgets/performance_highlights_section.dart';
import '../../Widgets/scroll_to_top_button.dart';
import '../../generated/assets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  static const String routeName = '/about';

  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with SingleTickerProviderStateMixin{
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;
  bool _isAddressHovered = false;
  final PageController _pageController = PageController(viewportFraction: MediaQuery.of(currentContext_!).size.width > 600 ? 0.33 : 1);
  int _currentPage = 0;

  final List<Map<String, String>> items = [
    {
      'title': 'Sorouh Developments',
      'image': Assets.imagesAboutUsBackground,
      'desc': 'Incomercial × Sorouh Developments A new vision for the future of real estate. Incomercial is leading the real estate consultation and leasing for the Centrada project',
    },
    {
      'title': 'Menassat Developments',
      'image': Assets.imagesCareerBackground,
      'desc': 'Incomercial × Menassat Developments A Continued Collaboration, Incomercial has been proudly leading the real estate consultation and leasing efforts for The Begonia Walk',
    },
    {
      'title': 'Annual 2024',
      'image': Assets.imagesAboutUsBackground,
      'desc': 'Our 2024 Annual – A Day to Remember Our Achievements and Hard Work',
    },
    {
      'title': 'Saudi Arabia Expansion',
      'image': Assets.imagesAboutUsBackground,
      'desc': 'Incomercial Moves Forward with Global Expansion, Entering the Saudi Arabian Market',
    },
  ];

  void _nextPage() {
    if (_currentPage < items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
  bool _isPrimaryColor = true;
  late Timer _timer;


  bool isDownloading = false;
  double progress = 0;

  Future<void> downloadFile() async {
    const url =
        'https://drive.google.com/uc?export=download&id=1iFzkiZYpEI0mfZMsEqkweFlNN4cXBCqw';
    const filename = 'cp_incm_2025.pdf';

    // ✅ Web version — use url_launcher
    if (kIsWeb) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return;
    }

    // ✅ Mobile / Desktop version
    if (Platform.isAndroid || Platform.isIOS) {
      if (await Permission.storage.request().isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }
    }

    setState(() {
      isDownloading = true;
      progress = 0;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/$filename';
      final dio = Dio();

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progress = received / total;
            });
          }
        },
      );

      setState(() {
        isDownloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded to $savePath')),
      );
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _hasAnimated = false;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.reset();
    // تبديل اللون كل 5 ثواني
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _isPrimaryColor = !_isPrimaryColor;
      });
    });
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction >= 0.3) {
      _hasAnimated = true;
      _animationController.forward();
    }
  }
  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: MediaQuery.of(context).size.width < 600 && !kIsWeb ? const BottomNavBarWidget(selected: SelectedBottomNavBar.aboutUs) : null,

        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: VisibilityDetector(
                key: const Key('about-content-section'),
                onVisibilityChanged: _onVisibilityChanged,
                child: Column(
                  children: [
                    if(MediaQuery.of(context).size.width > 600)
                    _buildOurMissionSection(context),
                    if(MediaQuery.of(context).size.width > 600)
                    _buildContactFormSection(context),
                    if(MediaQuery.of(context).size.width > 600)
                    _buildLatestNewsSection(context),
                    if(MediaQuery.of(context).size.width < 600)
                      _buildOurMissionSectionMob(context),
                    if(MediaQuery.of(context).size.width < 600)
                    _buildContactFormSectionMob(context),
                    if(MediaQuery.of(context).size.width < 600)
                    _buildLatestNewsSectionMob(context),
                    // Add padding at bottom for mobile when bottomNavigationBar is present
                    if(MediaQuery.of(context).size.width < 600 && !kIsWeb)
                      SizedBox(height: 100.h),
                    // _buildLocationSection(context, isMobile, isTablet),
                  ],
                ),
              ),
            ),
            MediaQuery.of(context).size.width >= 600 ?
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBar(),
            ) : const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CustomAppBarMob(),
            ),
            const FloatingContactButtons(),
            ScrollToTopButton(scrollController: _scrollController),
          ],
        ),
      ),
    );
  }

  Widget _buildOurMissionSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesAboutUsBackground2),
          fit: BoxFit.fill,
        ),
      ),
      width: double.infinity,
      height: 1200.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(
            padding: EdgeInsets.all(40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildSectionTitle('OUR MISSION'),
                Gap(20.h),
                _buildSectionText(
                  'We develop innovative real estate solutions that create new investment opportunities and deliver comprehensive services. We guide investors throughout their entire journey — from strategic consulting and project development to asset and facilities management — ensuring optimal returns on investment (ROI) in a market where we lead with expertise',
                ),
                Gap(60.h),
                _buildSectionTitle('OUR VISION'),
                Gap(20.h),
                _buildSectionText(
                  'To be the leading real estate company and the trusted partner for clients and developers seeking reliable real estate services and high- value investment opportunities in a secure, transparent, and competitive market',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) => Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: 'OptimalBold',
      color: const Color(0xFFF4ED47),
      fontSize: 80.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
  );

  Widget _buildSectionText(String text) => Container(
    width: 1400.w,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Color(0xFFF4ED47).withOpacity(0.2),
      borderRadius: BorderRadius.circular(0),
    ),
    child: Text(
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(
        color: Colors.white,
        fontSize: 26.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        height: 1.5,
      ),
    ),
  );


  Widget _buildContactFormSection(BuildContext context) {
    final containerColor = _isPrimaryColor ? const Color(0xFFC63424) : const Color(0xFFF4ED47);
    final textColor = _isPrimaryColor ? const Color(0xFFF4ED47) : const Color(0xFFC63424);
    return Stack(
      children:[


        Positioned.fill(child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesAboutUsBacground1),
              fit: BoxFit.fill,
            ),
          ),),),


        Positioned.fill(
          left: -560,
          child:Opacity(
            opacity: 0.2,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image.asset(
                height: double.infinity,
                width: double.infinity,
                Assets.imagesLogoINCM,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),


        Container(

        width: double.infinity,
        height: 1200.h,
        child: Center( // ✅ centers the inner content vertically & horizontally
          child: SingleChildScrollView(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: child,
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 500,
                    padding: EdgeInsets.all(40.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center, // ✅ makes sure text is vertically centered inside column
                      children: [
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'WHO ARE WE',
                                style: TextStyle(
                                  fontFamily: 'OptimalBold',
                                  color: const Color(0xFFF4ED47),
                                  fontSize: 80.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              TextSpan(
                                text: '?',
                                style: TextStyle(
                                  color: const Color(0xFFF4ED47),
                                  fontSize: 80.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'We were established in 2019 as a comprehensive real estate company, entering a competitive market with a clear vision and ambitious goals. Our unique synergy and team of experts have enabled us to stand out In the industry by offering a full spectrum of services tailored to diverse client needs \n\nThis strategic approach has allowed us to secure exclusive projects that showcase our capabilities and reinforce our credibility. Over the years, we have achieved significant milestones, built a trusted reputation, and earned a prestigious position within the real estate sector',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            height: 1.8,
                          ),
                        ),

                        Gap(40.h),
                        InkWell(
                          onTap: isDownloading ? null : downloadFile,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: _isPrimaryColor ? const Color(0xFFC63424) : const Color(0xFFF4ED47),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "CLICK TO DOWNLOAD OUR COMPANY PROFILE",
                              style: TextStyle(
                                fontFamily: 'OptimalBold',
                                color: _isPrimaryColor ? const Color(0xFFF4ED47) : const Color(0xFFC63424),
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
            ]
    );
  }

  Widget _buildLatestNewsSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesAboutUsBackground2),
          fit: BoxFit.fill,
        ),
      ),
      width: double.infinity,
      height: 1200.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(
            padding: EdgeInsets.all(40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildSectionTitle('LATEST NEWS & EVENTS'),
                Gap(40.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 60.h),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 700.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: items.length,
                                onPageChanged: (index) {
                                  setState(() => _currentPage = index);
                                },
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFFF4ED47),
                                                width: 0.6,            // border width
                                              ),
                                            ),
                                            child: Image.asset(
                                              item['image']!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                            height: 500.h,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            item['title']!,
                                            style: TextStyle(
                                              fontFamily: 'OptimalBold',
                                              color: const Color(0xFFF4ED47),
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                                            child: Text(
                                              item['desc']!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.sp,
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Left arrow
                            Positioned(
                              top: 165,
                              left: 0,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                                iconSize: 40,
                                onPressed: _previousPage,
                              ),
                            ),


                            // Right arrow
                            Positioned(
                              top: 165,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                                iconSize: 40,
                                onPressed: _nextPage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Dots indicator
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: List.generate(
                      //     items.length,
                      //         (index) => AnimatedContainer(
                      //       duration: const Duration(milliseconds: 300),
                      //       margin: const EdgeInsets.symmetric(horizontal: 4),
                      //       width: _currentPage == index ? 32 : 8,
                      //       height: 8,
                      //       decoration: BoxDecoration(
                      //         color: _currentPage == index
                      //             ? const Color(0xFFF4ED47)
                      //             : Colors.white.withOpacity(0.4),
                      //         borderRadius: BorderRadius.circular(4),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }








  Widget _buildOurMissionSectionMob(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesAboutUsBackground2),
          fit: BoxFit.fill,
        ),
      ),
      width: double.infinity,
      height: 786.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildSectionTitleMob('OUR MISSION'),
                Gap(5.h),
                _buildSectionTextMob(
                  'We develop innovative real estate solutions that create new investment opportunities and deliver comprehensive services. We guide investors throughout their entire journey — from strategic consulting and project development to asset and facilities management — ensuring optimal returns on investment (ROI) in a market where we lead with expertise',
                ),
                Gap(20.h),
                _buildSectionTitleMob('OUR VISION'),
                Gap(5.h),
                _buildSectionTextMob(
                  'To be the leading real estate company and the trusted partner for clients and developers seeking reliable real estate services and high- value investment opportunities in a secure, transparent, and competitive market',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitleMob(String text) => Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontFamily: 'OptimalBold',
      color: const Color(0xFFF4ED47),
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    ),
  );

  Widget _buildSectionTextMob(String text) => Container(
    width: 1400.w,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,

      ),
    ),
  );
  
  Widget _buildContactFormSectionMob(BuildContext context) {
    return Stack(

      children:[


        Positioned.fill(child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.imagesAboutUsBackgroundMob1),
              fit: BoxFit.fill,
            ),
          ),),),


        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                Assets.imagesINCM,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        Container(
        width: double.infinity,
        height: 786.h,
        child:SingleChildScrollView(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center, // ✅ makes sure text is vertically centered inside column
                children: [
                  Gap(80.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'WHO ARE WE',
                          style: TextStyle(
                            fontFamily: 'OptimalBold',
                            color: const Color(0xFFF4ED47),
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        TextSpan(
                          text: '?',
                          style: TextStyle(
                            color: const Color(0xFFF4ED47),
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4ED47).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'We were established in 2019 as a comprehensive real estate company, entering a competitive market with a clear vision and ambitious goals. Our unique synergy and team of experts have enabled us to stand out In the industry by offering a full spectrum of services tailored to diverse client needs \n\nThis strategic approach has allowed us to secure exclusive projects that showcase our capabilities and reinforce our credibility. Over the years, we have achieved significant milestones, built a trusted reputation, and earned a prestigious position within the real estate sector',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        height: 1.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]
    );
  }

  Widget _buildLatestNewsSectionMob(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesAboutUsBackgroundMob2),
          fit: BoxFit.fill,
        ),
      ),
      width: double.infinity,
      height: 786.h,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: Center( // 👈 centers everything vertically + horizontally
          child: Container(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center, // 👈 vertical center
              children: [
                _buildSectionTitleMob('LATEST NEWS & EVENTS'),
                Gap(20.h),
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 550.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: items.length,
                              onPageChanged: (index) {
                                setState(() => _currentPage = index);
                              },
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xFFF4ED47),
                                              width: 0.6,            // border width
                                            ),
                                          ),
                                          child: Image.asset(
                                            item['image']!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                          height: 380.h,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          item['title']!,
                                          style: TextStyle(
                                            fontFamily: 'OptimalBold',
                                            color: const Color(0xFFF4ED47),
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                                          child: Text(
                                            item['desc']!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Left arrow
                            Positioned(
                              top: 135,
                              left: 0,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                                iconSize: 40,
                                onPressed: _previousPage,
                              ),
                            ),

                            // Right arrow
                            Positioned(
                              top: 135,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                                iconSize: 40,
                                onPressed: _nextPage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Dots indicator
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: List.generate(
                      //     items.length,
                      //         (index) => AnimatedContainer(
                      //       duration: const Duration(milliseconds: 300),
                      //       margin: const EdgeInsets.symmetric(horizontal: 4),
                      //       width: _currentPage == index ? 32 : 8,
                      //       height: 8,
                      //       decoration: BoxDecoration(
                      //         color: _currentPage == index
                      //             ? const Color(0xFFF4ED47)
                      //             : Colors.white.withOpacity(0.4),
                      //         borderRadius: BorderRadius.circular(4),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

