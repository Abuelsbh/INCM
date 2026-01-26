import 'package:flutter/material.dart';
import '../core/Language/app_languages.dart';
import 'package:provider/provider.dart';

/// Helper function to get the appropriate font based on the current language
/// 
/// Mapping:
/// - OptimalBold (English) → NotoKufiArabicSemiBold (Arabic)
/// - AloeveraDisplaySemiBold (English) → NotoKufiArabicBold (Arabic)
/// 
/// For any other font, returns the original font name
String getLocalizedFont(BuildContext context, String englishFont) {
  final appLang = Provider.of<AppLanguage>(context, listen: false);
  final isArabic = appLang.appLang == Languages.ar;
  
  if (!isArabic) {
    return englishFont;
  }
  
  // Map English fonts to Arabic fonts
  switch (englishFont) {
    case 'OptimalBold':
      return 'NotoKufiArabicSemiBold';
    case 'AloeveraDisplaySemiBold':
      return 'NotoKufiArabicBold';
    default:
      return englishFont;
  }
}
