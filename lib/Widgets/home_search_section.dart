import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../core/Content/content_provider.dart';
import '../core/Content/services_provider.dart';
import '../Utilities/video_url_helper.dart' show isDirectVideoUrl, toDirectVideoUrl;
import '../Modules/About/about_screen.dart';
import '../Modules/Buy/buy_screen.dart';
import '../Modules/Career/career_screen.dart';
import '../Modules/Contacts/contacts_screen.dart';
import '../Modules/Home/home_screen.dart';
import '../Modules/Lease/lease_screen.dart';
import '../Modules/Sell/sell_screen.dart';
import '../Modules/Services/Consultation/consultation_screen.dart';
import '../Modules/Services/CorporateLeasing/corporate_leasing_screen.dart';
import '../Modules/Services/FacilityManagement/facility_management_screen.dart';
import '../Modules/Services/FranchiseInvestment/franchise_investment_screen.dart';
import '../Modules/Services/Marketing/marketing_screen.dart';
import '../Modules/Services/MedicalLeasing/medical_leasing_screen.dart';
import '../Modules/Services/PrimaryInvestment/primary_investment_screen.dart';
import '../Modules/Services/RetailLeasing/retail_leasing_screen.dart';
import '../Modules/ExclusiveLeasingProjects/exclusive_leasing_projects_screen.dart';
import '../Widgets/dynamic_content_widget.dart';
import '../Widgets/video_background.dart';
import '../core/Content/content_helper.dart';
import '../core/Language/locales.dart';

class HomeSearchSection extends StatefulWidget {
  const HomeSearchSection({super.key});

  @override
  State<HomeSearchSection> createState() => _HomeSearchSectionState();
}

class _HomeSearchSectionState extends State<HomeSearchSection> {
  static const String _fallbackVideoAsset = 'assets/videos/web.mp4';

  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _videoLoadAttempted = false;
  bool _videoLoadFailed = false;
  /// على الويب: رابط Google Drive → iframe؛ رابط مباشر (.mp4) → HTML5 video (أفضل مع Safari)
  bool _useWebEmbed = false;
  String? _webVideoUrl;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _hideResultsAfterUnfocusTimer;
  List<Map<String, String>> _searchResults = [];
  bool _showResults = false;
  late Future<String> _searchPlaceholderFuture;
  String? _lastLanguageCode;

  // List of all searchable pages - built from static + ServicesProvider
  List<Map<String, String>> _getSearchableItems(BuildContext context) {
    final servicesProvider = Provider.of<ServicesProvider>(context, listen: false);
    final allServices = servicesProvider.allServices;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final serviceItems = allServices.map((s) {
      final name = s.nameKey != null
          ? s.nameKey!.tr(context)
          : (isArabic ? s.nameAr : s.nameEn);
      return {'name': name, 'route': s.route, 'category': 'Services'};
    }).toList();

    return [
      {'name': 'Home', 'route': HomeScreen.routeName, 'category': 'Main'},
      {'name': 'About Us', 'route': AboutScreen.routeName, 'category': 'Main'},
      {'name': 'Contacts', 'route': ContactsScreen.routeName, 'category': 'Main'},
      {'name': 'Buy', 'route': BuyScreen.routeName, 'category': 'Main'},
      {'name': 'Sell', 'route': SellScreen.routeName, 'category': 'Main'},
      {'name': 'Lease', 'route': LeaseScreen.routeName, 'category': 'Main'},
      {'name': 'Career', 'route': CareerScreen.routeName, 'category': 'Main'},
      ...serviceItems,
      // Exclusive Leasing Projects
    {'name': 'UMC', 'route': ExclusiveLeasingProjectsScreen.routeName, 'category': 'Projects', 'projectId': 'umc'},
    {'name': 'PARK MALL', 'route': ExclusiveLeasingProjectsScreen.routeName, 'category': 'Projects', 'projectId': 'park-mall'},
    {'name': 'TERRACE MALL', 'route': ExclusiveLeasingProjectsScreen.routeName, 'category': 'Projects', 'projectId': 'terrace'},
    {'name': 'POINT 90', 'route': ExclusiveLeasingProjectsScreen.routeName, 'category': 'Projects', 'projectId': 'point90'},
    {'name': 'KERNEL', 'route': ExclusiveLeasingProjectsScreen.routeName, 'category': 'Projects', 'projectId': 'kernel'},
    {'name': 'CITY SQUARE', 'route': ExclusiveLeasingProjectsScreen.routeName, 'category': 'Projects', 'projectId': 'city-square'},
    {'name': 'VITALI', 'route': ExclusiveLeasingProjectsScreen.routeName, 'category': 'Projects', 'projectId': 'vitali'},
    {'name': 'SEASHELL', 'route': ExclusiveLeasingProjectsScreen.routeName, 'category': 'Projects', 'projectId': 'seashell'},
    ];
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_videoLoadAttempted) {
      _videoLoadAttempted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _loadVideoFromDashboard();
      });
    }
    final languageCode = Localizations.localeOf(context).languageCode;
    if (_lastLanguageCode != languageCode) {
      _lastLanguageCode = languageCode;
      _searchPlaceholderFuture = ContentHelper.getText(
        context,
        'home',
        'search-placeholder',
        defaultValue:'SEARCH_BY_SERVICE_OR_LOCATION'.tr(context),
      );
    }
  }

  Future<void> _loadVideoFromDashboard() async {
    try {
      final contentProvider = Provider.of<ContentProvider>(context, listen: false);
      final content = await contentProvider.getContent('home', 'home-background-video-web');
      final link = content?.values['link']?.trim() ??
          content?.values['en']?.trim() ??
          content?.values['ar']?.trim();
      // على الويب: رابط مباشر أو Google Drive — استخدم HTML5/iframe (أفضل مع Safari)
      if (kIsWeb &&
          link != null &&
          link.isNotEmpty &&
          (isDirectVideoUrl(link) || link.contains('drive.google.com'))) {
        if (mounted) {
          setState(() {
            _useWebEmbed = true;
            _webVideoUrl = link;
            _videoLoadFailed = false;
          });
        }
        return;
      }
      final videoUrl = toDirectVideoUrl(link);
      if (videoUrl != null && videoUrl.isNotEmpty) {
        await _initializeVideo(videoUrl);
      } else {
        await _initializeFallbackAssetVideo();
      }
    } catch (e) {
      if (mounted) await _initializeFallbackAssetVideo();
    }
    if (mounted) setState(() {});
  }

  Future<void> _initializeVideo(String? networkUrl) async {
    if (networkUrl == null || networkUrl.isEmpty) {
      if (mounted) setState(() {
        _isVideoInitialized = false;
        _videoLoadFailed = true;
      });
      return;
    }
    VideoPlayerController? controller;
    try {
      controller = VideoPlayerController.networkUrl(Uri.parse(networkUrl));
      await controller.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Video load timeout'),
      );
      controller.setLooping(true);
      controller.setVolume(0.0);
      await controller.play();
      if (mounted) {
        setState(() {
          _videoController = controller;
          _isVideoInitialized = true;
          _videoLoadFailed = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing home background video (web): $e');
      }
      await controller?.dispose();
      if (mounted) {
        setState(() {
          _videoController = null;
          _isVideoInitialized = false;
          _videoLoadFailed = true;
        });
      }
    }
  }

  Future<void> _initializeFallbackAssetVideo() async {
    VideoPlayerController? controller;
    try {
      controller = VideoPlayerController.asset(_fallbackVideoAsset);
      await controller.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Video load timeout'),
      );
      controller.setLooping(true);
      controller.setVolume(0.0);
      await controller.play();
      if (mounted) {
        setState(() {
          _videoController = controller;
          _isVideoInitialized = true;
          _videoLoadFailed = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing fallback home background video (web asset): $e');
      }
      await controller?.dispose();
      if (mounted) {
        setState(() {
          _videoController = null;
          _isVideoInitialized = false;
          _videoLoadFailed = true;
        });
      }
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showResults = false;
      });
    } else {
      setState(() {
        _searchResults = _getSearchableItems(context)
            .where((item) => item['name']!.toLowerCase().contains(query))
            .toList();
        _showResults = _searchResults.isNotEmpty && _searchFocusNode.hasFocus;
      });
    }
  }

  void _onFocusChanged() {
    _hideResultsAfterUnfocusTimer?.cancel();
    if (!_searchFocusNode.hasFocus) {
      // Defer hiding: on web, losing focus fires before InkWell(onTap); immediate
      // hide removes the dropdown and consumes the gesture.
      _hideResultsAfterUnfocusTimer =
          Timer(const Duration(milliseconds: 200), () {
        _hideResultsAfterUnfocusTimer = null;
        if (!mounted || _searchFocusNode.hasFocus) return;
        setState(() {
          _showResults = false;
        });
      });
    } else {
      // Show results only if there's text and focus
      setState(() {
        _showResults = _searchController.text.isNotEmpty && 
                       _searchResults.isNotEmpty && 
                       _searchFocusNode.hasFocus;
      });
    }
  }

  void _navigateToPage(String route, {String? projectId}) {
    _hideResultsAfterUnfocusTimer?.cancel();
    _hideResultsAfterUnfocusTimer = null;
    // Always hide results and unfocus first
    setState(() {
      _showResults = false;
    });
    _searchController.clear();
    _searchFocusNode.unfocus();
    
    // Small delay to ensure UI updates before navigation
    Future.microtask(() {
      if (projectId != null) {
        context.go('$route?projectId=$projectId');
      } else {
        context.go(route);
      }
    });
  }

  String _translateSearchItemName(String name) {
    final translations = {
      'Home': 'HOME',
      'About Us': 'ABOUT_US',
      'Contacts': 'CONTACTS',
      'Buy': 'BUY',
      'Sell': 'SELL',
      'Lease': 'LEASE',
      'Career': 'CAREERS',
      'Corporate Leasing': 'CORPORATE_LEASING',
      'Consultation': 'CONSULTATION',
      'Marketing': 'MARKETING',
      'Medical Leasing': 'MEDICAL_LEASING',
      'Facility Management': 'FACILITY_MANAGEMENT',
      'Primary Investment': 'PRIMARY_INVESTMENT',
      'Retail Leasing': 'RETAIL_LEASING',
      'Franchise Investment': 'FRANCHISE_INVESTMENT',
    };
    final key = translations[name];
    return key != null ? key.tr(context) : name; // Custom services: name is already display text
  }

  String _translateCategory(String category) {
    final translations = {
      'Main': 'CATEGORY_MAIN',
      'Services': 'CATEGORY_SERVICES',
      'Projects': 'CATEGORY_PROJECTS',
    };
    final key = translations[category] ?? category;
    return key.tr(context);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _hideResultsAfterUnfocusTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1200.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Video Background (على الويب: رابط مباشر → HTML5؛ Google Drive → iframe)
          Positioned.fill(
            child: _useWebEmbed && _webVideoUrl != null
                ? buildVideoBackground(
                    url: _webVideoUrl!,
                    fallback: Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  )
                : _isVideoInitialized && _videoController != null
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoController!.value.size.width,
                          height: _videoController!.value.size.height,
                          child: VideoPlayer(_videoController!),
                        ),
                      )
                    : _videoLoadFailed
                        ? Container(color: Colors.black)
                        : Container(
                            color: Colors.black,
                            child: const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                          ),
          ),
          // Background INCM text/logo

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DynamicText(
                  pageId: 'home',
                  sectionId: 'search-title',
                  defaultValue: 'EXPLORE_INCM_WORLD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'AloeveraDisplayBold',
                    color: const Color(0xFFF4ED47),
                    fontSize: 112.sp,
                    height: 0.2,
                  ),
                ),
                Gap(20.h),
                DynamicText(
                  pageId: 'home',
                  sectionId: 'search-subtitle',
                  defaultValue: 'STEP_INTO_WORLD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'AloeveraDisplayRegular',
                    color: Colors.white,
                    fontSize: 30.sp,
                  ),
                ),
                Gap(50.h),
                // Search Bar
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: 900.w),
                  child: Column(
                    children: [
                      Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: const Color(0xFFF4ED47),
                                size: 50.sp,
                              ),
                              SizedBox(width: 20.w),
                              Expanded(
                                child: FutureBuilder<String>(
                                  future: _searchPlaceholderFuture,
                                  builder: (context, snapshot) {
                                    final placeholder = snapshot.data ??
                                        'SEARCH_BY_SERVICE_OR_LOCATION'.tr(context);
                                    return SizedBox(
                                      height: 60,
                                      child: TextField(
                                        controller: _searchController,
                                        focusNode: _searchFocusNode,
                                        textAlignVertical: TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          hintText: placeholder,
                                          hintStyle: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 32.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        style: TextStyle(
                                          fontSize: 32.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Search Results Dropdown
                      if (_showResults && _searchResults.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 8.h),
                          constraints: BoxConstraints(
                            maxHeight: 400.h,
                            maxWidth: 900.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final item = _searchResults[index];
                              return InkWell(
                                onTap: () => _navigateToPage(
                                  item['route']!,
                                  projectId: item['projectId'],
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25.w,
                                    vertical: 20.h,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: index < _searchResults.length - 1 ? 1 : 0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Colors.grey[600],
                                        size: 24.sp,
                                      ),
                                      SizedBox(width: 15.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _translateSearchItemName(item['name']!),
                                              style: TextStyle(
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              _translateCategory(item['category']!),
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20.sp,
                                        color: Colors.grey[400],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}