import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/Content/content_helper.dart';
import '../../../core/Content/content_provider.dart';
import '../../../Widgets/bottom_navbar_widget.dart';
import '../../../Widgets/clients_logos_section.dart';
import '../../../Widgets/content_service_section.dart';
import '../../../Widgets/custom_app_bar.dart';
import '../../../Widgets/custom_app_bar_mob.dart';
import '../../../Widgets/floating_contact_buttons.dart';
import '../../../Widgets/footer_section.dart';
import '../../../Widgets/footer_section_mob.dart';
import '../../../Widgets/scroll_to_top_button.dart';
import '../../../Widgets/cached_cms_futures.dart';
import '../../../Widgets/dynamic_content_widget.dart';
import '../../../core/responsive/native_layout.dart';
import '../../../core/Language/app_languages.dart';
import '../../../core/Language/locales.dart';
import '../../../Utilities/font_helper.dart';
import '../../../generated/assets.dart';

class FranchiseInvestmentScreen extends StatefulWidget {
  static const String routeName = '/services/franchise-investment';

  const FranchiseInvestmentScreen({super.key});

  @override
  State<FranchiseInvestmentScreen> createState() => _FranchiseInvestmentScreenState();
}

class _FranchiseInvestmentScreenState extends State<FranchiseInvestmentScreen> {
  static const String _pageId = 'franchise-investment';
  static const String _brochureUrlSectionId = 'franchising-brochure-url';
  static const String _defaultBrochureUrl =
      'https://drive.google.com/uc?export=download&id=1iFzkiZYpEI0mfZMsEqkweFlNN4cXBCqw';

  final ScrollController _scrollController = ScrollController();
  bool isDownloading = false;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ContentProvider>().ensurePageLoaded(_pageId);
    });
  }

  Future<void> downloadFile() async {
    final url = await ContentHelper.getLink(
          context,
          _pageId,
          _brochureUrlSectionId,
          defaultValue: _defaultBrochureUrl,
        ) ??
        _defaultBrochureUrl;
    if (!mounted) return;
    const filename = 'franchising_brochure.pdf';

    if (url.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('DOWNLOAD_FAILED'.tr(context))),
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
    if (!mounted) return;

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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: useNativeBottomNavigationBar(context)
            ? const BottomNavBarWidget(selected: SelectedBottomNavBar.aboutUs)
            : null,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Directionality(
                    
                    textDirection: TextDirection.ltr,
                    child: Container(
                      width: double.infinity,
                      child: CachedHeroDecorationScope(
                        pageId: 'franchise-investment',
                        isMobile: isMobile,
                        fit: BoxFit.fill,
                        builder: (context, decorationImage) {
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: decorationImage,
                            ),
                            child: Stack(
                              children: [
                                // Fallback image for height calculation
                                Image.asset(
                                  Assets.imagesLearnServices,
                                  width: double.infinity,
                                  fit: BoxFit.none,
                                  color: Colors.transparent,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      isMobile ? 10.w : 150.w,
                                      isMobile ? 55.h : 150.h,
                                      isMobile ? 10.w : 150.w,
                                      20.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Builder(
                                          builder: (context) {
                                            final isArabic =
                                                Provider.of<AppLanguage>(context, listen: false).appLang ==
                                                    Languages.ar;
                    
                                            return SizedBox(
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisAlignment: isArabic ?  MainAxisAlignment.end : MainAxisAlignment.start,
                                                crossAxisAlignment: isArabic ?  CrossAxisAlignment.end : CrossAxisAlignment.start,
                                                children: [
                                                  DynamicText(
                                                    pageId: 'franchise-investment',
                                                    sectionId: 'hero-title-1',
                                                    defaultValue: 'FRANCHISE_HERO_TITLE_1',
                                                    style: TextStyle(
                                                      fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                      color: Colors.white,
                                                      fontSize: isMobile ? 16.sp : 70.sp,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Gap(8.h),
                                                  DynamicText(
                                                    pageId: 'franchise-investment',
                                                    sectionId: 'hero-title-2',
                                                    defaultValue: 'FRANCHISE_HERO_TITLE_2',
                                                    style: TextStyle(
                                                      fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                      color: const Color(0xFFF4ED47),
                                                      fontSize: isMobile ? 16.sp : 75.sp,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                      ),
                                      Gap(isMobile ? 2.h : 40.h),
                                      SizedBox(
                                        width: isMobile ? double.infinity : double.infinity,
                                        child: DynamicText(
                                          pageId: 'franchise-investment',
                                          sectionId: 'hero-subtitle',
                                          defaultValue: 'FRANCHISE_HERO_SUBTITLE',
                                          style: TextStyle(
                                            fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                                            color: Colors.white,
                                            fontSize: isMobile ? 10.sp : 38.sp,
                                            height: isMobile ? 2 : 1.6,
                                          ),
                                        ),
                                      ),
                                      Gap(isMobile ? 12.h : 180.h),
                                      _buildDescriptionBox(
                                        context: context,
                                        isMobile: isMobile,
                                        pageId: 'franchise-investment',
                                        sectionId: 'description-1',
                                        defaultValue: 'FRANCHISE_DESCRIPTION_1',
                                        highlightText: 'For investors seeking',
                                      ),
                                      SizedBox(height: isMobile ? 8.h : 50.h),
                                      _buildDescriptionBox(
                                        context: context,
                                        isMobile: isMobile,
                                        pageId: 'franchise-investment',
                                        sectionId: 'description-2',
                                        defaultValue: 'FRANCHISE_DESCRIPTION_2',
                                        highlightText: 'From market research and brand vetting to',
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: isMobile ? 180.w : 1100.w,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: isMobile ? 8.h : 50.h),
                                            _buildDescriptionBox(
                                              width: 600,
                                              context: context,
                                              isMobile: isMobile,
                                              pageId: 'franchise-investment',
                                              sectionId: 'description-3',
                                              defaultValue: 'FRANCHISE_DESCRIPTION_3',
                                              highlightText: 'We offer',
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(isMobile ? 100.h : 600.h),
                                      // Our Services Include Section
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isMobile ? 20.w : 40.w,
                                          vertical: isMobile ? 10.h : 40.h,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            DynamicText(
                                              pageId: 'franchise-investment',
                                              sectionId: 'services-title',
                                              defaultValue: 'FRANCHISE_SERVICE_TITLE',
                                              style: TextStyle(
                                                fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                                color: const Color(0xFFF4ED47),
                                                fontSize: isMobile ? 18.sp : 70.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: isMobile ? 10.h : 60.h),
                                            _buildDescriptionBox(
                                              context: context,
                                              isMobile: isMobile,
                                              pageId: 'franchise-investment',
                                              sectionId: 'service-1',
                                              defaultValue: 'FRANCHISE_SERVICE_1',
                                              width: 1200.w,
                                            ),
                                            Gap(isMobile ? 20.h : 40.h),
                                            _FranchisingBrochureButton(
                                              isMobile: isMobile,
                                              isDownloading: isDownloading,
                                              onTap: downloadFile,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(isMobile ? 10.h : 420.h),
                                      ClientsLogosSection(
                                        pageId: 'franchise-investment',
                                        backgroundColor: Colors.grey[900]!,
                                        visibleLogosCount: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const ContentServiceSection(
                    showCategoryField: true,
                    sourceTag: 'Franchise investment',
                  ),

                  if (kIsWeb)
                    (MediaQuery.sizeOf(context).width >= 600
                        ? const FooterSection()
                        : const FooterSectionMob()),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: useWebDesktopAppBar(context)
                  ? const CustomAppBar()
                  : const CustomAppBarMob(),
            ),
            const FloatingContactButtons(),
            ScrollToTopButton(scrollController: _scrollController),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionBox({
    required BuildContext context,
    required bool isMobile,
    String? text,
    String? pageId,
    String? sectionId,
    String? defaultValue,
    String? highlightText,
    double? width,
  }) {
    final displayText = defaultValue ?? text ?? '';
    
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8.w : 28.w, vertical: isMobile ? 4.w : 32.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(isMobile ? 20.r : 50.r),
      ),
      child: (pageId != null && sectionId != null)
          ? DynamicText(
              pageId: pageId,
              sectionId: sectionId,
              defaultValue: displayText,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 10.sp : 42.sp,
                height: isMobile ? 1.3 : 1.8,
              ),
            )
          : (highlightText != null
              ? _buildHighlightedText(displayText, highlightText, isMobile)
              : Text(
                  displayText,
                  textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 10.sp : 42.sp,
                  ),
                )),
    );
  }

  Widget _buildHighlightedText(String text, String highlightText, bool isMobile) {
    final highlightIndex = text.toLowerCase().indexOf(highlightText.toLowerCase());
    
    if (highlightIndex == -1) {
      return Text(
        text,
        textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
        style: TextStyle(
          color: Colors.white,
          fontSize: isMobile ? 10.sp : 32.sp,
          height: isMobile ? 1.3 : 1.8,
        ),
      );
    }

    final beforeText = text.substring(0, highlightIndex);
    final highlightedText = text.substring(highlightIndex, highlightIndex + highlightText.length);
    final afterText = text.substring(highlightIndex + highlightText.length);

    return RichText(
      textDirection: TextDirection.ltr, // Force LTR to keep alignment consistent
      text: TextSpan(
        children: [
          TextSpan(
            text: beforeText,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 10.sp : 42.sp,
              height: isMobile ? 1.3 : 1.8,
            ),
          ),
          TextSpan(
            text: highlightedText,
            style: TextStyle(
              color: const Color(0xFFF4ED47),
              fontSize: isMobile ? 10.sp : 42.sp,
              height: isMobile ? 1.3 : 1.8,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: afterText,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 10.sp : 42.sp,
              height: isMobile ? 1.3 : 1.8,
            ),
          ),
        ],
      ),
    );
  }
}

/// Toggles brochure CTA colors locally so the whole page does not rebuild
/// (avoids scroll jank / "refresh" feeling on web).
class _FranchisingBrochureButton extends StatefulWidget {
  const _FranchisingBrochureButton({
    required this.isMobile,
    required this.isDownloading,
    required this.onTap,
  });

  final bool isMobile;
  final bool isDownloading;
  final Future<void> Function() onTap;

  @override
  State<_FranchisingBrochureButton> createState() => _FranchisingBrochureButtonState();
}

class _FranchisingBrochureButtonState extends State<_FranchisingBrochureButton> {
  bool _isPrimaryColor = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        setState(() => _isPrimaryColor = !_isPrimaryColor);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isDownloading ? null : () => widget.onTap(),
      child: Container(
        padding: EdgeInsets.all(widget.isMobile ? 8 : 4),
        decoration: BoxDecoration(
          color: _isPrimaryColor ? const Color(0xFFC63424) : const Color(0xFFF4ED47),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          "DOWNLOAD_FRANCHISING_BROCHURE".tr(context),
          style: TextStyle(
            fontFamily: getLocalizedFont(context, 'OptimalBold'),
            color: _isPrimaryColor ? const Color(0xFFF4ED47) : const Color(0xFFC63424),
            fontSize: widget.isMobile ? 12.sp : 25.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
