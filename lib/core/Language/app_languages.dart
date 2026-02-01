import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Utilities/shared_preferences.dart';
import '../../Utilities/refresh_helper.dart';

enum Languages {en,ar}

Languages appLanguage(BuildContext context) => Provider.of<AppLanguage>(context, listen: false).appLang;

class AppLanguage extends ChangeNotifier {
  static const Languages defaultLanguage = Languages.en;

  Languages _appLanguage = defaultLanguage;
  bool _isInitialized = false;

  Languages get appLang => _appLanguage;

  Future fetchLocale() async {
    // Only fetch once to avoid resetting language
    if (_isInitialized) return;
    
    if (SharedPref.getLanguage() == null){
      if(!kDebugMode){
        final List<String> systemLocales = WidgetsBinding.instance.platformDispatcher.locales.map((e) => e.languageCode).toList();
        _appLanguage = Languages.values.firstWhere((lang) => systemLocales.contains(lang.name));
      }else{
        _appLanguage = defaultLanguage;
      }
    }else{
      final saved = SharedPref.getLanguage();
      if (saved == 'ar') {
        _appLanguage = Languages.ar;
      } else if (saved == 'en') {
        _appLanguage = Languages.en;
      } else {
        _appLanguage = defaultLanguage;
      }
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future changeLanguage({Languages? language}) async {
    if(language == _appLanguage) return;
    switch(language){
      case Languages.en:
        _appLanguage = Languages.en;
        break;
      case Languages.ar:
        _appLanguage = Languages.ar;
        break;
      case null:
        _appLanguage = _appLanguage == Languages.ar?  Languages.en : Languages.ar;
        break;
    }
    await SharedPref.setLanguage(lang: _appLanguage.name);
    notifyListeners();
    if (kIsWeb) {
      // Give storage time to persist (e.g. IndexedDB/localStorage) before reload
      await Future<void>.delayed(const Duration(milliseconds: 250));
      refreshApp();
    }
  }
}


