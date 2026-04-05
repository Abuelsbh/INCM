/// Compile-time / boot-time configuration for user vs admin app builds.
class AppBuildConfig {
  AppBuildConfig._();

  static bool _isAdminApp = false;

  /// True when running the admin entrypoint ([main_admin.dart]).
  static bool get isAdminApp => _isAdminApp;

  static void init({required bool adminApp}) {
    _isAdminApp = adminApp;
  }
}
