import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../Models/content_model.dart';
import '../../core/Content/content_helper.dart';
import '../../core/Content/content_provider.dart';
import '../../core/Language/locales.dart';
import '../../core/Language/app_languages.dart';
import '../../Utilities/font_helper.dart';
import 'package:provider/provider.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../Widgets/dynamic_content_widget.dart';
import '../../Widgets/floating_contact_buttons.dart';
import '../../Widgets/scroll_to_top_button.dart';
import '../../Widgets/footer_section.dart';
import '../../Widgets/footer_section_mob.dart';
import '../../generated/assets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../core/responsive/native_layout.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  static const String routeName = '/about';

  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  static const String _aboutPageId = 'about';
  static const String _companyProfileSectionId = 'company-profile-file';
  static const String _defaultCompanyProfileUrl =
      'https://drive.google.com/uc?export=download&id=1iFzkiZYpEI0mfZMsEqkweFlNN4cXBCqw';

  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;
  PageController? _pageController;
  int _currentPage = 0;
  bool _pageControllerInitialized = false;
  late final Future<List<ContentModel>> _aboutContentFuture;

  List<_AboutNewsFallbackSpec> get _fallbackNewsItems => const [
        _AboutNewsFallbackSpec(
          titleKey: 'ABOUT_LATEST_NEWS_ANNUAL_TITLE',
          descriptionKey: 'ABOUT_LATEST_NEWS_EVENTS_BODY',
          assetPath: Assets.imagesPic1,
        ),
        _AboutNewsFallbackSpec(
          titleKey: 'ABOUT_LATEST_NEWS_SIGNING_TITLE',
          descriptionKey: 'ABOUT_LATEST_NEWS_EVENTS_BODY',
          assetPath: Assets.imagesPic2,
        ),
        _AboutNewsFallbackSpec(
          titleKey: 'ABOUT_LATEST_NEWS_LIMITED_TITLE',
          descriptionKey: 'ABOUT_LATEST_NEWS_EVENTS_BODY',
          assetPath: Assets.imagesPic3,
        ),
      ];

  void _nextPage(int itemCount) {
    if (_pageController == null || itemCount == 0) return;
    if (_currentPage < itemCount - 1) {
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

  void _previousPage(int itemCount) {
    if (_pageController == null || itemCount == 0) return;
    if (_currentPage > 0) {
      _pageController!.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Loop: from first image go to last
      _pageController!.animateToPage(
        itemCount - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
  final ValueNotifier<bool> _isPrimaryColor = ValueNotifier<bool>(true);
  late Timer _timer;


  bool isDownloading = false;
  double progress = 0;

  Future<void> downloadFile() async {
    final url = await ContentHelper.getLink(
          context,
          _aboutPageId,
          _companyProfileSectionId,
          defaultValue: _defaultCompanyProfileUrl,
        ) ??
        _defaultCompanyProfileUrl;
    const filename = 'cp_incm_2025.pdf';

    if (url.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid company profile link')),
      );
      return;
    }

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

  String _localizedValue(ContentModel content) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final primaryValue = isArabic ? content.values['ar'] : content.values['en'];
    final secondaryValue = isArabic ? content.values['en'] : content.values['ar'];
    return (primaryValue?.isNotEmpty == true ? primaryValue : secondaryValue) ?? '';
  }

  List<_AboutNewsItemData> _resolveLatestNewsItems(List<ContentModel> contents) {
    final itemsByIndex = <int, _AboutNewsItemData>{};
    for (var i = 0; i < _fallbackNewsItems.length; i++) {
      final fallback = _fallbackNewsItems[i];
      itemsByIndex[i + 1] = _AboutNewsItemData(
        title: fallback.title(context),
        description: fallback.description(context),
        fallbackAssetPath: fallback.assetPath,
      );
    }

    final newsRegex =
        RegExp(r'^latest-news-item-(\d+)-(title|description|image)$');

    for (final content in contents) {
      final match = newsRegex.firstMatch(content.sectionId);
      if (match == null) {
        continue;
      }

      final index = int.tryParse(match.group(1) ?? '');
      final field = match.group(2);
      if (index == null || index <= 0 || field == null) {
        continue;
      }

      var item = itemsByIndex[index] ??
          _AboutNewsItemData(
            title: '',
            description: '',
            fallbackAssetPath: Assets.imagesAboutUsBackground,
          );

      switch (field) {
        case 'title':
          final title = _localizedValue(content);
          if (title.isNotEmpty) {
            item = item.copyWith(title: title);
          }
          break;
        case 'description':
          final description = _localizedValue(content);
          if (description.isNotEmpty) {
            item = item.copyWith(description: description);
          }
          break;
        case 'image':
          if (content.imageBase64?.isNotEmpty == true) {
            item = item.copyWith(imageBase64: content.imageBase64);
          }
          break;
      }

      itemsByIndex[index] = item;
    }

    final sortedIndexes = itemsByIndex.keys.toList()..sort();
    final resolved = sortedIndexes
        .map((index) => itemsByIndex[index]!)
        .where(
          (item) =>
              item.title.isNotEmpty ||
              item.description.isNotEmpty ||
              (item.imageBase64?.isNotEmpty ?? false),
        )
        .toList();
    if (resolved.length > 3) {
      return resolved.sublist(0, 3);
    }
    return resolved;
  }

  Widget _buildDynamicNewsImage(
    _AboutNewsItemData item, {
    required double height,
  }) {
    final rawBase64 = item.imageBase64?.trim();
    if (rawBase64 != null && rawBase64.isNotEmpty) {
      try {
        final normalizedBase64 =
            rawBase64.contains(',') ? rawBase64.split(',').last.trim() : rawBase64;
        final bytes = base64Decode(normalizedBase64);
        return Image.memory(
          bytes,
          fit: BoxFit.cover,
          width: double.infinity,
          height: height,
        );
      } catch (_) {
        // Fall back to the bundled asset if the saved base64 is invalid.
      }
    }

    return Image.asset(
      item.fallbackAssetPath,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
    );
  }


  @override
  void initState() {
    super.initState();
    _hasAnimated = false;
    final contentProvider = Provider.of<ContentProvider>(context, listen: false);
    _aboutContentFuture = contentProvider.getPageContent(_aboutPageId);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animationController.reset();
    // PageController will be initialized in didChangeDependencies
    // تبديل اللون كل 5 ثواني
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _isPrimaryColor.value = !_isPrimaryColor.value;
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
    _isPrimaryColor.dispose();
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
        bottomNavigationBar: useNativeBottomNavigationBar(context) ? const BottomNavBarWidget(selected: SelectedBottomNavBar.aboutUs) : null,

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


                    // Footer (web only; native uses bottom bar)
                    if (kIsWeb)
                      (MediaQuery.sizeOf(context).width >= 600
                          ? const FooterSection()
                          : const FooterSectionMob()),
                    if (useNativeBottomNavigationBar(context)) SizedBox(height: 100.h),
                    // _buildLocationSection(context, isMobile, isTablet),
                  ],
                ),
              ),
            ),
            useWebDesktopAppBar(context)
            ? const Positioned(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDynamicSectionTitle(
                  sectionId: 'vision-title',
                  defaultValue: 'OUR_VISION',
                ),
                Gap(20.h),
                _buildDynamicSectionText(
                  sectionId: 'vision-text',
                  defaultValue: 'OUR_VISION_TEXT',
                ),
                Gap(60.h),
                _buildDynamicSectionTitle(
                  sectionId: 'mission-title',
                  defaultValue: 'OUR_MISSION',
                ),
                Gap(20.h),
                _buildDynamicSectionText(
                  sectionId: 'mission-text',
                  defaultValue: 'OUR_MISSION_TEXT',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicSectionTitle({
    required String sectionId,
    required String defaultValue,
    bool isMobile = false,
    TextAlign? textAlign,
  }) {
    return DynamicText(
      pageId: _aboutPageId,
      sectionId: sectionId,
      defaultValue: defaultValue,
      textAlign: textAlign ?? TextAlign.center,
      style: TextStyle(
        fontFamily: getLocalizedFont(context, 'OptimalBold'),
        color: const Color(0xFFF4ED47),
        fontSize: isMobile ? 24.sp : 80.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDynamicSectionText({
    required String sectionId,
    required String defaultValue,
    bool isMobile = false,
    Color? backgroundColor,
  }) {
    return Container(
      width: 1400.w,
      padding: EdgeInsets.all(isMobile ? 24 : 12),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isMobile
                ? Colors.white.withValues(alpha: 0.2)
                : const Color(0xFFF4ED47).withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(isMobile ? 4 : 0),
      ),
      child: DynamicText(
        pageId: _aboutPageId,
        sectionId: sectionId,
        defaultValue: defaultValue,
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 12.sp : 26.sp,
          fontWeight: isMobile ? FontWeight.normal : FontWeight.bold,
          height: isMobile ? null : 1.5,
        ),
      ),
    );
  }


  Widget _buildContactFormSection(BuildContext context) {



    return Consumer<AppLanguage>(
      builder: (context, appLanguage, _) {
        final isArabic = appLanguage.appLang == Languages.ar;
        return Stack(
            children:[
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(isArabic ? -1.0 : 1.0, 1.0),
                child: DynamicBackgroundContainer(
                  pageId: _aboutPageId,
                  sectionId: 'about-background',
                  fallbackAssetPath: Assets.imagesAboutUsBackground1,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 1200.h,
                  child: const SizedBox.shrink(),
                ),
              ),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DynamicText(
                                      pageId: _aboutPageId,
                                      sectionId: 'who-are-we-title',
                                      defaultValue:
                                          '${'WHO_ARE_WE'.tr(context)}${'WHO_ARE_WE_QUESTION'.tr(context)}',
                                      style: TextStyle(
                                        fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                        color: const Color(0xFFF4ED47),
                                        fontSize: 80.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DynamicText(
                                      pageId: _aboutPageId,
                                      sectionId: 'who-are-we-text',
                                      defaultValue: 'WE_WERE_ESTABLISHED_FULL',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        height: 1.8,
                                      ),
                                    ),

                                    Gap(40.h),
                                    ValueListenableBuilder<bool>(
                                      valueListenable: _isPrimaryColor,
                                      builder: (context, isPrimaryColor, _) {
                                        return InkWell(
                                          onTap: isDownloading ? null : downloadFile,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: isPrimaryColor
                                                  ? const Color(0xFFC63424)
                                                  : const Color(0xFFF4ED47),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              "CLICK_TO_DOWNLOAD_PROFILE".tr(context),
                                              style: TextStyle(
                                                fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                color: isPrimaryColor
                                                    ? const Color(0xFFF4ED47)
                                                    : const Color(0xFFC63424),
                                                fontSize: 25.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDynamicSectionTitle(
                  sectionId: 'latest-news-title',
                  defaultValue: 'LATEST_NEWS_EVENTS',
                ),
                Gap(40.h),
                FutureBuilder<List<ContentModel>>(
                  future: _aboutContentFuture,
                  builder: (context, snapshot) {
                    final newsItems =
                        _resolveLatestNewsItems(snapshot.data ?? const []);
                    return _buildLatestNewsCarousel(
                      context,
                      newsItems,
                      isMobile: false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLatestNewsCarousel(
    BuildContext context,
    List<_AboutNewsItemData> newsItems, {
    required bool isMobile,
  }) {
    final imageHeight = isMobile ? 380.h : 500.h;
    final carouselHeight = isMobile ? 550.h : 700.h;
    final titleFontSize = isMobile ? 24.sp : 40.sp;
    final descriptionFontSize = isMobile ? 12.sp : 18.sp;
    final arrowTop = isMobile ? 135.0 : 165.0;
    final arrowSize = isMobile ? 28.0 : 40.0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 0 : 60.h),
      child: Column(
        children: [
          SizedBox(
            height: carouselHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!isMobile)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: _buildLatestNewsPageView(
                      context,
                      newsItems,
                      imageHeight: imageHeight,
                      titleFontSize: titleFontSize,
                      descriptionFontSize: descriptionFontSize,
                      isMobile: isMobile,
                    ),
                  )
                else
                  _buildLatestNewsPageView(
                    context,
                    newsItems,
                    imageHeight: imageHeight,
                    titleFontSize: titleFontSize,
                    descriptionFontSize: descriptionFontSize,
                    isMobile: isMobile,
                  ),
                Positioned(
                  top: arrowTop,
                  left: 0,
                  child: Builder(
                    builder: (context) {
                      final isRtl =
                          Directionality.of(context) == TextDirection.rtl;
                      final isArabic =
                          Provider.of<AppLanguage>(context, listen: false)
                                  .appLang ==
                              Languages.ar;
                      return IconButton(
                        icon: Icon(
                          isArabic
                              ? Icons.arrow_forward_ios
                              : (isMobile
                                  ? Icons.arrow_back_ios_new
                                  : Icons.arrow_back_ios),
                          color: Colors.white,
                        ),
                        iconSize: arrowSize,
                        onPressed: () {
                          // PageView scroll direction follows Directionality; swap
                          // prev/next so motion matches the physical arrow side in RTL.
                          if (isRtl) {
                            _nextPage(newsItems.length);
                          } else {
                            _previousPage(newsItems.length);
                          }
                        },
                      );
                    },
                  ),
                ),
                Positioned(
                  top: arrowTop,
                  right: 0,
                  child: Builder(
                    builder: (context) {
                      final isRtl =
                          Directionality.of(context) == TextDirection.rtl;
                      final isArabic =
                          Provider.of<AppLanguage>(context, listen: false)
                                  .appLang ==
                              Languages.ar;
                      return IconButton(
                        icon: Icon(
                          isArabic
                              ? Icons.arrow_back_ios
                              : Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        iconSize: arrowSize,
                        onPressed: () {
                          if (isRtl) {
                            _previousPage(newsItems.length);
                          } else {
                            _nextPage(newsItems.length);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLatestNewsPageView(
    BuildContext context,
    List<_AboutNewsItemData> newsItems, {
    required double imageHeight,
    required double titleFontSize,
    required double descriptionFontSize,
    required bool isMobile,
  }) {
    if (_pageController == null) {
      return const SizedBox.shrink();
    }

    return PageView.builder(
      controller: _pageController!,
      itemCount: newsItems.length,
      onPageChanged: (index) {
        // Avoid setState here: it rebuilds the whole screen and replays image
        // decoding on web, which looks like a flash/refresh on each arrow tap.
        _currentPage = index;
      },
      itemBuilder: (context, index) {
        final item = newsItems[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 40.w : 20.w),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  height: imageHeight,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFF4ED47),
                      width: 0.6,
                    ),
                  ),
                  child: _buildDynamicNewsImage(item, height: imageHeight),
                ),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: getLocalizedFont(context, 'OptimalBold'),
                    color: const Color(0xFFF4ED47),
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    item.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: descriptionFontSize,
                      height: isMobile ? null : 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }








  Widget _buildOurMissionSectionMob(BuildContext context) {
    return Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDynamicSectionTitle(
                  sectionId: 'vision-title',
                  defaultValue: 'OUR_VISION',
                  isMobile: true,
                ),
                Gap(5.h),
                _buildDynamicSectionText(
                  sectionId: 'vision-text',
                  defaultValue: 'OUR_VISION_TEXT',
                  isMobile: true,
                ),
                Gap(20.h),
                _buildDynamicSectionTitle(
                  sectionId: 'mission-title',
                  defaultValue: 'OUR_MISSION',
                  isMobile: true,
                ),
                Gap(5.h),
                _buildDynamicSectionText(
                  sectionId: 'mission-text',
                  defaultValue: 'OUR_MISSION_TEXT',
                  isMobile: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildContactFormSectionMob(BuildContext context) {
    return Stack(

      children:[


        Positioned.fill(
          child: DynamicBackgroundContainer(
            pageId: _aboutPageId,
            sectionId: 'about-background',
            fallbackAssetPath: Assets.imagesAboutUsBackgroundMob1,
            fit: BoxFit.cover,
            child: const SizedBox.shrink(),
          ),
        ),


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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Gap(80.h),
                  DynamicText(
                    pageId: _aboutPageId,
                    sectionId: 'who-are-we-title',
                    defaultValue:
                        '${'WHO_ARE_WE'.tr(context)}${'WHO_ARE_WE_QUESTION'.tr(context)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: getLocalizedFont(context, 'OptimalBold'),
                      color: const Color(0xFFF4ED47),
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4ED47).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DynamicText(
                      pageId: _aboutPageId,
                      sectionId: 'who-are-we-text',
                      defaultValue: 'WE_WERE_ESTABLISHED_FULL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        height: 1.8,
                      ),
                    ),
                  ),
                  Gap(20.h),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isPrimaryColor,
                    builder: (context, isPrimaryColor, _) {
                      return InkWell(
                        onTap: isDownloading ? null : downloadFile,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isPrimaryColor
                                ? const Color(0xFFC63424)
                                : const Color(0xFFF4ED47),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "CLICK_TO_DOWNLOAD_PROFILE".tr(context),
                            style: TextStyle(
                              fontFamily: getLocalizedFont(context, 'OptimalBold'),
                              color: isPrimaryColor
                                  ? const Color(0xFFF4ED47)
                                  : const Color(0xFFC63424),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDynamicSectionTitle(
                  sectionId: 'latest-news-title',
                  defaultValue: 'LATEST_NEWS_EVENTS',
                  isMobile: true,
                ),
                Gap(20.h),
                FutureBuilder<List<ContentModel>>(
                  future: _aboutContentFuture,
                  builder: (context, snapshot) {
                    final newsItems =
                        _resolveLatestNewsItems(snapshot.data ?? const []);
                    return _buildLatestNewsCarousel(
                      context,
                      newsItems,
                      isMobile: true,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutNewsFallbackSpec {
  final String titleKey;
  final String descriptionKey;
  final String assetPath;

  const _AboutNewsFallbackSpec({
    required this.titleKey,
    required this.descriptionKey,
    required this.assetPath,
  });

  String title(BuildContext context) => titleKey.tr(context);

  String description(BuildContext context) => descriptionKey.tr(context);
}

class _AboutNewsItemData {
  final String title;
  final String description;
  final String fallbackAssetPath;
  final String? imageBase64;

  const _AboutNewsItemData({
    required this.title,
    required this.description,
    required this.fallbackAssetPath,
    this.imageBase64,
  });

  _AboutNewsItemData copyWith({
    String? title,
    String? description,
    String? fallbackAssetPath,
    String? imageBase64,
  }) {
    return _AboutNewsItemData(
      title: title ?? this.title,
      description: description ?? this.description,
      fallbackAssetPath: fallbackAssetPath ?? this.fallbackAssetPath,
      imageBase64: imageBase64 ?? this.imageBase64,
    );
  }
}

