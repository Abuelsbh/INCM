import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:state_extended/state_extended.dart';
import '../splash_controller.dart';
import '../incm_animated_splash.dart';

class MediumSplashScreen extends StatefulWidget {
  const MediumSplashScreen({super.key});

  @override
  State createState() => _MediumSplashScreenState();
}

class _MediumSplashScreenState extends StateX<MediumSplashScreen> {
  _MediumSplashScreenState() : super(controller: SplashController()) {
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