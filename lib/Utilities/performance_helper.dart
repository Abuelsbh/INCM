import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PerformanceHelper {
  // Debounce function to limit function calls
  static Timer? _debounceTimer;
  
  static void debounce(VoidCallback callback, {Duration delay = const Duration(milliseconds: 300)}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }

  // Throttle function to limit function calls to once per duration
  static DateTime? _lastThrottleCall;
  
  static void throttle(VoidCallback callback, {Duration duration = const Duration(milliseconds: 100)}) {
    final now = DateTime.now();
    if (_lastThrottleCall == null || now.difference(_lastThrottleCall!) > duration) {
      _lastThrottleCall = now;
      callback();
    }
  }

  // Optimized scroll listener that only processes events during idle frames
  static void optimizedScrollListener(
    ScrollController controller,
    VoidCallback onScroll,
  ) {
    bool _isScrollingNotifierStarted = false;
    
    controller.addListener(() {
      if (!_isScrollingNotifierStarted) {
        _isScrollingNotifierStarted = true;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _isScrollingNotifierStarted = false;
          onScroll();
        });
      }
    });
  }

  // Memory-efficient image loading
  static Widget buildOptimizedImage({
    required String assetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    bool useCache = true,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      isAntiAlias: true,
      filterQuality: FilterQuality.medium,
    );
  }

  // Lazy loading widget for large lists
  static Widget buildLazyListView({
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    ScrollController? controller,
    EdgeInsetsGeometry? padding,
  }) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Add a small delay for very large lists to maintain smooth scrolling
        if (index % 50 == 0 && index > 0) {
          return FutureBuilder(
            future: Future.delayed(const Duration(microseconds: 1)),
            builder: (context, snapshot) {
              return itemBuilder(context, index);
            },
          );
        }
        return itemBuilder(context, index);
      },
    );
  }

  // Optimized animation controller with automatic disposal
  static AnimationController createOptimizedAnimationController({
    required TickerProvider vsync,
    Duration duration = const Duration(milliseconds: 300),
    Duration? reverseDuration,
    double lowerBound = 0.0,
    double upperBound = 1.0,
    AnimationBehavior animationBehavior = AnimationBehavior.normal,
  }) {
    return AnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
      lowerBound: lowerBound,
      upperBound: upperBound,
      animationBehavior: animationBehavior,
      vsync: vsync,
    );
  }

  // Memory-efficient text rendering
  static Widget buildOptimizedText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    bool softWrap = true,
  }) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      // Optimize text rendering
      textScaler: TextScaler.noScaling,
    );
  }

  // Preload images for better performance
  static Future<void> preloadImages(BuildContext context, List<String> imagePaths) async {
    for (String imagePath in imagePaths) {
      try {
        await precacheImage(AssetImage(imagePath), context);
      } catch (e) {
        debugPrint('Failed to preload image: $imagePath');
      }
    }
  }

  // Optimized container with conditional rendering
  static Widget buildConditionalContainer({
    required bool condition,
    required Widget child,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
  }) {
    if (!condition) return child;
    
    return Container(
      color: color,
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: child,
    );
  }

  // Memory-efficient gradient
  static LinearGradient buildOptimizedGradient({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    List<double>? stops,
    TileMode tileMode = TileMode.clamp,
  }) {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
      stops: stops,
      tileMode: tileMode,
    );
  }

  // Performance monitoring
  static void monitorPerformance(String operationName, VoidCallback operation) {
    final stopwatch = Stopwatch()..start();
    
    try {
      operation();
    } finally {
      stopwatch.stop();
      if (stopwatch.elapsedMilliseconds > 16) { // More than one frame
        debugPrint('Performance Warning: $operationName took ${stopwatch.elapsedMilliseconds}ms');
      }
    }
  }

  // Batch operations for better performance
  static void batchOperations(List<VoidCallback> operations) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      for (final operation in operations) {
        operation();
      }
    });
  }

  // Optimized opacity with conditional rendering
  static Widget buildOptimizedOpacity({
    required double opacity,
    required Widget child,
    bool alwaysIncludeSemantics = false,
  }) {
    if (opacity == 1.0) return child;
    if (opacity == 0.0) return const SizedBox.shrink();
    
    return Opacity(
      opacity: opacity,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: child,
    );
  }
}

// Optimized scroll physics for better performance
class OptimizedScrollPhysics extends BouncingScrollPhysics {
  const OptimizedScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  OptimizedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return OptimizedScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 50.0;

  @override
  double get maxFlingVelocity => 8000.0;

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 0.5,
    stiffness: 100.0,
    damping: 0.8,
  );
}

// Memory-efficient list view
class OptimizedListView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const OptimizedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics ?? const OptimizedScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Use RepaintBoundary for complex items to improve scrolling performance
        return RepaintBoundary(
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

// Lazy loading wrapper for expensive widgets
class LazyWidget extends StatefulWidget {
  final Widget Function() builder;
  final Duration delay;

  const LazyWidget({
    super.key,
    required this.builder,
    this.delay = const Duration(milliseconds: 100),
  });

  @override
  State<LazyWidget> createState() => _LazyWidgetState();
}

class _LazyWidgetState extends State<LazyWidget> {
  Widget? _cachedWidget;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  void _loadWidget() {
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _cachedWidget = widget.builder();
          _isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const SizedBox.shrink();
    }
    return _cachedWidget!;
  }
}
