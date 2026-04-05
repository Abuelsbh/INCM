import 'package:flutter/material.dart';
import '../incm_animated_splash.dart';
import '../splash_controller.dart';
import '../splash_session.dart';

class MediumSplashScreen extends StatefulWidget {
  final String targetRoute;

  const MediumSplashScreen({super.key, required this.targetRoute});

  @override
  State<MediumSplashScreen> createState() => _MediumSplashScreenState();
}

class _MediumSplashScreenState extends State<MediumSplashScreen> {
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