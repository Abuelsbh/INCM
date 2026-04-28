import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../Widgets/bottom_navbar_widget.dart';
import '../../Widgets/custom_app_bar.dart';
import '../../Widgets/custom_app_bar_mob.dart';
import '../../Widgets/floating_contact_buttons.dart';
import '../../Widgets/scroll_to_top_button.dart';
import '../../Widgets/footer_section.dart';
import '../../Widgets/footer_section_mob.dart';
import '../../Widgets/dynamic_content_widget.dart';
import '../../core/Language/app_languages.dart';
import '../../core/Content/content_provider.dart';
import '../../core/Content/exclusive_leasing_projects_data.dart';
import '../../Utilities/font_helper.dart';
import '../../core/Language/locales.dart';
import '../../core/responsive/native_layout.dart';
import 'package:provider/provider.dart';

const Color _kExclusiveLeasingAccent = Color(0xFFF4ED47);

/// Download-style loading state while remote images resolve (logo / gallery / section list).
Widget _exclusiveLeasingLoadingBox({
  double? width,
  double? height,
  bool expand = false,
}) {
  final indicator = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.download_rounded,
        color: _kExclusiveLeasingAccent,
        size: 40.sp,
      ),
      SizedBox(height: 12.h),
      SizedBox(
        width: 26.w,
        height: 26.w,
        child: const CircularProgressIndicator(
          strokeWidth: 2.5,
          color: _kExclusiveLeasingAccent,
        ),
      ),
    ],
  );

  final box = ColoredBox(
    color: const Color(0xFF1A1A1A),
    child: Center(child: indicator),
  );

  if (expand) {
    return SizedBox.expand(child: box);
  }
  return SizedBox(width: width, height: height, child: box);
}

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

  // GlobalKeys for scrolling to specific projects
  final Map<String, GlobalKey> _projectKeys = {};

  String _precacheSlugSig = '';

  /// One probe future per project — avoids re-running [_loadImageSectionIds] on every
  /// [ContentProvider] rebuild while [Consumer] updates the subtree.
  final Map<String, Future<List<String?>>> _gallerySectionProbeFutures = {};

  String? _targetProjectId;

  List<String> _orderedSlugs(ContentProvider cp) {
    final cached = cp.peekCachedPageContent(ExclusiveLeasingProjectsData.pageId);
    if (cached == null) {
      return ExclusiveLeasingProjectsData.orderedSlugs;
    }
    return ExclusiveLeasingProjectsData.displayOrderSlugs(
      ExclusiveLeasingProjectsData.discoverSlugsFromContents(cached),
    );
  }

  List<Map<String, dynamic>> _projectRowsForSlugs(List<String> slugs) {
    return slugs
        .map((id) => ExclusiveLeasingProjectsData.seedForSlug(id).toProjectRowMap(id))
        .toList();
  }

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _animationController.forward();
      context.read<ContentProvider>().ensurePageLoaded(ExclusiveLeasingProjectsData.pageId);
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
    return Consumer<ContentProvider>(
      builder: (context, cp, _) {
        final slugs = _orderedSlugs(cp);
        for (final id in slugs) {
          _projectKeys.putIfAbsent(id, () => GlobalKey());
        }
        final projects = _projectRowsForSlugs(slugs);
        final sig = slugs.join(',');
        if (sig != _precacheSlugSig) {
          _precacheSlugSig = sig;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            for (final project in projects) {
              final localImages = List<String>.from(
                project['localImages'] as List<dynamic>? ?? [],
              );
              for (final path in localImages) {
                precacheImage(AssetImage(path), context);
              }
            }
          });
        }

        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            bottomNavigationBar: useNativeBottomNavigationBar(context)
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
                                  ...projects.asMap().entries.expand((entry) {
                                    final index = entry.key;
                                    final project = entry.value;
                                    final isLast = index == projects.length - 1;
                                    return [
                                      _buildProjectCard(context, project, isMobile),
                                      if (!isLast)
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: isMobile ? 20.h : 40.h,
                                          ),
                                          child: Divider(
                                            color: Colors.white.withOpacity(0.25),
                                            thickness: 1,
                                            height: 1,
                                          ),
                                        ),
                                    ];
                                  }),
                                  SizedBox(height: isMobile ? 40.h : 80.h),
                                ],
                              ),
                            ),
                            if (kIsWeb)
                              (MediaQuery.sizeOf(context).width >= 600
                                  ? const FooterSection()
                                  : const FooterSectionMob()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                useWebDesktopAppBar(context)
                    ? const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: CustomAppBar(),
                      )
                    : const Positioned(
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
      },
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    Map<String, dynamic> project,
    bool isMobile,
  ) {
    final projectId = project['id'] as String;
    final logoFallback = project['logoFallback'] as String;
    final imageFallback = project['imageFallback'] as String;
    final localImages = List<String>.from(project['localImages'] as List<dynamic>? ?? []);

    return Container(
      key: _projectKeys[projectId],
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DynamicImage(
                      pageId: 'exclusive-leasing-projects',
                      sectionId: '${projectId}-logo',
                      fallbackAssetPath: logoFallback,
                      width: 140.w,
                      height: 140.h,
                      fit: BoxFit.contain,
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
                  child: _buildImageCarousel(
                    projectId,
                    imageFallback,
                    isMobile,
                    localImages,
                  ),
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
                          DynamicImage(
                            pageId: 'exclusive-leasing-projects',
                            sectionId: '${projectId}-logo',
                            fallbackAssetPath: logoFallback,
                            width: 150.w,
                            height: 150.h,
                            fit: BoxFit.contain,
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
                  child: _buildImageCarousel(
                    projectId,
                    imageFallback,
                    isMobile,
                    localImages,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildImageCarousel(
    String projectId,
    String fallbackImage,
    bool isMobile,
    List<String> localImages,
  ) {
    final List<String> imageSectionIds = [];
    for (int i = 0; i < 20; i++) {
      imageSectionIds.add('$projectId-image-$i');
    }

    return FutureBuilder<List<String?>>(
      future: _gallerySectionProbeFutures.putIfAbsent(
        projectId,
        () => _loadImageSectionIds(imageSectionIds),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _exclusiveLeasingLoadingBox(expand: true);
        }

        if (snapshot.hasData) {
          final existingImageIds = snapshot.data!
              .asMap()
              .entries
              .where((e) => e.value != null && e.value!.isNotEmpty)
              .map((e) => imageSectionIds[e.key])
              .toList();

          return _ProjectImageCarousel(
            projectId: projectId,
            fallbackImage: fallbackImage,
            isMobile: isMobile,
            localImages: localImages,
            firebaseImageIds: existingImageIds.isEmpty ? null : existingImageIds,
          );
        }

        return _ProjectImageCarousel(
          projectId: projectId,
          fallbackImage: fallbackImage,
          isMobile: isMobile,
          localImages: localImages,
          firebaseImageIds: null,
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
    return ExclusiveLeasingProjectsData.defaultDescriptionTrKeyForSlug(projectId);
  }
}

/// Isolated carousel widget - setState only rebuilds this widget, not the whole screen
class _ProjectImageCarousel extends StatefulWidget {
  final String projectId;
  final String fallbackImage;
  final bool isMobile;
  final List<String> localImages;
  final List<String>? firebaseImageIds;

  const _ProjectImageCarousel({
    required this.projectId,
    required this.fallbackImage,
    required this.isMobile,
    required this.localImages,
    this.firebaseImageIds,
  });

  @override
  State<_ProjectImageCarousel> createState() => _ProjectImageCarouselState();
}

class _ProjectImageCarouselState extends State<_ProjectImageCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextImage() {
    if (!_pageController.hasClients) return;
    final count = widget.firebaseImageIds?.length ??
        (widget.localImages.isNotEmpty ? widget.localImages.length : 1);
    if (_currentIndex < count - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _previousImage() {
    if (!_pageController.hasClients) return;
    final count = widget.firebaseImageIds?.length ??
        (widget.localImages.isNotEmpty ? widget.localImages.length : 1);
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _pageController.animateToPage(
        count - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagesToShow = widget.localImages.isNotEmpty
        ? widget.localImages
        : [widget.fallbackImage];
    final arrowWidth = widget.isMobile ? 38.w : 56.w;

    // Firebase images path
    if (widget.firebaseImageIds != null && widget.firebaseImageIds!.isNotEmpty) {
      final existingImageIds = widget.firebaseImageIds!;
      if (existingImageIds.length == 1) {
        final sectionId = existingImageIds.single;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: arrowWidth),
          child: GestureDetector(
            onTap: () => _showFullScreenFromSectionIds(
              context,
              existingImageIds,
              widget.fallbackImage,
              0,
            ),
            child: RepaintBoundary(
              child: DynamicImage(
                pageId: 'exclusive-leasing-projects',
                sectionId: sectionId,
                fallbackAssetPath: widget.fallbackImage,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: arrowWidth),
              child: GestureDetector(
                onTap: () => _showFullScreenFromSectionIds(
                  context,
                  existingImageIds,
                  widget.fallbackImage,
                  _currentIndex,
                ),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: existingImageIds.length,
                  allowImplicitScrolling: true,
                  physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final sectionId = existingImageIds[index];
                    return RepaintBoundary(
                      child: DynamicImage(
                        pageId: 'exclusive-leasing-projects',
                        sectionId: sectionId,
                        fallbackAssetPath: widget.fallbackImage,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          ..._buildArrowButtons(),
        ],
      );
    }

    // Single local image
    if (imagesToShow.length == 1) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: arrowWidth),
        child: GestureDetector(
          onTap: () => _showFullScreenImages(context, imagesToShow, 0),
          child: _buildImageWithErrorHandling(
            imagesToShow[0],
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Multiple local images
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: arrowWidth),
            child: GestureDetector(
              onTap: () => _showFullScreenImages(context, imagesToShow, _currentIndex),
              child: PageView.builder(
                controller: _pageController,
                itemCount: imagesToShow.length,
                allowImplicitScrolling: true,
                physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return RepaintBoundary(
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
        ),
        ..._buildArrowButtons(),
      ],
    );
  }

  List<Widget> _buildArrowButtons() {
    final isArabic = Provider.of<AppLanguage>(context, listen: false).appLang == Languages.ar;
    return [
      Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        child: Center(
          child: IconButton(
            icon: Icon(
              isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            iconSize: widget.isMobile ? 28 : 36,
            onPressed: _previousImage,
          ),
        ),
      ),
      Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        child: Center(
          child: IconButton(
            icon: Icon(
              isArabic ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            iconSize: widget.isMobile ? 28 : 36,
            onPressed: _nextImage,
          ),
        ),
      ),
    ];
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
                  style: TextStyle(color: Colors.grey[400], fontSize: 12.sp),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFullScreenImages(
    BuildContext context,
    List<String> assetPaths,
    int initialIndex,
  ) {
    if (assetPaths.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              '${initialIndex + 1} / ${assetPaths.length}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            itemCount: assetPaths.length,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: PageController(initialPage: initialIndex),
            onPageChanged: (_) {},
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(assetPaths[index]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
          ),
        ),
      ),
    );
  }

  void _showFullScreenFromSectionIds(
    BuildContext context,
    List<String> sectionIds,
    String fallbackAsset,
    int initialIndex,
  ) {
    if (sectionIds.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              '${initialIndex + 1} / ${sectionIds.length}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: sectionIds.length,
            itemBuilder: (context, index) {
              final sectionId = sectionIds[index];
              final size = MediaQuery.of(context).size;
              return PhotoView.customChild(
                childSize: Size(size.width, size.height),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                child: DynamicImage(
                  pageId: 'exclusive-leasing-projects',
                  sectionId: sectionId,
                  fallbackAssetPath: fallbackAsset,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

