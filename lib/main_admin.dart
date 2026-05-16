import 'bootstrap.dart';

/// Admin app entrypoint. The Android `admin` product flavor was removed; the Play
/// Store build is `lib/main.dart` only. Reintroduce Gradle flavors here if you
/// split admin into a separate APK again.
Future<void> main() => bootstrap(adminApp: true);
