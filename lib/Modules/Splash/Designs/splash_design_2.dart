import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../generated/assets.dart';
import '../../Home/home_screen.dart';

/// Design 2: Static logo - same design as Design 1 but without animation
class SplashDesign2 extends StatefulWidget {
  const SplashDesign2({super.key});

  @override
  State<SplashDesign2> createState() => _SplashDesign2State();
}

class _SplashDesign2State extends State<SplashDesign2> {
  @override
  void initState() {
    super.initState();
    
    // Navigate to home after a delay
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        GoRouter.of(context).go(HomeScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double logoSize = MediaQuery.of(context).size.width < 600 ? 300.r : 800.r;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4ED47), // Yellow background
      body: Center(
        child: Image.asset(
          Assets.logosINCMLogo,
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}









