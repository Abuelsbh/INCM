import 'bootstrap.dart';

/// Admin app entrypoint. Use with Android flavor `admin`, e.g.:
/// `flutter run --flavor admin -t lib/main_admin.dart`
///
/// User (store) build:
/// `flutter run --flavor user -t lib/main.dart`
Future<void> main() => bootstrap(adminApp: true);
