import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Utilities/shared_preferences.dart';

class FontProvider extends ChangeNotifier {
  String _fontFamily = 'Optimal';

  String get fontFamily => _fontFamily;

  Future<void> fetchFont() async {
    final savedFont = SharedPref.getFont();
    if (savedFont != null) {
      _fontFamily = savedFont;
    }
    notifyListeners();
  }

  Future<void> setFont(String fontFamily) async {
    if (_fontFamily == fontFamily) return;
    _fontFamily = fontFamily;
    await SharedPref.setFont(font: fontFamily);
    notifyListeners();
  }
}

