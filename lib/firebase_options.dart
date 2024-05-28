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
    apiKey: 'AIzaSyCq0d8jDNo3_C4vh7dgscQTtMc0nXRn_Zc',
    appId: '1:279501634796:web:775020527b10d6118679c9',
    messagingSenderId: '279501634796',
    projectId: 'tobeto-clone-app',
    authDomain: 'tobeto-clone-app.firebaseapp.com',
    storageBucket: 'tobeto-clone-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBeIvuUhq7p7MuonzyNjFcjtjEyC4ctM0g',
    appId: '1:279501634796:android:8faa1176131e7ef88679c9',
    messagingSenderId: '279501634796',
    projectId: 'tobeto-clone-app',
    storageBucket: 'tobeto-clone-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9BL8mi_qp72A4mGBvP-T9pI49MTdqojE',
    appId: '1:279501634796:ios:da79d3a80805c8698679c9',
    messagingSenderId: '279501634796',
    projectId: 'tobeto-clone-app',
    storageBucket: 'tobeto-clone-app.appspot.com',
    iosBundleId: 'com.example.tobetoapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA9BL8mi_qp72A4mGBvP-T9pI49MTdqojE',
    appId: '1:279501634796:ios:da79d3a80805c8698679c9',
    messagingSenderId: '279501634796',
    projectId: 'tobeto-clone-app',
    storageBucket: 'tobeto-clone-app.appspot.com',
    iosBundleId: 'com.example.tobetoapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCq0d8jDNo3_C4vh7dgscQTtMc0nXRn_Zc',
    appId: '1:279501634796:web:9a36a43cb1a3dcbe8679c9',
    messagingSenderId: '279501634796',
    projectId: 'tobeto-clone-app',
    authDomain: 'tobeto-clone-app.firebaseapp.com',
    storageBucket: 'tobeto-clone-app.appspot.com',
  );
}
