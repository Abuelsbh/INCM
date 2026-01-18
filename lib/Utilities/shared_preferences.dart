import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Language
  static String? getLanguage() => _prefs?.getString('language');
  static Future<bool> setLanguage({required String lang}) async {
    return await _prefs?.setString('language', lang) ?? false;
  }

  // Font
  static String? getFont() => _prefs?.getString('font');
  static Future<bool> setFont({required String font}) async {
    return await _prefs?.setString('font', font) ?? false;
  }

  // Theme
  static String? getTheme() => _prefs?.getString('theme');
  static Future<bool> setTheme({required String theme}) async {
    return await _prefs?.setString('theme', theme) ?? false;
  }

  // Clear all
  static Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }
}

