import 'package:flutter/material.dart';
import 'Designs/splash_design_1.dart';
import 'splash_session.dart';

class IncmAnimatedSplash extends StatelessWidget {
  const IncmAnimatedSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashDesign1(
      showTypewriter: SplashSession.showFullLogoAnimation,
    );
  }
}


