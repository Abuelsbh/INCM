import 'package:flutter/foundation.dart';

/// Provider for admin mode - when true, edit overlays appear on sections.
/// Does not affect any user-facing layout.
class AdminModeProvider extends ChangeNotifier {
  bool _isAdminMode = false;

  bool get isAdminMode => _isAdminMode;

  void setAdminMode(bool value) {
    if (_isAdminMode != value) {
      _isAdminMode = value;
      notifyListeners();
    }
  }

  void toggleAdminMode() {
    setAdminMode(!_isAdminMode);
  }

  void exitAdminMode() {
    setAdminMode(false);
  }
}
