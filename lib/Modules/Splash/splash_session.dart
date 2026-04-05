import 'dart:async';

/// First splash in an app session runs the full logo reveal; later splashes
/// (e.g. when loading uncached pages) show the logo immediately.
class SplashSession {
  SplashSession._();

  static bool _hasCompletedFirstSplashThisSession = false;
  static Completer<void>? _animationDone;

  /// Whether this session's first splash should use the typewriter animation.
  static bool get showFullLogoAnimation => !_hasCompletedFirstSplashThisSession;

  /// Call from splash screen [State.initState] before [loadDataAndNavigate].
  static void beginSplashFrame() {
    if (showFullLogoAnimation) {
      _animationDone = Completer<void>();
    } else {
      _animationDone = Completer<void>()..complete();
    }
  }

  /// Await alongside Firebase load so the first splash stays until both finish.
  static Future<void> get animationEnded =>
      _animationDone?.future ?? Future.value();

  /// Called from splash design when the typewriter animation finishes.
  static void completeAnimation() {
    final c = _animationDone;
    if (c != null && !c.isCompleted) {
      c.complete();
    }
  }

  /// Call after navigating away from the first splash.
  static void markFirstSplashDone() {
    _hasCompletedFirstSplashThisSession = true;
  }
}
