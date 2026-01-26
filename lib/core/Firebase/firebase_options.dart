// File generated using Firebase CLI or manually created
// This file contains Firebase configuration for all platforms

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform, kDebugMode;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Check if Web App ID is configured
      if (web.appId.contains('YOUR_WEB_APP_ID')) {
        throw UnsupportedError(
          'Web App ID not configured. Please add a Web App in Firebase Console '
          'and update firebase_options.dart. See FIREBASE_WEB_SETUP.md for details.',
        );
      }
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        if (android.appId.contains('YOUR_ANDROID_APP_ID')) {
          throw UnsupportedError(
            'Android App ID not configured in firebase_options.dart.',
          );
        }
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        if (macos.appId.contains('YOUR_MACOS_APP_ID')) {
          throw UnsupportedError(
            'macOS App ID not configured in firebase_options.dart.',
          );
        }
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyDwK0fqQzb7O5ETz_Yx22QXBKE7HW-JkH4",
      authDomain: "incm-c87aa.firebaseapp.com",
      projectId: "incm-c87aa",
      storageBucket: "incm-c87aa.firebasestorage.app",
      messagingSenderId: "75851289116",
      appId: "1:75851289116:web:822d421f09dc719e2bc5d9",
      measurementId: "G-Z16565ETXD"
  );


  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB-UomzDJ7g02oF_3o_vtWYD5pcbmb924k',
    appId: '1:75851289116:android:c21e5c5500a13a652bc5d9',
    messagingSenderId: '75851289116',
    projectId: 'incm-c87aa',
    storageBucket: 'incm-c87aa.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBDi2glrU-hpSnJ24Ms-7kA5xGIVWQYU10',
    appId: '1:75851289116:ios:5ab863f054c8dfcf2bc5d9',
    messagingSenderId: '75851289116',
    projectId: 'incm-c87aa',
    storageBucket: 'incm-c87aa.firebasestorage.app',
    iosBundleId: 'com.incm.realestate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB-UomzDJ7g02oF_3o_vtWYD5pcbmb924k',
    appId: '1:75851289116:macos:YOUR_MACOS_APP_ID',
    messagingSenderId: '75851289116',
    projectId: 'incm-c87aa',
    storageBucket: 'incm-c87aa.firebasestorage.app',
    iosBundleId: 'com.incm.realestate',
  );
}
