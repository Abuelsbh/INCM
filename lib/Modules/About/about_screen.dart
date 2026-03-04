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
import '../../core/Language/locales.dart';
import '../../core/Language/app_languages.dart';
import '../../Utilities/font_helper.dart';
import 'package:provider/provider.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/about_content_section.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../Widgets/floating_contact_buttons.dart';
import '../../Widgets/performance_highlights_section.dart';
import '../../Widgets/scroll_to_top_button.dart';
import '../../Widgets/footer_section.dart';
import '../../Widgets/footer_section_mob.dart';
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
  PageController? _pageController;
  int _currentPage = 0;
  bool _pageControllerInitialized = false;

  List<Map<String, String>> get items => [
    {
      'title': 'SOROUH_DEVELOPMENTS_TITLE'.tr(context),
      'image': Assets.imagesAboutUsBackground,
      'desc': 'SOROUH_DEVELOPMENTS_DESC'.tr(context),
    },
    {
      'title': 'MENASSAT_DEVELOPMENTS_TITLE'.tr(context),
      'image': Assets.imagesCareerBackground,
      'desc': 'MENASSAT_DEVELOPMENTS_DESC'.tr(context),
    },
    {
      'title': 'ANNUAL_2024_TITLE'.tr(context),
      'image': Assets.imagesAboutUsBackground,
      'desc': 'ANNUAL_2024_DESC'.tr(context),
    },
    {
      'title': 'SAUDI_ARABIA_EXPANSION_TITLE'.tr(context),
      'image': Assets.imagesAboutUsBackground,
      'desc': 'SAUDI_ARABIA_EXPANSION_DESC'.tr(context),
    },
  ];

  void _nextPage() {
    if (_pageController == null) return;
    if (_currentPage < items.length - 1) {
      _pageController!.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Loop: from last image go to first
      _pageController!.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_pageController == null) return;
    if (_currentPage > 0) {
      _pageController!.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Loop: from first image go to last
      _pageController!.animateToPage(
        items.length - 1,
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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('STORAGE_PERMISSION_DENIED'.tr(context))),
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

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'DOWNLOADED_TO'.tr(context)} $savePath')),
      );
    } catch (e) {
      setState(() {
        isDownloading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'DOWNLOAD_FAILED'.tr(context)} $e')),
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
    // PageController will be initialized in didChangeDependencies
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
    // Start animation after first frame to ensure it works on mobile
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasAnimated) {
        _hasAnimated = true;
        _animationController.forward();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize PageController based on screen width
    if (!_pageControllerInitialized) {
      final screenWidth = MediaQuery.of(context).size.width;
      final viewportFraction = screenWidth > 600 ? 0.33 : 1.0;
      _pageController = PageController(viewportFraction: viewportFraction);
      _pageControllerInitialized = true;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController?.dispose();
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
                      Column(
                        children: [
                          _buildContactFormSection(context),
                          Container(
                            height: 2400.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(Assets.imagesCareerViewWeb),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildOurMissionSection(context),
                                _buildLatestNewsSection(context),
                              ],
                            ),
                          )

                        ],
                      ),



                    if(MediaQuery.of(context).size.width < 600)
                    Column(
                      children: [
                        _buildContactFormSectionMob(context),
                        Container(
                          height: 1600.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.imagesCareerViewMob),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildOurMissionSectionMob(context),
                              _buildLatestNewsSectionMob(context),
                            ],
                          ),
                        )

                      ],
                    ),


                    // Footer
                    if(MediaQuery.of(context).size.width >= 600)
                      const FooterSection()
                    else if(kIsWeb)
                      const FooterSectionMob(),
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
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesAboutUsBackground2),
      //     fit: BoxFit.fill,
      //   ),
      // ),
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
                _buildSectionTitle('OUR_VISION'.tr(context)),
                Gap(20.h),
                _buildSectionText(
                  'OUR_VISION_TEXT'.tr(context),
                ),
                Gap(60.h),

                _buildSectionTitle('OUR_MISSION'.tr(context)),
                Gap(20.h),
                _buildSectionText(
                  'OUR_MISSION_TEXT'.tr(context),
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
      fontFamily: getLocalizedFont(context, 'OptimalBold'),
      color: const Color(0xFFF4ED47),
      fontSize: 80.sp,
      fontWeight: FontWeight.bold,
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
      //textAlign: TextAlign.justify,
      style: TextStyle(
        color: Colors.white,
        fontSize: 26.sp,
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
    ),
  );


  Widget _buildContactFormSection(BuildContext context) {



    return Consumer<AppLanguage>(
      builder: (context, appLanguage, _) {
        final isArabic = appLanguage.appLang == Languages.ar;
        return Stack(
            children:[
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(isArabic ? -1.0 : 1.0, 1.0),
                child: Container(
                  width: double.infinity,
                  height: 1200.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.imagesAboutUsBacground1),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              // Positioned.fill(child: Container(
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage(Assets.imagesAboutUsBacground1),
              //       fit: BoxFit.fill,
              //     ),
              //   ),),),

              Positioned.fill(
                left: isArabic ? 0 : -560 ,
                right: !isArabic ? 0 : -560 ,
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
                      child: Consumer<AppLanguage>(
                        builder: (context, appLang, child) {
                          final isRTL = appLang.appLang == Languages.ar;
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 80.w),
                            child: Align(
                              alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.only(right: isRTL ? 200.w : 0),
                                width: 600,
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
                                            text: 'WHO_ARE_WE'.tr(context),
                                            style: TextStyle(
                                              fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                              color: const Color(0xFFF4ED47),
                                              fontSize: 80.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'WHO_ARE_WE_QUESTION'.tr(context),
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
                                      'WE_WERE_ESTABLISHED_FULL'.tr(context),
                                      //textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
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
                                          "CLICK_TO_DOWNLOAD_PROFILE".tr(context),
                                          style: TextStyle(
                                            fontFamily: getLocalizedFont(context, 'OptimalBold'),
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
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ]
        );

      },
    );

  }

  Widget _buildLatestNewsSection(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesAboutUsBackground2),
      //     fit: BoxFit.fill,
      //   ),
      // ),
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
                _buildSectionTitle('LATEST_NEWS_EVENTS'.tr(context)),
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
                              child: _pageController != null ? PageView.builder(
                                controller: _pageController!,
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
                                              fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                              color: const Color(0xFFF4ED47),
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.bold,
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
                              ) : const SizedBox.shrink(),
                            ),

                            // Left arrow
                            Positioned(
                              top: 165,
                              left: 0,
                              child: Builder(
                                builder: (context) {
                                  final isArabic =
                                      Provider.of<AppLanguage>(context, listen: false).appLang ==
                                          Languages.ar;
                                  return IconButton(
                                    icon: Icon(isArabic?Icons.arrow_forward_ios:Icons.arrow_back_ios, color: Colors.white),
                                    iconSize: 40,
                                    onPressed: _previousPage,
                                  );
                                }
                              ),
                            ),


                            // Right arrow
                            Positioned(
                              top: 165,
                              right: 0,
                              child: Builder(
                                builder: (context) {
                                  final isArabic =
                                      Provider.of<AppLanguage>(context, listen: false).appLang ==
                                          Languages.ar;
                                  return IconButton(
                                    icon: Icon(isArabic?Icons.arrow_back_ios:Icons.arrow_forward_ios, color: Colors.white),
                                    iconSize: 40,
                                    onPressed: _nextPage,
                                  );
                                }
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
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesAboutUsBackground2),
      //     fit: BoxFit.fill,
      //   ),
      // ),
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
                _buildSectionTitleMob('OUR_VISION'.tr(context)),
                Gap(5.h),
                _buildSectionTextMob(
                  'OUR_MISSION_TEXT'.tr(context),
                ),
                Gap(20.h),
                _buildSectionTitleMob('OUR_MISSION'.tr(context)),
                Gap(5.h),
                _buildSectionTextMob(
                  'OUR_VISION_TEXT'.tr(context),
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
      fontFamily: getLocalizedFont(context, 'OptimalBold'),
      color: const Color(0xFFF4ED47),
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
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
     // textAlign: TextAlign.justify,
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
              fit: BoxFit.cover,
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
                          text: 'WHO_ARE_WE'.tr(context),
                          style: TextStyle(
                            fontFamily: getLocalizedFont(context, 'OptimalBold'),
                            color: const Color(0xFFF4ED47),
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'WHO_ARE_WE_QUESTION'.tr(context),
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
                      'WE_WERE_ESTABLISHED_FULL'.tr(context),
                     // textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        height: 1.8,
                      ),
                    ),
                  ),
                  Gap(20.h),
                  InkWell(
                    onTap: isDownloading ? null : downloadFile,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _isPrimaryColor ? const Color(0xFFC63424) : const Color(0xFFF4ED47),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "CLICK_TO_DOWNLOAD_PROFILE".tr(context),
                        style: TextStyle(
                          fontFamily: getLocalizedFont(context, 'OptimalBold'),
                          color: _isPrimaryColor ? const Color(0xFFF4ED47) : const Color(0xFFC63424),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
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
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(Assets.imagesAboutUsBackgroundMob2),
      //     fit: BoxFit.fill,
      //   ),
      // ),
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
                _buildSectionTitleMob('LATEST_NEWS_EVENTS'.tr(context)),
                Gap(20.h),
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 550.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _pageController != null ? PageView.builder(
                              controller: _pageController!,
                              itemCount: items.length,
                              onPageChanged: (index) {
                                setState(() => _currentPage = index);
                              },
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 40.w),
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
                                            fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                            color: const Color(0xFFF4ED47),
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
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
                            ) : const SizedBox.shrink(),

                            // Left arrow
                            Positioned(
                              top: 135,
                              left: 0,
                              child: Builder(
                                builder: (context) {
                                  final isArabic =
                                      Provider.of<AppLanguage>(context, listen: false).appLang ==
                                          Languages.ar;
                                  return IconButton(
                                    icon: Icon(isArabic?Icons.arrow_forward_ios:Icons.arrow_back_ios_new, color: Colors.white),
                                    iconSize: 28,
                                    onPressed: _previousPage,
                                  );
                                }
                              ),
                            ),

                            // Right arrow
                            Positioned(
                              top: 135,
                              right: 0,
                              child: Builder(
                                builder: (context) {
                                  final isArabic =
                                      Provider.of<AppLanguage>(context, listen: false).appLang ==
                                          Languages.ar;
                                  return IconButton(
                                    icon: Icon(isArabic?Icons.arrow_back_ios_new: Icons.arrow_forward_ios, color: Colors.white),
                                    iconSize: 28,
                                    onPressed: _nextPage,
                                  );
                                }
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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

