import 'package:flutter/material.dart';
import '../incm_animated_splash.dart';
import '../splash_controller.dart';
import '../splash_session.dart';

class LargeSplashScreen extends StatefulWidget {
  final String targetRoute;

  const LargeSplashScreen({super.key, required this.targetRoute});

  @override
  State<LargeSplashScreen> createState() => _LargeSplashScreenState();
}

class _LargeSplashScreenState extends State<LargeSplashScreen> {
  @override
  void initState() {
    super.initState();
    SplashSession.beginSplashFrame();
    loadDataAndNavigate(context, widget.targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    return const IncmAnimatedSplash();
  }
}