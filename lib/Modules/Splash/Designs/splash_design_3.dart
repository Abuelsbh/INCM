import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../generated/assets.dart';
import '../../Home/home_screen.dart';

/// Design 3: Pulse and ripple wave animation
class SplashDesign3 extends StatefulWidget {
  const SplashDesign3({super.key});

  @override
  State<SplashDesign3> createState() => _SplashDesign3State();
}

class _SplashDesign3State extends State<SplashDesign3>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _pulseController;
  late final AnimationController _rippleController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _rippleAnimation;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rippleController,
        curve: Curves.easeOut,
      ),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFFF4ED47),
      end: const Color(0xFF000000),
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

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
    _pulseController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double logoSize = MediaQuery.of(context).size.width < 600 ? 400.r : 700.r;
    
    return Scaffold(
      backgroundColor: _colorAnimation.value ?? const Color(0xFFF4ED47),
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _mainController,
            _pulseController,
            _rippleController,
          ]),
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Ripple waves
                ...List.generate(3, (index) {
                  final delay = index * 0.3;
                  final adjustedValue = ((_rippleAnimation.value + delay) % 1.0);
                  final opacity = (1 - adjustedValue) * 0.3;
                  final scale = 0.8 + (adjustedValue * 0.6);
                  
                  return Container(
                    width: logoSize * scale * 1.5,
                    height: logoSize * scale * 1.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF000000).withOpacity(opacity),
                        width: 2,
                      ),
                    ),
                  );
                }),

                // Pulsing logo
                Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Image.asset(
                      _mainController.value > 0.6 
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









