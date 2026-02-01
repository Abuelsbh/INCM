import 'refresh_helper_stub.dart' if (dart.library.html) 'refresh_helper_web.dart' as impl;

/// Reloads the app. On web, performs a full page reload; on other platforms, no-op.
void refreshApp() => impl.refreshApp();
