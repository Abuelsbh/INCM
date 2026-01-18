import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../generated/assets.dart';
import '../../Home/home_screen.dart';

/// Design 1: Elegant fade in with scale and rotation animation
class SplashDesign1 extends StatefulWidget {
  const SplashDesign1({super.key});

  @override
  State<SplashDesign1> createState() => _SplashDesign1State();
}

class _SplashDesign1State extends State<SplashDesign1>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _rotationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotationAnimation;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOut,
      ),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFFF4ED47),
      end: const Color(0xFFF4ED47),
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _mainController.forward();
    _rotationController.repeat();

    _mainController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            GoRouter.of(context).go(HomeScreen.routeName);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double logoSize = MediaQuery.of(context).size.width < 600 ? 400.r : 700.r;
    
    return Scaffold(
      backgroundColor: _colorAnimation.value ?? const Color(0xFFF4ED47),
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_mainController, _rotationController]),
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Rotating background circle
                Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: Opacity(
                    opacity: _fadeAnimation.value * 0.3,
                    child: Container(
                      width: logoSize * 1.2,
                      height: logoSize * 1.2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF4ED47).withOpacity(0.2),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Main logo with fade, scale, and subtle rotation
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: (_rotationAnimation.value * 0.5) - 0.05,
                      child: Image.asset(
                        Assets.iconsSplash1,
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}









