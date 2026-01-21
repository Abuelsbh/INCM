import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:incm/generated/assets.dart';
import 'package:provider/provider.dart';
import '../core/Content/content_provider.dart';
import '../core/Firebase/firebase_logos_service.dart';
import '../core/Language/locales.dart';
import 'base64_image_widget.dart';
import 'custom_button.dart';

class ClientsLogosSection extends StatefulWidget {
  final List<String>? logos; // Fallback logos from assets
  final String? pageId; // Page ID to fetch logos from Firebase
  final String? title;
  final bool fetchAllServices; // If true, fetch logos from all 8 services
  final Color? titleColor;
  final Color? backgroundColor;
  final double? logoWidth;
  final double? logoHeight;
  final int visibleLogosCount;
  final double? opacity;
  final VoidCallback? onLearnMorePressed; // Optional callback for LEARN MORE button

  const ClientsLogosSection({
    super.key,
    this.logos,
    this.pageId,
    this.fetchAllServices = false, // Default to false
    this.titleColor,
    this.backgroundColor,
    this.logoWidth,
    this.logoHeight,
    this.visibleLogosCount = 5, 
    this.title,
    this.opacity,
    this.onLearnMorePressed,
  });

  @override
  State<ClientsLogosSection> createState() => _ClientsLogosSectionState();
}

class _ClientsLogosSectionState extends State<ClientsLogosSection> {
  final ScrollController _scrollController = ScrollController();
  final FirebaseLogosService _logosService = FirebaseLogosService();
  bool _showArrows = true;
  Timer? _autoScrollTimer;
  bool _isAutoScrolling = false;
  List<String> _logoBase64List = [];
  List<Widget> _preloadedLogoWidgets = []; // Preloaded logo widgets
  bool _isLoadingLogos = true;

  @override
  void initState() {
    super.initState();
    _loadLogos();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfArrowsNeeded();
      _startAutoScroll();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ClientsLogosSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload logos if pageId or fetchAllServices changed
    if (oldWidget.pageId != widget.pageId || 
        oldWidget.fetchAllServices != widget.fetchAllServices ||
        oldWidget.logos != widget.logos) {
      _loadLogos();
    }
  }

  Future<void> _loadLogos() async {
    setState(() {
      _isLoadingLogos = true;
      _logoBase64List = [];
      _preloadedLogoWidgets = [];
    });

    // If fetchAllServices is true, load all logos from all 8 services
    if (widget.fetchAllServices) {
      try {
        debugPrint('=== Loading all logos from all 8 services ===');
        final logos = await _logosService.getAllServicesLogos();
        debugPrint('Loaded ${logos.length} logos from all services');
        
        if (mounted) {
          final validLogos = logos.where((logo) {
            final isValid = logo.imageBase64.isNotEmpty;
            if (!isValid) {
              debugPrint('⚠️ Logo ${logo.id} has empty imageBase64');
            }
            return isValid;
          }).toList();
          
          debugPrint('Found ${validLogos.length} valid logos (with non-empty imageBase64)');
          
          final base64List = validLogos.map((logo) => logo.imageBase64).toList();
          
          // Preload all logos into memory
          await _preloadLogos(base64List);
          
          if (mounted) {
            setState(() {
              _logoBase64List = base64List;
              _isLoadingLogos = false;
            });
            debugPrint('Set ${_logoBase64List.length} logos in state');
            
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _checkIfArrowsNeeded();
            });
          }
        }
        
        // If no logos from Firebase, fallback to assets
        if (_logoBase64List.isEmpty && widget.logos != null && widget.logos!.isNotEmpty && mounted) {
          debugPrint('⚠️ No logos from Firebase, using fallback assets');
          await _preloadAssetLogos(widget.logos!);
          setState(() {
            _logoBase64List = widget.logos!;
            _isLoadingLogos = false;
          });
        } else if (_logoBase64List.isEmpty && mounted) {
          debugPrint('⚠️ No logos from Firebase and no fallback assets provided');
          setState(() {
            _isLoadingLogos = false;
          });
        }
      } catch (e, stackTrace) {
        debugPrint('❌ Error loading all services logos from Firebase: $e');
        debugPrint('Stack trace: $stackTrace');
        // Fallback to asset logos if Firebase fails
        if (widget.logos != null && widget.logos!.isNotEmpty && mounted) {
          debugPrint('Falling back to asset logos');
          await _preloadAssetLogos(widget.logos!);
          setState(() {
            _logoBase64List = widget.logos!;
            _isLoadingLogos = false;
          });
        } else if (mounted) {
          setState(() {
            _isLoadingLogos = false;
          });
        }
      }
    } else if (widget.pageId != null && widget.pageId!.isNotEmpty) {
      try {
        debugPrint('=== Loading logos for pageId: ${widget.pageId} ===');
        final logos = await _logosService.getAllLogos(pageId: widget.pageId).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            debugPrint('⚠️ Firebase timeout, will use fallback assets');
            return [];
          },
        );
        debugPrint('Loaded ${logos.length} logos from Firebase');
        
        if (logos.isEmpty) {
          debugPrint('⚠️ No logos found in Firebase for pageId: ${widget.pageId}');
          debugPrint('⚠️ Make sure you added logos with pageId="${widget.pageId}" in the admin panel');
        }
        
        List<String> base64List = [];
        
        if (mounted && logos.isNotEmpty) {
          final validLogos = logos.where((logo) {
            final isValid = logo.imageBase64.isNotEmpty;
            if (!isValid) {
              debugPrint('⚠️ Logo ${logo.id} has empty imageBase64');
            }
            return isValid;
          }).toList();
          
          debugPrint('Found ${validLogos.length} valid logos (with non-empty imageBase64)');
          
          base64List = validLogos.map((logo) => logo.imageBase64).toList();
          
          if (base64List.isNotEmpty) {
            // Preload all logos into memory
            await _preloadLogos(base64List);
            
            if (mounted) {
              setState(() {
                _logoBase64List = base64List;
                _isLoadingLogos = false;
              });
              debugPrint('Set ${_logoBase64List.length} logos in state');
              
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _checkIfArrowsNeeded();
              });
            }
          }
        }
        
        // If no logos from Firebase, fallback to assets
        if (base64List.isEmpty && widget.logos != null && widget.logos!.isNotEmpty && mounted) {
          debugPrint('⚠️ No logos from Firebase, using fallback assets');
          await _preloadAssetLogos(widget.logos!);
          setState(() {
            _logoBase64List = widget.logos!;
            _isLoadingLogos = false;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkIfArrowsNeeded();
          });
        } else if (base64List.isEmpty && mounted) {
          debugPrint('⚠️ No logos from Firebase and no fallback assets provided');
          setState(() {
            _isLoadingLogos = false;
          });
        }
      } catch (e, stackTrace) {
        debugPrint('❌ Error loading logos from Firebase: $e');
        debugPrint('Stack trace: $stackTrace');
        // Fallback to asset logos if Firebase fails
        if (widget.logos != null && widget.logos!.isNotEmpty && mounted) {
          debugPrint('Falling back to asset logos');
          await _preloadAssetLogos(widget.logos!);
          setState(() {
            _logoBase64List = widget.logos!;
            _isLoadingLogos = false;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkIfArrowsNeeded();
          });
        } else if (mounted) {
          setState(() {
            _isLoadingLogos = false;
          });
        }
      }
    } else if (widget.logos != null && widget.logos!.isNotEmpty) {
      if (mounted) {
        debugPrint('Using asset logos (no pageId provided)');
        await _preloadAssetLogos(widget.logos!);
        setState(() {
          _logoBase64List = widget.logos!;
          _isLoadingLogos = false;
        });
      }
    } else {
      debugPrint('No pageId and no fallback logos provided');
      if (mounted) {
        setState(() {
          _isLoadingLogos = false;
        });
      }
    }
  }

  /// Preload all base64 logos into memory widgets
  Future<void> _preloadLogos(List<String> base64List) async {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final logoWidth = widget.logoWidth ?? (isMobile ? 65.w : 180.w);
    final logoHeight = widget.logoHeight ?? (isMobile ? 85.h : 80.h);
    
    final preloadedWidgets = <Widget>[];
    
    for (var base64String in base64List) {
      try {
        String cleanBase64 = base64String.trim();
        
        // Check if it's already a data URL and extract the base64 part
        if (cleanBase64.startsWith('data:image')) {
          final parts = cleanBase64.split(',');
          if (parts.length == 2) {
            cleanBase64 = parts[1].trim();
          }
        }
        
        // Remove any whitespace, newlines, etc.
        cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s'), '');
        
        if (cleanBase64.isEmpty) continue;
        
        // Decode and create Image widget with caching
        final bytes = base64Decode(cleanBase64);
        
        if (bytes.isEmpty) continue;
        
        // Precache the image first
        try {
          await precacheImage(MemoryImage(bytes), context);
        } catch (e) {
          debugPrint('Warning: Failed to precache image: $e');
        }
        
        // Create preloaded Image widget with cache dimensions
        final imageWidget = RepaintBoundary(
          child: Image.memory(
            bytes,
            width: logoWidth,
            height: logoHeight,
            fit: BoxFit.contain,
            // Don't cache dimensions to preserve full quality
            filterQuality: FilterQuality.high,
            gaplessPlayback: true, // Smooth transitions
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.broken_image,
                color: Colors.white.withOpacity(0.5),
                size: logoWidth * 0.5,
              );
            },
          ),
        );
        
        preloadedWidgets.add(imageWidget);
      } catch (e) {
        debugPrint('Error preloading logo: $e');
        // Add placeholder for failed logo
        preloadedWidgets.add(
          Icon(
            Icons.broken_image,
            color: Colors.white.withOpacity(0.5),
            size: logoWidth * 0.5,
          ),
        );
      }
    }
    
    if (mounted) {
      setState(() {
        _preloadedLogoWidgets = preloadedWidgets;
      });
    }
  }

  /// Preload asset logos
  Future<void> _preloadAssetLogos(List<String> assetPaths) async {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final logoWidth = widget.logoWidth ?? (isMobile ? 65.w : 180.w);
    final logoHeight = widget.logoHeight ?? (isMobile ? 85.h : 80.h);
    
    final preloadedWidgets = <Widget>[];
    
    debugPrint('=== Loading ${assetPaths.length} asset logos ===');
    
    for (var assetPath in assetPaths) {
      try {
        debugPrint('Loading asset: $assetPath');
        Widget imageWidget;
        
        if (assetPath.toLowerCase().endsWith('.svg')) {
          imageWidget = SvgPicture.asset(
            assetPath,
            width: logoWidth,
            height: logoHeight,
            fit: BoxFit.contain,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => Icon(
              Icons.image,
              color: Colors.white.withOpacity(0.3),
              size: logoWidth * 0.5,
            ),
          );
        } else {
          // Precache asset image first
          try {
            await precacheImage(AssetImage(assetPath), context);
            debugPrint('Successfully precached: $assetPath');
          } catch (e) {
            debugPrint('⚠️ Warning: Failed to precache asset $assetPath: $e');
          }
          
          imageWidget = RepaintBoundary(
            child: Image.asset(
              assetPath,
              width: logoWidth,
              height: logoHeight,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('❌ Error loading asset image $assetPath: $error');
                debugPrint('Stack trace: $stackTrace');
                return Icon(
                  Icons.broken_image,
                  color: Colors.white.withOpacity(0.5),
                  size: logoWidth * 0.5,
                );
              },
            ),
          );
        }
        
        preloadedWidgets.add(imageWidget);
        debugPrint('✅ Successfully added logo widget for: $assetPath');
      } catch (e, stackTrace) {
        debugPrint('❌ Error preloading asset logo $assetPath: $e');
        debugPrint('Stack trace: $stackTrace');
        preloadedWidgets.add(
          Icon(
            Icons.broken_image,
            color: Colors.white.withOpacity(0.5),
            size: logoWidth * 0.5,
          ),
        );
      }
    }
    
    debugPrint('=== Preloaded ${preloadedWidgets.length} logo widgets ===');
    
    if (mounted) {
      setState(() {
        _preloadedLogoWidgets = preloadedWidgets;
      });
    }
  }

  void _startAutoScroll() {
    // Start auto-scrolling every 5 seconds
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && _scrollController.hasClients && _canScrollRight) {
        _isAutoScrolling = true;
        _scrollRight();
        // Reset flag after animation completes
        Future.delayed(const Duration(milliseconds: 300), () {
          _isAutoScrolling = false;
        });
      } else if (mounted && _scrollController.hasClients && !_canScrollRight) {
        // If reached the end, scroll back to the beginning
        _isAutoScrolling = true;
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          _isAutoScrolling = false;
        });
      }
    });
  }

  void _checkIfArrowsNeeded() {
    if (_scrollController.hasClients) {
      setState(() {
       // _showArrows = _logoBase64List.length > widget.visibleLogosCount;
        _showArrows=true;
      });
    }
  }

  void _onScroll() {
    setState(() {});
  }

  void _scrollLeft() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.position.pixels;
      final scrollAmount = MediaQuery.of(context).size.width * 0.3;
      final newPosition = (currentPosition - scrollAmount).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.animateTo(
        newPosition,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _scrollRight() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.position.pixels;
      final scrollAmount = MediaQuery.of(context).size.width * 0.3;
      final maxScroll = _scrollController.position.maxScrollExtent;
      final newPosition = (currentPosition + scrollAmount).clamp(
        0.0,
        maxScroll,
      );
      
      // If we're at or near the end, scroll back to start for infinite loop
      if (newPosition >= maxScroll - 10) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
        );
      } else {
        _scrollController.animateTo(
          newPosition,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  bool get _canScrollLeft {
    if (!_scrollController.hasClients) return false;
    return _scrollController.position.pixels > 0;
  }

  bool get _canScrollRight {
    if (!_scrollController.hasClients) return false;
    return _scrollController.position.pixels <
        _scrollController.position.maxScrollExtent;
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final titleColor = widget.titleColor ?? const Color(0xFFF4ED47);
    final backgroundColor = widget.backgroundColor ?? Colors.grey[900]!.withOpacity(0.4);
    final logoWidth = widget.logoWidth ?? (isMobile ? 65.w : 180.w);
    final logoHeight = widget.logoHeight ?? (isMobile ? 85.h : 80.h);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: isMobile ? 0.h :30.h),
          child: Text(
            widget.title != null ? widget.title!.tr(context).toUpperCase() : 'OUR_CLIENTS'.tr(context),
            style: TextStyle(
              fontFamily: 'OptimalBold',
              color: titleColor,
              fontSize: isMobile ? 22.sp : 60.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),

        Gap(12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: isMobile ? 8.h : 20.h,horizontal: isMobile ? 8.h : 20.w),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(widget.opacity??1),
            borderRadius: BorderRadius.circular(isMobile ? 24.r : 50.r),
          ),
          child: Column(
            children: [
              // Logos Container with Arrows
              Stack(
                alignment: Alignment.center,
                children: [
                  // Logos List
                  Container(
                    height: logoHeight + (isMobile ? 14.h : 40.h),
                    margin: EdgeInsets.symmetric(horizontal: _showArrows ? isMobile ? 24.w : 60.w : 0),
                    child: _isLoadingLogos
                        ? Center(
                            child: CircularProgressIndicator(
                              color: titleColor,
                            ),
                          )
                        : _preloadedLogoWidgets.isEmpty && _logoBase64List.isEmpty
                        ? Center(
                            child: Text(
                                  'No logos',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: isMobile ? 12.sp : 16.sp,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                                physics: const ClampingScrollPhysics(), // Smoother scrolling
                                cacheExtent: 2000, // Cache more items for smoother scrolling
                                addAutomaticKeepAlives: false, // Improve performance
                                addRepaintBoundaries: true, // Improve performance
                                itemCount: _preloadedLogoWidgets.isNotEmpty 
                                    ? _preloadedLogoWidgets.length 
                                    : _logoBase64List.length,
                            itemBuilder: (context, index) {
                                  // Use preloaded widgets if available, otherwise build on demand
                                  if (_preloadedLogoWidgets.isNotEmpty && index < _preloadedLogoWidgets.length) {
                                    return RepaintBoundary(
                                      key: ValueKey('logo_$index'),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: isMobile ? 4.w : 25.w,
                                        ),
                                        width: logoWidth,
                                        height: logoHeight,
                                        child: _preloadedLogoWidgets[index],
                                      ),
                                    );
                                  } else if (index < _logoBase64List.length) {
                                    return RepaintBoundary(
                                      key: ValueKey('logo_$index'),
                                      child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 4.w : 25.w,
                                ),
                                width: logoWidth,
                                height: logoHeight,
                                child: _buildLogoItem(_logoBase64List[index], logoWidth, logoHeight),
                                      ),
                              );
                                  }
                                  return SizedBox();
                            },
                          ),
                  ),

                  // Left Arrow
                  if (_showArrows)
                    Positioned(
                      left: 0,
                      child: _buildArrowButton(
                        icon: Icons.arrow_back_ios,
                        onPressed: _canScrollLeft ? _scrollLeft : null,
                      ),
                    ),

                  // Right Arrow
                  if (_showArrows)
                    Positioned(
                      right: 0,
                      child: _buildArrowButton(
                        icon: Icons.arrow_forward_ios,
                        onPressed: _canScrollRight ? _scrollRight : null,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        // LEARN MORE Button
        if (widget.onLearnMorePressed != null) ...[
          Gap(isMobile ? 20.h : 30.h),
          Center(
            child: isMobile
                ? ButtonStyles.learnMoreButtonMob(
                    context: context,
                    onPressed: widget.onLearnMorePressed!,
                  )
                : ButtonStyles.learnMoreButton(
                    context: context,
                    onPressed: widget.onLearnMorePressed!,
                  ),
          ),
        ],
      ],
    );




  }

  Widget _buildLogoItem(String logoData, double width, double height) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(isMobile ? 2.w : 8.w),
      child: Builder(
        builder: (_) {
          // Check if logoData is empty or null
          if (logoData.isEmpty) {
            debugPrint('Logo data is empty');
            return Icon(
              Icons.business,
              color: Colors.white.withOpacity(0.5),
              size: width * 0.5,
            );
          }

          // If pageId is provided, we're loading from Firebase, so assume Base64
          // Otherwise, check if it's a base64 string or an asset path
          final bool isBase64;
          
          if (widget.pageId != null && widget.pageId!.isNotEmpty) {
            // If loading from Firebase, always treat as Base64
            isBase64 = true;
          } else {
            // Check if it's a base64 string using regex pattern
            // Base64 strings contain only A-Z, a-z, 0-9, +, /, = and are typically long
            final base64Pattern = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
            final isDataUri = logoData.startsWith('data:image');
            final looksLikeBase64 = logoData.length > 50 && base64Pattern.hasMatch(logoData.replaceAll(RegExp(r'\s'), ''));
            
            // Check if it looks like an asset path
            final looksLikeAsset = logoData.contains('assets/') || 
                                  logoData.contains('.svg') ||
                                  logoData.contains('.png') ||
                                  logoData.contains('.jpg') ||
                                  logoData.contains('.jpeg') ||
                                  logoData.contains('.webp');
            
            isBase64 = isDataUri || (looksLikeBase64 && !looksLikeAsset);
          }
          
          if (isBase64) {
            // Use Base64ImageWidget for base64 images
            return Base64ImageWidget(
              base64String: logoData,
              width: width,
              height: height,
              fit: BoxFit.contain,
            );
          } else {
            // Asset path (fallback)
            try {
              // Try SVG first
              if (logoData.toLowerCase().endsWith('.svg')) {
                return SvgPicture.asset(
                  logoData,
                  width: width,
                  height: height,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                );
              } else {
                // Try Image
                return Image.asset(
                  logoData,
                  width: width,
                  height: height,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high, // High quality rendering
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading asset image: $error');
                    return Icon(
                      Icons.broken_image,
                      color: Colors.white.withOpacity(0.5),
                      size: width * 0.5,
                    );
                  },
                );
              }
            } catch (e) {
              debugPrint('Error loading asset logo: $e');
              return Icon(
                Icons.broken_image,
                color: Colors.white.withOpacity(0.5),
                size: width * 0.5,
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          width: isMobile ? 34.r: 50.r,
          height: isMobile ? 34.r: 50.r,
          decoration: BoxDecoration(
            color: onPressed != null
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(
              color: onPressed != null
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: onPressed != null
                ? Colors.white
                : Colors.white.withOpacity(0.3),
            size: isMobile ? 14 .sp : 24.sp,
          ),
        ),
      ),
    );
  }
}








