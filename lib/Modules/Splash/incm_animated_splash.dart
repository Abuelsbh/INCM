import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../generated/assets.dart';
import '../Home/home_screen.dart';

class IncmAnimatedSplash extends StatefulWidget {
  const IncmAnimatedSplash({super.key});

  @override
  State<IncmAnimatedSplash> createState() => _IncmAnimatedSplashState();
}

class _IncmAnimatedSplashState extends State<IncmAnimatedSplash> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoInOpacity;
  late final Animation<double> _squareScale;
  late final Animation<double> _crossfadeToYellowOnBlack;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));

    _logoInOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.35, curve: Curves.easeOut)),
    );

    _squareScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.35, 0.75, curve: Curves.easeInOutCubic)),
    );

    _crossfadeToYellowOnBlack = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.65, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double logoSize = MediaQuery.of(context).size.width < 600 ? 400.r : 700.r;
    return Scaffold(
      backgroundColor: const Color(0xFFF4ED47),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Expanding black square behind logo
                Transform.scale(
                  scale: _squareScale.value,
                  child: Container(
                    width: logoSize * 0.6,
                    height: logoSize * 0.6,
                    color: const Color(0xFF000000),
                  ),
                ),

                // Phase 1: black logo on yellow bg
                Opacity(
                  opacity: 1 - _crossfadeToYellowOnBlack.value,
                  child: Opacity(
                    opacity: _logoInOpacity.value,
                    child: Image.asset(
                      Assets.iconsSplash1,
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Phase 2: yellow logo inside black square
                Opacity(
                  opacity: _crossfadeToYellowOnBlack.value,
                  child: Image.asset(
                    Assets.iconsSplash2,
                    width: logoSize,
                    height: logoSize,
                    fit: BoxFit.contain,
                  ),
                ),

                // Navigation trigger overlay at the end of the animation timeline
                if (_controller.status == AnimationStatus.completed)
                  FutureBuilder(
                    future: Future<void>.delayed(const Duration(milliseconds: 200), () {
                      if (mounted) {
                        GoRouter.of(context).go(HomeScreen.routeName);
                      }
                    }),
                    builder: (_, __) => const SizedBox.shrink(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}


