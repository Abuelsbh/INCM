import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app_languages.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Future<bool> load() async {
    String jsonString;
    try {
      if (locale.languageCode == 'ar') {
        jsonString = await rootBundle.loadString('i18n/ar.json');
      } else {
        jsonString = await rootBundle.loadString('i18n/en.json');
      }
      _localizedStrings = json.decode(jsonString) as Map<String, dynamic>;
      return true;
    } catch (e) {
      // Fallback to English if loading fails
      try {
        jsonString = await rootBundle.loadString('i18n/en.json');
        _localizedStrings = json.decode(jsonString) as Map<String, dynamic>;
        return true;
      } catch (e2) {
        _localizedStrings = {};
        return false;
      }
    }
  }

  String translate(String key) {
    return _localizedStrings[key]?.toString() ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}

extension StringExtension on String {
  String tr([BuildContext? context]) {
    if (context != null) {
      final localizations = AppLocalizations.of(context);
      if (localizations != null) {
        return localizations.translate(this);
      }
      // Fallback: try to get from AppLanguage provider
      try {
        final appLang = Provider.of<AppLanguage>(context, listen: false);
        final locale = Locale(appLang.appLang.name);
        final loc = AppLocalizations(locale);
        // This won't work synchronously, so return key as fallback
        return this;
      } catch (e) {
        return this;
      }
    }
    // If no context provided, try to get from global navigator context
    try {
      final navigatorContext = WidgetsBinding.instance.rootElement;
      if (navigatorContext != null) {
        final localizations = AppLocalizations.of(navigatorContext);
        if (localizations != null) {
          return localizations.translate(this);
        }
      }
    } catch (e) {
      // Fallback: return key
    }
    return this;
  }
}

