import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../generated/assets.dart';
import '../../Home/home_screen.dart';

/// Design 1: Typewriter animation - logo reveals letter by letter
class SplashDesign1 extends StatefulWidget {
  const SplashDesign1({super.key});

  @override
  State<SplashDesign1> createState() => _SplashDesign1State();
}

class _SplashDesign1State extends State<SplashDesign1>
    with TickerProviderStateMixin {
  late final AnimationController _typewriterController;
  late final Animation<double> _typewriterAnimation;

  @override
  void initState() {
    super.initState();
    
    // Typewriter animation: 2 seconds to reveal the logo letter by letter
    _typewriterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _typewriterAnimation = CurvedAnimation(
      parent: _typewriterController,
        curve: Curves.easeInOut,
    );

    _typewriterController.forward();

    // Navigate to home after animation completes
    _typewriterController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        GoRouter.of(context).go(HomeScreen.routeName);
      }
    });
  }

  @override
  void dispose() {
    _typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double logoSize = MediaQuery.of(context).size.width < 600 ? 300.r : 1000.r;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4ED47), // Yellow background
      body: Center(
        child: AnimatedBuilder(
          animation: _typewriterAnimation,
          builder: (context, _) {
            return ClipRect(
              clipper: TypewriterClipper(_typewriterAnimation.value),
              child: Image.asset(
                Assets.logosINCMLogo,
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Custom clipper for typewriter effect - reveals from left to right
class TypewriterClipper extends CustomClipper<Rect> {
  final double progress;

  TypewriterClipper(this.progress);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * progress, size.height);
  }

  @override
  bool shouldReclip(TypewriterClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}










