// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyDCaLbrYnFHHe3X1bVOZHzavBt4C2pKLp8',
    appId: '1:611997606478:web:ce0e60106365787e98991f',
    messagingSenderId: '611997606478',
    projectId: 'let-me-check-42d8a',
    authDomain: 'let-me-check-42d8a.firebaseapp.com',
    storageBucket: 'let-me-check-42d8a.appspot.com',
    measurementId: 'G-D69289XW0X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSdcgoF062zqpjGydcsCtJm-NgLxuapDk',
    appId: '1:611997606478:android:5b182841390be87198991f',
    messagingSenderId: '611997606478',
    projectId: 'let-me-check-42d8a',
    storageBucket: 'let-me-check-42d8a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7CMXUG69bxFnNIv7BttH7I4r_fLYZnjI',
    appId: '1:611997606478:ios:629bcf1958603dbc98991f',
    messagingSenderId: '611997606478',
    projectId: 'let-me-check-42d8a',
    storageBucket: 'let-me-check-42d8a.appspot.com',
    iosClientId: '611997606478-fqhv7qr3hs4e7jkm48iqq7ag58rgv8pf.apps.googleusercontent.com',
    iosBundleId: 'com.example.letMeCheck',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA7CMXUG69bxFnNIv7BttH7I4r_fLYZnjI',
    appId: '1:611997606478:ios:629bcf1958603dbc98991f',
    messagingSenderId: '611997606478',
    projectId: 'let-me-check-42d8a',
    storageBucket: 'let-me-check-42d8a.appspot.com',
    iosClientId: '611997606478-fqhv7qr3hs4e7jkm48iqq7ag58rgv8pf.apps.googleusercontent.com',
    iosBundleId: 'com.example.letMeCheck',
  );
}
