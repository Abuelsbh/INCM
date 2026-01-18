import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:incm/Modules/Home/home_screen.dart';
import 'package:state_extended/state_extended.dart';
import '../../Utilities/router_config.dart';

class SplashController extends StateXController {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void init(BuildContext context) {
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    //GoRouterConfig.router.go(HomeScreen.routeName);
  }
}

