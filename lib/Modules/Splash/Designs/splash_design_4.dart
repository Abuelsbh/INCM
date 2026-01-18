import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../generated/assets.dart';
import '../../Home/home_screen.dart';

/// Design 4: Morphing geometric shapes with logo reveal
class SplashDesign4 extends StatefulWidget {
  const SplashDesign4({super.key});

  @override
  State<SplashDesign4> createState() => _SplashDesign4State();
}

class _SplashDesign4State extends State<SplashDesign4>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _shapeController;
  late final Animation<double> _shapeAnimation;
  late final Animation<double> _logoRevealAnimation;
  late final Animation<double> _rotationAnimation;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _shapeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _shapeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _shapeController,
        curve: Curves.easeInOut,
      ),
    );

    _logoRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _colorAnimation = ColorTween(
      begin: const Color(0xFFF4ED47),
      end: const Color(0xFF000000),
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _shapeController.forward();
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
    _shapeController.dispose();
    super.dispose();
  }

  Widget _buildMorphingShape(double size, double progress) {
    final sides = 6.0 + (progress * 2.0); // Morph from hexagon to octagon
    final angle = (2 * math.pi) / sides;
    final radius = size / 2;

    return CustomPaint(
      size: Size(size, size),
      painter: MorphingShapePainter(
        sides: sides,
        angle: angle,
        radius: radius,
        progress: progress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double logoSize = MediaQuery.of(context).size.width < 600 ? 400.r : 700.r;
    
    return Scaffold(
      backgroundColor: _colorAnimation.value ?? const Color(0xFFF4ED47),
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_mainController, _shapeController]),
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Morphing geometric shapes
                Transform.rotate(
                  angle: _rotationAnimation.value * 2 * math.pi * 0.25,
                  child: Opacity(
                    opacity: (1 - _logoRevealAnimation.value) * 0.6,
                    child: _buildMorphingShape(
                      logoSize * 1.2,
                      _shapeAnimation.value,
                    ),
                  ),
                ),

                // Second layer of shapes
                Transform.rotate(
                  angle: -_rotationAnimation.value * 2 * math.pi * 0.15,
                  child: Opacity(
                    opacity: (1 - _logoRevealAnimation.value) * 0.4,
                    child: _buildMorphingShape(
                      logoSize * 0.8,
                      _shapeAnimation.value * 0.8,
                    ),
                  ),
                ),

                // Logo reveal
                Opacity(
                  opacity: _logoRevealAnimation.value,
                  child: Transform.scale(
                    scale: 0.5 + (_logoRevealAnimation.value * 0.5),
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

class MorphingShapePainter extends CustomPainter {
  final double sides;
  final double angle;
  final double radius;
  final double progress;

  MorphingShapePainter({
    required this.sides,
    required this.angle,
    required this.radius,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i <= sides.toInt(); i++) {
      final currentAngle = (angle * i) - (math.pi / 2);
      final x = center.dx + radius * math.cos(currentAngle);
      final y = center.dy + radius * math.sin(currentAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MorphingShapePainter oldDelegate) {
    return oldDelegate.sides != sides ||
        oldDelegate.radius != radius ||
        oldDelegate.progress != progress;
  }
}









