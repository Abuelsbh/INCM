import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../generated/assets.dart';
import '../../Home/home_screen.dart';

/// Design 2: Dynamic slide in with particles and glow effect
class SplashDesign2 extends StatefulWidget {
  const SplashDesign2({super.key});

  @override
  State<SplashDesign2> createState() => _SplashDesign2State();
}

class _SplashDesign2State extends State<SplashDesign2>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _particleController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _glowAnimation;
  late final Animation<double> _opacityAnimation;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Create particles
    for (int i = 0; i < 20; i++) {
      _particles.add(Particle());
    }

    _mainController.forward();

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
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double logoSize = MediaQuery.of(context).size.width < 600 ? 400.r : 700.r;
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4ED47),
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_mainController, _particleController]),
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Animated particles
                ..._particles.map((particle) {
                  final progress = _particleController.value;
                  final angle = particle.angle + (progress * 2 * math.pi);
                  final distance = particle.distance * (0.5 + progress * 0.5);
                  final x = screenSize.width / 2 + math.cos(angle) * distance;
                  final y = screenSize.height / 2 + math.sin(angle) * distance;
                  
                  return Positioned(
                    left: x,
                    top: y,
                    child: Opacity(
                      opacity: (1 - progress) * 0.6,
                      child: Container(
                        width: particle.size,
                        height: particle.size,
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }).toList(),

                // Glow effect
                Container(
                  width: logoSize * 1.3,
                  height: logoSize * 1.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withOpacity(_glowAnimation.value * 0.4),
                        blurRadius: 50 * _glowAnimation.value,
                        spreadRadius: 20 * _glowAnimation.value,
                      ),
                    ],
                  ),
                ),

                // Main logo with slide animation
                SlideTransition(
                  position: _slideAnimation,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: Image.asset(
                      _mainController.value > 0.7 
                          ? Assets.iconsSplash2 
                          : Assets.iconsSplash1,
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
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

class Particle {
  final double angle;
  final double distance;
  final double size;

  Particle()
      : angle = math.Random().nextDouble() * 2 * math.pi,
        distance = 100 + math.Random().nextDouble() * 200,
        size = 3 + math.Random().nextDouble() * 5;
}









