import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'Designs/splash_design_1.dart';
import 'Designs/splash_design_2.dart';
import 'Designs/splash_design_3.dart';
import 'Designs/splash_design_4.dart';

class IncmAnimatedSplash extends StatefulWidget {
  const IncmAnimatedSplash({super.key});

  @override
  State<IncmAnimatedSplash> createState() => _IncmAnimatedSplashState();
}

class _IncmAnimatedSplashState extends State<IncmAnimatedSplash> {
  late final int _selectedDesign;

  @override
  void initState() {
    super.initState();
    // Randomly select one of the 4 designs
    _selectedDesign = 1;
  }

  @override
  Widget build(BuildContext context) {
    return const SplashDesign1();
  }
}


