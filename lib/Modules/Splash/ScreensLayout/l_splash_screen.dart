import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:state_extended/state_extended.dart';
import '../splash_controller.dart';
import '../incm_animated_splash.dart';

class LargeSplashScreen extends StatefulWidget {
  const LargeSplashScreen({super.key});

  @override
  State createState() => _LargeSplashScreenState();
}

class _LargeSplashScreenState extends StateX<LargeSplashScreen> {
  _LargeSplashScreenState() : super(controller: SplashController()) {
    con = SplashController();
  }

  late SplashController con;


  @override
  void initState() {
    con.init(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const IncmAnimatedSplash();
  }
}