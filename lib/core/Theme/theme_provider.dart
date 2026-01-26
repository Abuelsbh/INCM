import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Utilities/shared_preferences.dart';
import 'theme_model.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeModel _theme = const ThemeModel(
    backGroundColor: Colors.white,
    textColor: Colors.black,
    primaryColor: Color(0xFFC63424),
    secondaryColor: Color(0xFFF4ED47),
  );

  ThemeModel get appTheme => _theme;
  
  ThemeData get appThemeMode => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _theme.primaryColor,
      brightness: Brightness.light,
    ),
  );

  Future<void> fetchTheme() async {
    final savedTheme = SharedPref.getTheme();
    if (savedTheme != null) {
      // Apply saved theme if needed
      // Only notify if theme actually changed
    }
    // Don't notify listeners if nothing changed - this prevents unnecessary rebuilds
  }

  Future<void> setTheme(ThemeModel theme) async {
    _theme = theme;
    await SharedPref.setTheme(theme: 'light'); // Simplified
    notifyListeners();
  }
}

