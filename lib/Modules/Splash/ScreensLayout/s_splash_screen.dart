import 'package:flutter/material.dart';
import '../incm_animated_splash.dart';
import '../splash_controller.dart';
import '../splash_session.dart';

class SmallSplashScreen extends StatefulWidget {
  final String targetRoute;

  const SmallSplashScreen({super.key, required this.targetRoute});

  @override
  State<SmallSplashScreen> createState() => _SmallSplashScreenState();
}

class _SmallSplashScreenState extends State<SmallSplashScreen> {
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
