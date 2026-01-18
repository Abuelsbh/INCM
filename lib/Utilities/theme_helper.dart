import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/Theme/theme_model.dart';
import '../core/Theme/theme_provider.dart';

class ThemeClass {
  static ThemeModel of(BuildContext context) {
    try {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      return themeProvider.appTheme;
    } catch (e) {
      // Return default theme if ThemeProvider is not available
      return const ThemeModel(
        backGroundColor: Colors.white,
        textColor: Colors.black,
        primaryColor: Color(0xFFC63424),
        secondaryColor: Color(0xFFF4ED47),
      );
    }
  }
}

