import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../generated/assets.dart';
import '../splash_session.dart';

/// Design 1: Typewriter animation on first splash per session; full logo (no
/// animation) on later splashes while Firebase loads.
/// Navigation is handled by splash_controller (loadDataAndNavigate).
class SplashDesign1 extends StatefulWidget {
  final bool showTypewriter;

  const SplashDesign1({super.key, required this.showTypewriter});

  @override
  State<SplashDesign1> createState() => _SplashDesign1State();
}

class _SplashDesign1State extends State<SplashDesign1>
    with SingleTickerProviderStateMixin {
  AnimationController? _typewriterController;
  Animation<double>? _typewriterAnimation;

  @override
  void initState() {
    super.initState();

    if (!widget.showTypewriter) {
      return;
    }

    _typewriterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _typewriterAnimation = CurvedAnimation(
      parent: _typewriterController!,
      curve: Curves.easeInOut,
    );

    _typewriterController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        SplashSession.completeAnimation();
      }
    });

    _typewriterController!.forward();
  }

  @override
  void dispose() {
    _typewriterController?.dispose();
    super.dispose();
  }

  Widget _logo(double logoSize, double clipProgress) {
    return ClipRect(
      clipper: TypewriterClipper(clipProgress),
      child: Image.asset(
        Assets.logosINCMLogo,
        width: logoSize,
        height: logoSize,
        fit: BoxFit.contain,
        cacheWidth: logoSize.toInt(),
        cacheHeight: logoSize.toInt(),
        filterQuality: FilterQuality.medium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double logoSize = 1000.r;

    return Scaffold(
      backgroundColor: const Color(0xFFF4ED47),
      body: Center(
        child: RepaintBoundary(
          child: widget.showTypewriter && _typewriterAnimation != null
              ? AnimatedBuilder(
                  animation: _typewriterAnimation!,
                  builder: (context, _) =>
                      _logo(logoSize, _typewriterAnimation!.value),
                )
              : _logo(logoSize, 1.0),
        ),
      ),
    );
  }
}

/// Custom clipper for typewriter effect - reveals from left to right
class TypewriterClipper extends CustomClipper<Rect> {
  final double progress;

  const TypewriterClipper(this.progress);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * progress, size.height);
  }

  @override
  bool shouldReclip(TypewriterClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
