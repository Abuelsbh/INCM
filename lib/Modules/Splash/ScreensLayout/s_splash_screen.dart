import 'package:flutter/material.dart';
import '../splash_controller.dart';
import '../incm_animated_splash.dart';

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
    loadDataAndNavigate(context, widget.targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    return const IncmAnimatedSplash();
  }
}
