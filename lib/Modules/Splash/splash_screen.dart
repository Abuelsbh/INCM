import 'package:rush/responsive/responsive_layout.dart';

import 'ScreensLayout/l_splash_screen.dart';
import 'ScreensLayout/m_splash_screen.dart';
import 'ScreensLayout/s_splash_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = "/splash";

  /// Target route to navigate after data is loaded (e.g. /about).
  /// If null, defaults to home (/).
  final String? targetRoute;

  const SplashScreen({super.key, this.targetRoute});

  @override
  Widget build(BuildContext context) {
    final target = targetRoute ?? '/';
    return RushWidget(
      smallScreen: SmallSplashScreen(targetRoute: target),
      mediumScreen: MediumSplashScreen(targetRoute: target),
      largeScreen: LargeSplashScreen(targetRoute: target),
    );
  }
}