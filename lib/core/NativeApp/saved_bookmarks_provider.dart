import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Content/exclusive_leasing_projects_data.dart';

/// حفظ مشاريع الإيجار الحصرية في الجهاز (مفضّلة) — وظيفة أصلية لمراجعة App Store 4.2
class SavedBookmarksProvider extends ChangeNotifier {
  static const _storageKey = 'saved_exclusive_project_slugs_v1';

  final Set<String> _projectSlugs = {};

  SavedBookmarksProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      _projectSlugs
        ..clear()
        ..addAll(list.cast<String>());
      notifyListeners();
    } catch (_) {}
  }

  bool isProjectSaved(String slug) => _projectSlugs.contains(slug);

  /// ترتيب العرض كما في [ExclusiveLeasingProjectsData.orderedSlugs] ثم أي معرفات إضافية.
  List<String> get orderedSavedSlugs {
    final out = <String>[];
    for (final s in ExclusiveLeasingProjectsData.orderedSlugs) {
      if (_projectSlugs.contains(s)) out.add(s);
    }
    final extra = _projectSlugs.difference(out.toSet()).toList()..sort();
    out.addAll(extra);
    return out;
  }

  int get savedCount => _projectSlugs.length;

  Future<void> toggleProject(String slug) async {
    if (slug.isEmpty) return;
    if (_projectSlugs.contains(slug)) {
      _projectSlugs.remove(slug);
    } else {
      _projectSlugs.add(slug);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final list = _projectSlugs.toList()..sort();
    await prefs.setString(_storageKey, jsonEncode(list));
  }

  Future<void> removeProject(String slug) async {
    if (!_projectSlugs.contains(slug)) return;
    _projectSlugs.remove(slug);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final list = _projectSlugs.toList()..sort();
    await prefs.setString(_storageKey, jsonEncode(list));
  }
}
