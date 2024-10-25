// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBX7yLiK3GtlWojY8Jnp33ZD4VpGORNFrk',
    appId: '1:902763583392:web:f4e78befe54b43dd6c36c5',
    messagingSenderId: '902763583392',
    projectId: 'internir',
    authDomain: 'internir.firebaseapp.com',
    storageBucket: 'internir.appspot.com',
    measurementId: 'G-MYHWYL55CE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD11FOH0lmp6wwpWXk8cQIyKmNniBa5pp0',
    appId: '1:902763583392:android:67104c86c1167e646c36c5',
    messagingSenderId: '902763583392',
    projectId: 'internir',
    storageBucket: 'internir.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAI6KfjR6iJ-15v3mf0yO9ZAor3ZImMn1g',
    appId: '1:902763583392:ios:6bcb30c301cfc2986c36c5',
    messagingSenderId: '902763583392',
    projectId: 'internir',
    storageBucket: 'internir.appspot.com',
    iosBundleId: 'com.example.internir',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAI6KfjR6iJ-15v3mf0yO9ZAor3ZImMn1g',
    appId: '1:902763583392:ios:6bcb30c301cfc2986c36c5',
    messagingSenderId: '902763583392',
    projectId: 'internir',
    storageBucket: 'internir.appspot.com',
    iosBundleId: 'com.example.internir',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBX7yLiK3GtlWojY8Jnp33ZD4VpGORNFrk',
    appId: '1:902763583392:web:f2180c72915255316c36c5',
    messagingSenderId: '902763583392',
    projectId: 'internir',
    authDomain: 'internir.firebaseapp.com',
    storageBucket: 'internir.appspot.com',
    measurementId: 'G-C89E1GKYJM',
  );

}