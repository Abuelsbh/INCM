import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/content_model.dart';
import '../core/Language/app_languages.dart';
import '../core/Language/locales.dart';

/// Firebase section IDs for the home performance highlights block (editable from admin).
abstract final class PerformanceHighlightsSectionIds {
  static String valueId(int i) => 'performance-highlight-$i-value';
  static String descriptionId(int i) => 'performance-highlight-$i-description';
}

/// Default metric display strings (when no Firebase content).
const performanceHighlightDefaultValues = <String>[
  '+84,321',
  '+32',
  '+100',
  '+45',
];

/// i18n keys for default descriptions (when no Firebase content).
const performanceHighlightDefaultDescKeys = <String>[
  'SQM_RETAIL_SPACE_LEASED',
  'ASSETS_FACILITY_MANAGEMENT',
  'FRANCHISE_AGREEMENTS_ESTABLISHED',
  'REAL_ESTATE_CONSULTING_COMPLETED',
];

String _textForSection(
  List<ContentModel> list,
  String sectionId,
  String language,
) {
  for (final c in list) {
    if (c.sectionId == sectionId && c.type == ContentType.text) {
      final v = c.values[language]?.trim();
      if (v != null && v.isNotEmpty) return v;
      final en = c.values['en']?.trim();
      if (en != null && en.isNotEmpty) return en;
      final ar = c.values['ar']?.trim();
      if (ar != null && ar.isNotEmpty) return ar;
      return '';
    }
  }
  return '';
}

/// Resolves the four value strings and four description strings for the UI.
List<(String value, String description)> resolvePerformanceHighlightMetrics(
  BuildContext context,
  List<ContentModel> homeContent,
) {
  final lang = Provider.of<AppLanguage>(context, listen: false).appLang.name;
  final out = <(String, String)>[];
  for (var i = 0; i < 4; i++) {
    final index = i + 1;
    final rawVal = _textForSection(
      homeContent,
      PerformanceHighlightsSectionIds.valueId(index),
      lang,
    );
    final rawDesc = _textForSection(
      homeContent,
      PerformanceHighlightsSectionIds.descriptionId(index),
      lang,
    );
    final defVal = performanceHighlightDefaultValues[i];
    final defKey = performanceHighlightDefaultDescKeys[i];
    final value = rawVal.trim().isEmpty ? defVal : rawVal.trim();
    final description = rawDesc.trim().isEmpty ? defKey.tr(context) : rawDesc.trim();
    out.add((value, description));
  }
  return out;
}
