import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:incm/Utilities/router_config.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../Widgets/floating_contact_buttons.dart';
import '../../Widgets/scroll_to_top_button.dart';
import '../../Widgets/footer_section.dart';
import '../../Widgets/footer_section_mob.dart';
import '../../Widgets/dynamic_content_widget.dart';
import '../../generated/assets.dart';
import '../../core/Content/content_helper.dart';
import '../../core/Content/content_provider.dart';
import '../../Utilities/font_helper.dart';
import '../../core/Language/locales.dart';
import 'package:provider/provider.dart';

class ExclusiveLeasingProjectsScreen extends StatefulWidget {
  static const String routeName = '/exclusive-leasing-projects';

  const ExclusiveLeasingProjectsScreen({super.key});

  @override
  State<ExclusiveLeasingProjectsScreen> createState() =>
      _ExclusiveLeasingProjectsScreenState();
}

class _ExclusiveLeasingProjectsScreenState
    extends State<ExclusiveLeasingProjectsScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _hasAnimated = false;

  // Page controllers for each project's image carousel
  final Map<String, PageController> _pageControllers = {};
  final Map<String, int> _currentImageIndex = {};
  
  // GlobalKeys for scrolling to specific projects
  final Map<String, GlobalKey> _projectKeys = {};

  // List of 8 projects with local images
  final List<Map<String, dynamic>> projects = [
    {
      'id': 'umc',
      'logoFallback': Assets.logosFacilityUmc,
      'imageFallback': Assets.imagesExclusiveLeasingUmcC0020T01,
      'localImages': [
        Assets.imagesExclusiveLeasingUmcC0020T01,
        Assets.imagesExclusiveLeasingUmcC0025T01,
        Assets.imagesExclusiveLeasingUmcDjiStill002,
      ],
      'titleEn': 'UMC',
      'titleAr': 'UMC',
    },
    {
      'id': 'park-mall',
      'logoFallback': Assets.logosConsultation25,
      'imageFallback': Assets.imagesExclusiveLeasingParkMallParkMall,
      'localImages': [
        Assets.imagesExclusiveLeasingParkMallParkMall,
      ],
      'titleEn': 'PARK MALL',
      'titleAr': 'PARK MALL',
    },
    {
      'id': 'terrace',
      'logoFallback': Assets.logosFacilityTerrace,
      'imageFallback': Assets.imagesExclusiveLeasingTerraceDsc07468,
      'localImages': [
        Assets.imagesExclusiveLeasingTerraceDsc07468,
        Assets.imagesExclusiveLeasingTerraceDsc07664,
        Assets.imagesExclusiveLeasingTerraceDsc07812,
        Assets.imagesExclusiveLeasingTerraceDsc07992,
      ],
      'titleEn': 'TERRACE MALL',
      'titleAr': 'TERRACE MALL',
    },
    {
      'id': 'point90',
      'logoFallback': Assets.logosConsultation21,
      'imageFallback': Assets.imagesExclusiveLeasingPoint90Point90,
      'localImages': [
        Assets.imagesExclusiveLeasingPoint90Point90,
      ],
      'titleEn': 'POINT 90',
      'titleAr': 'POINT 90',
    },
    {
      'id': 'kernel',
      'logoFallback': Assets.logosFacilityKernel,
      'imageFallback': Assets.imagesExclusiveLeasingKernelKernel,
      'localImages': [
        Assets.imagesExclusiveLeasingKernelKernel,
      ],
      'titleEn': 'KERNEL',
      'titleAr': 'KERNEL',
    },
    {
      'id': 'city-square',
      'logoFallback': Assets.logosRetail1,
      'imageFallback': Assets.imagesExclusiveLeasingCitySquareDfv,
      'localImages': [
        Assets.imagesExclusiveLeasingCitySquareDfv,
      ],
      'titleEn': 'CITY SQUARE',
      'titleAr': 'CITY SQUARE',
    },
    {
      'id': 'vitali',
      'logoFallback': Assets.logosFacilityVitali,
      'imageFallback': Assets.imagesExclusiveLeasingVitaliDjiStill016,
      'localImages': [
        Assets.imagesExclusiveLeasingVitaliDjiStill016,
        Assets.imagesExclusiveLeasingVitaliDjiStill010,
        Assets.imagesExclusiveLeasingVitaliDjiStill015,
        Assets.imagesExclusiveLeasingVitaliDjiStill011,
      ],
      'titleEn': 'VITALI',
      'titleAr': 'VITALI',
    },
    {
      'id': 'seashell',
      'logoFallback': Assets.logosPrimary1,
      'imageFallback': Assets.imagesExclusiveLeasingSeashellUntitled1521,
      'localImages': [
        Assets.imagesExclusiveLeasingSeashellUntitled1521,
      ],
      'titleEn': 'SEASHELL',
      'titleAr': 'SEASHELL',
    },
  ];

  String? _targetProjectId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Initialize page controllers, current indices, and keys for each project
    for (var project in projects) {
      final projectId = project['id'] as String;
      _pageControllers[projectId] = PageController();
      _currentImageIndex[projectId] = 0;
      _projectKeys[projectId] = GlobalKey();
    }

    // Start animation immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check for projectId in query parameters after context is available
    if (_targetProjectId == null) {
      _targetProjectId = _getProjectIdFromQuery();
      if (_targetProjectId != null && _projectKeys.containsKey(_targetProjectId)) {
        // Wait for the page to render, then scroll
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted && _targetProjectId != null) {
              _scrollToProject(_targetProjectId!);
            }
          });
        });
      }
    }
  }

  String? _getProjectIdFromQuery() {
    try {
      // Method 1: Try using GoRouter location
      final goRouter = GoRouter.of(context);
      final location = goRouter.routerDelegate.currentConfiguration.uri.toString();
      
      if (location.contains('?')) {
        final uri = Uri.parse(location);
        final projectId = uri.queryParameters['projectId'];
        if (projectId != null && projectId.isNotEmpty) {
          return projectId;
        }
      }
      
      // Method 2: For web, try Uri.base
      if (kIsWeb) {
        final uri = Uri.base;
        final projectId = uri.queryParameters['projectId'];
        if (projectId != null && projectId.isNotEmpty) {
          return projectId;
        }
      }
      
      // Method 3: Parse manually from location string
      if (location.contains('projectId=')) {
        final parts = location.split('projectId=');
        if (parts.length > 1) {
          final projectId = parts[1].split('&')[0].split('#')[0];
          if (projectId.isNotEmpty) {
            return projectId;
          }
        }
      }
    } catch (e) {
      // If all methods fail, return null
    }
    return null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    for (var controller in _pageControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction >= 0.3) {
      _hasAnimated = true;
      if (!_animationController.isAnimating &&
          !_animationController.isCompleted) {
        _animationController.forward();
      }
    }
  }

  void _nextImage(String projectId) {
    final controller = _pageControllers[projectId];
    if (controller != null && controller.hasClients) {
      // For now, we'll cycle through images. In the future, this will load from Firebase
      controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousImage(String projectId) {
    final controller = _pageControllers[projectId];
    if (controller != null && controller.hasClients) {
      controller.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToProject(String projectId) {
    final key = _projectKeys[projectId];
    if (key?.currentContext != null) {
      // Use ensureVisible which works better with SingleChildScrollView
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.1, // Scroll to show the project near the top
      );
    }
  }

  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: isMobile && !kIsWeb
            ? const BottomNavBarWidget(selected: SelectedBottomNavBar.contacts)
            : null,
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: VisibilityDetector(
                key: const Key('exclusive-leasing-projects-content'),
                onVisibilityChanged: _onVisibilityChanged,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20.w : 40.w,
                            vertical: isMobile ? 40.h : 80.h,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: isMobile ? 60.h : 100.h),
                              // Title
                              Text(
                                'EXCLUSIVE_LEASING_PROJECTS'.tr(context),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: getLocalizedFont(context, 'OptimalBold'),
                                  color: const Color(0xFFF4ED47),
                                  fontSize: isMobile ? 32.sp : 60.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: isMobile ? 40.h : 80.h),
                              // Projects List
                              ...projects.asMap().entries.map((entry) {
                                final index = entry.key;
                                final project = entry.value;
                                return _buildProjectCard(
                                  context,
                                  project,
                                  isMobile,
                                  index == projects.length - 1, // isLast
                                );
                              }),
                              SizedBox(height: isMobile ? 40.h : 80.h),
                            ],
                          ),
                        ),
                        // Footer
                        if(MediaQuery.of(context).size.width >= 600)
                          const FooterSection()
                        else if(kIsWeb)
                          const FooterSectionMob(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            isMobile
                ? const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: CustomAppBarMob(),
                  )
                : const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: CustomAppBar(),
                  ),
            const FloatingContactButtons(),
            ScrollToTopButton(scrollController: _scrollController),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    Map<String, dynamic> project,
    bool isMobile,
    bool isLast,
  ) {
    final projectId = project['id'] as String;
    final logoFallback = project['logoFallback'] as String;
    final imageFallback = project['imageFallback'] as String;
    final titleEn = project['titleEn'] as String;
    final localImages = List<String>.from(project['localImages'] as List<dynamic>? ?? []);

    return Container(
      key: _projectKeys[projectId],
      margin: EdgeInsets.only(
        bottom: isLast ? 0 : (isMobile ? 30.h : 100.h),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<ContentProvider>(
                      builder: (context, contentProvider, child) {
                        return FutureBuilder<Widget>(
                          future: ContentHelper.getImage(
                            context,
                            'exclusive-leasing-projects',
                            '${projectId}-logo',
                            fallbackAssetPath: logoFallback,
                            width: 140.w,
                            height: 140.h,
                            fit: BoxFit.contain,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!;
                            }
                            return _buildImageWithErrorHandling(
                              logoFallback,
                              width: 140.w,
                              height: 140.h,
                              fit: BoxFit.contain,
                            );
                          },
                        );
                      },
                    ),
                    // Expanded(
                    //   child: DynamicText(
                    //     pageId: 'exclusive-leasing-projects',
                    //     sectionId: '${projectId}-title',
                    //     defaultValue: titleEn,
                    //     style: TextStyle(
                    //       fontFamily: getLocalizedFont(context, 'OptimalBold'),
                    //       color: Colors.white,
                    //       fontSize: 24.sp,
                    //       fontWeight: FontWeight.bold,
                    //       letterSpacing: 1.5,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Description
                DynamicText(
                  pageId: 'exclusive-leasing-projects',
                  sectionId: '${projectId}-description',
                  defaultValue: _getDefaultDescription(projectId),
                  style: TextStyle(
                    fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                    color: Colors.white,
                    fontSize: 14.sp,
                    height: 1.8,
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.8, // Square-ish on mobile
                  child: _buildImageCarousel(projectId, imageFallback, isMobile),
                ),



              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side: Logo, Title, Description
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo and Title Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Consumer<ContentProvider>(
                            builder: (context, contentProvider, child) {
                              return FutureBuilder<Widget>(
                                future: ContentHelper.getImage(
                                  context,
                                  'exclusive-leasing-projects',
                                  '${projectId}-logo',
                                  fallbackAssetPath: logoFallback,
                                  width: 150.w,
                                  height: 150.h,
                                  fit: BoxFit.contain,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data!;
                                  }
                                  return _buildImageWithErrorHandling(
                                    logoFallback,
                                    width: 150.w,
                                    height: 150.h,
                                    fit: BoxFit.contain,
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(width: 30.w),
                          // Expanded(
                          //   child: DynamicText(
                          //     pageId: 'exclusive-leasing-projects',
                          //     sectionId: '${projectId}-title',
                          //     defaultValue: titleEn,
                          //     style: TextStyle(
                          //       fontFamily: getLocalizedFont(context, 'OptimalBold'),
                          //       color: Colors.white,
                          //       fontSize: 40.sp,
                          //       fontWeight: FontWeight.bold,
                          //       letterSpacing: 1.5,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      // Description
                      DynamicText(
                        pageId: 'exclusive-leasing-projects',
                        sectionId: '${projectId}-description',
                        defaultValue: _getDefaultDescription(projectId),
                        style: TextStyle(
                          fontFamily: getLocalizedFont(context, 'AloeveraDisplaySemiBold'),
                          color: Colors.white,
                          fontSize: 24.sp,
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 40.w),
                // Right side: Square Image with Carousel
                SizedBox(
                  width: isMobile ? double.infinity : 700.w,
                  height: isMobile ? MediaQuery.of(context).size.width * 0.8 : 600.h,
                  child: _buildImageCarousel(projectId, imageFallback, isMobile),
                ),
              ],
            ),
    );
  }

  Widget _buildImageCarousel(
    String projectId,
    String fallbackImage,
    bool isMobile,
  ) {
    // Load images for this project (check for image-0, image-1, image-2, etc.)
    // We'll check up to 20 images to allow more flexibility
    final controller = _pageControllers[projectId]!;
    final currentIndex = _currentImageIndex[projectId] ?? 0;

    // Get local images for this project
    final project = projects.firstWhere(
      (p) => p['id'] == projectId,
      orElse: () => {'localImages': []},
    );
    final List<String> localImages = List<String>.from(
      project['localImages'] as List<dynamic>? ?? [],
    );

    // Build list of image section IDs to check
    final List<String> imageSectionIds = [];
    for (int i = 0; i < 20; i++) {
      imageSectionIds.add('${projectId}-image-$i');
    }

    return Consumer<ContentProvider>(
      builder: (context, contentProvider, child) {
        return FutureBuilder<List<String?>>(
          future: _loadImageSectionIds(imageSectionIds),
          builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Loading state - show local images or fallback
          return _buildLocalImagesCarousel(localImages, fallbackImage, isMobile, projectId);
        }

        // Filter out null values to get only existing images from Firebase
        final existingImageIds = snapshot.data!
            .asMap()
            .entries
            .where((e) => e.value != null && e.value!.isNotEmpty)
            .map((e) => imageSectionIds[e.key])
            .toList();

        // If no Firebase images found, use local images
        if (existingImageIds.isEmpty) {
          return _buildLocalImagesCarousel(localImages, fallbackImage, isMobile, projectId);
        }

        // Multiple images found - show carousel (square shape)
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Arrow (outside image)
            if (existingImageIds.length > 1)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                iconSize: isMobile ? 30 : 40,
                onPressed: currentIndex > 0
                    ? () => _previousImage(projectId)
                    : null,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            // Image Container
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: PageView.builder(
                  controller: controller,
                  itemCount: existingImageIds.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex[projectId] = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final sectionId = existingImageIds[index];
                    return Container(
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //     color: const Color(0xFFF4ED47),
                      //     width: 1,
                      //   ),
                      // ),
                      child: Consumer<ContentProvider>(
                        builder: (context, contentProvider, child) {
                          return FutureBuilder<Widget>(
                            future: ContentHelper.getImage(
                              context,
                              'exclusive-leasing-projects',
                              sectionId,
                              fallbackAssetPath: fallbackImage,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data!;
                              }
                              return _buildImageWithErrorHandling(
                                fallbackImage,
                                width: 600.sp,
                                height: 600.sp,
                                fit: BoxFit.cover,
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            // Right Arrow (outside image)
            if (existingImageIds.length > 1)
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                iconSize: isMobile ? 30 : 40,
                onPressed: currentIndex < existingImageIds.length - 1
                    ? () => _nextImage(projectId)
                    : null,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
          ],
        );
          },
        );
      },
    );
  }

  Widget _buildLocalImagesCarousel(
    List<String> localImages,
    String fallbackImage,
    bool isMobile,
    String projectId,
  ) {
    final controller = _pageControllers[projectId]!;
    final currentIndex = _currentImageIndex[projectId] ?? 0;
    
    // Use local images if available, otherwise use fallback
    final imagesToShow = localImages.isNotEmpty ? localImages : [fallbackImage];
    
    if (imagesToShow.length == 1) {
      // Single image - no carousel needed
      return _buildSingleImage(imagesToShow[0], isMobile, false);
    }

    // Multiple local images - show carousel
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Arrow (outside image)
        if (imagesToShow.length > 1)
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            iconSize: isMobile ? 30 : 40,
            onPressed: currentIndex > 0
                ? () => _previousImage(projectId)
                : null,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        // Image Container
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: PageView.builder(
              controller: controller,
              itemCount: imagesToShow.length,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex[projectId] = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     color: const Color(0xFFF4ED47),
                  //     width: 1,
                  //   ),
                  // ),
                  child: _buildImageWithErrorHandling(
                    imagesToShow[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
        // Right Arrow (outside image)
        if (imagesToShow.length > 1)
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            iconSize: isMobile ? 30 : 40,
            onPressed: currentIndex < imagesToShow.length - 1
                ? () => _nextImage(projectId)
                : null,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
      ],
    );
  }

  Widget _buildSingleImage(String imagePath, bool isMobile, bool showArrows) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child: _buildImageWithErrorHandling(
              imagePath,
              width: 600.sp,
              height: 600.sp,
              fit: BoxFit.cover,
            ),
          ),
          // Arrows (hidden if only one image)
          if (showArrows) ...[
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                iconSize: isMobile ? 30 : 40,
                onPressed: null,
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                iconSize: isMobile ? 30 : 40,
                onPressed: null,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageWithErrorHandling(
    String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Return a placeholder when image fails to load
        return Container(
          width: width,
          height: height,
          color: Colors.grey[800],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image,
                  color: Colors.grey[400],
                  size: (width != null && height != null) 
                      ? (width < height ? width * 0.2 : height * 0.2)
                      : 48,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Image not available',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<String?>> _loadImageSectionIds(List<String> sectionIds) async {
    final contentProvider =
        Provider.of<ContentProvider>(context, listen: false);
    final List<String?> results = [];

    for (final sectionId in sectionIds) {
      try {
        final base64 = await contentProvider.getImageContent(
          'exclusive-leasing-projects',
          sectionId,
        );
        results.add(base64);
      } catch (e) {
        results.add(null);
      }
    }

    return results;
  }

  String _getDefaultDescription(String projectId) {
    switch (projectId) {
      case 'umc':
        return 'EXCLUSIVE_LEASING_UMC_DESCRIPTION';
      case 'park-mall':
        return 'EXCLUSIVE_LEASING_PARK_MALL_DESCRIPTION';
      case 'terrace':
        return 'EXCLUSIVE_LEASING_TERRACE_DESCRIPTION';
      case 'point90':
        return 'EXCLUSIVE_LEASING_POINT90_DESCRIPTION';
      case 'kernel':
        return 'EXCLUSIVE_LEASING_KERNEL_DESCRIPTION';
      case 'city-square':
        return 'EXCLUSIVE_LEASING_CITY_SQUARE_DESCRIPTION';
      case 'vitali':
        return 'EXCLUSIVE_LEASING_VITALI_DESCRIPTION';
      case 'seashell':
        return 'EXCLUSIVE_LEASING_SEASHELL_DESCRIPTION';
      default:
        return '';
    }
  }
}

