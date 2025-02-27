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
    apiKey: 'AIzaSyB021-dRcMC11tjvt7CfTvJGfhNzzPz9oY',
    appId: '1:338549823098:web:ffd186aaf735d6d7ba0dc3',
    messagingSenderId: '338549823098',
    projectId: 'quizzy-app-9405a',
    authDomain: 'quizzy-app-9405a.firebaseapp.com',
    storageBucket: 'quizzy-app-9405a.firebasestorage.app',
    measurementId: 'G-EG9XT0ZLYJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVoOYjwWm6ttmt8v3jvSvhpWSXtCfJ-F0',
    appId: '1:338549823098:android:b9225325b2ae9e9eba0dc3',
    messagingSenderId: '338549823098',
    projectId: 'quizzy-app-9405a',
    storageBucket: 'quizzy-app-9405a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAdgtNYs9GoY4Zm1PpP1FrSmpXZV1kdiWM',
    appId: '1:338549823098:ios:35909569385efb68ba0dc3',
    messagingSenderId: '338549823098',
    projectId: 'quizzy-app-9405a',
    storageBucket: 'quizzy-app-9405a.firebasestorage.app',
    iosBundleId: 'com.example.quizzy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAdgtNYs9GoY4Zm1PpP1FrSmpXZV1kdiWM',
    appId: '1:338549823098:ios:35909569385efb68ba0dc3',
    messagingSenderId: '338549823098',
    projectId: 'quizzy-app-9405a',
    storageBucket: 'quizzy-app-9405a.firebasestorage.app',
    iosBundleId: 'com.example.quizzy',
  );
}
