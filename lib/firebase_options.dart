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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBI6NFPB6cR_0vu1WrGP6kTC4V7cl5y4kg',
    appId: '1:166132457414:web:f2ea41de6bfb69feb4dcc7',
    messagingSenderId: '166132457414',
    projectId: 'taskit-d116d',
    authDomain: 'taskit-d116d.firebaseapp.com',
    storageBucket: 'taskit-d116d.firebasestorage.app',
    measurementId: 'G-6MQ170S5H8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGz8BCeNhWLJngqeq8B-xI2wCtQQNkGBs',
    appId: '1:166132457414:android:b0e2d8b323546df3b4dcc7',
    messagingSenderId: '166132457414',
    projectId: 'taskit-d116d',
    storageBucket: 'taskit-d116d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDo_n8OxtvV9zBqe4zgdnSTHkKWcrPpQtc',
    appId: '1:166132457414:ios:91a7ec60beea6eb1b4dcc7',
    messagingSenderId: '166132457414',
    projectId: 'taskit-d116d',
    storageBucket: 'taskit-d116d.firebasestorage.app',
    androidClientId: '166132457414-0ehlfkgpj0t0v3do6cq56gqk2n30thsg.apps.googleusercontent.com',
    iosClientId: '166132457414-at8lq4k2eam3koilbuu1q5savajanu4q.apps.googleusercontent.com',
    iosBundleId: 'com.rolladay.taskit.taskit',
  );

}