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
    apiKey: 'AIzaSyDr7QyyO7cM_11QS5hUOc9UMyMizUZm2r8',
    appId: '1:967326719975:web:ed0db728c331480faf2742',
    messagingSenderId: '967326719975',
    projectId: 'inkpal-407c3',
    authDomain: 'inkpal-407c3.firebaseapp.com',
    storageBucket: 'inkpal-407c3.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCeT8PX6Erdtbk4SwmbwlOk4sdQ7XbNCy8',
    appId: '1:967326719975:android:cf374e92fd56ed99af2742',
    messagingSenderId: '967326719975',
    projectId: 'inkpal-407c3',
    storageBucket: 'inkpal-407c3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBmltNl5jSOMOdItnxbQDJ0SDYbGr3DIgw',
    appId: '1:967326719975:ios:5989001502bdc4f8af2742',
    messagingSenderId: '967326719975',
    projectId: 'inkpal-407c3',
    storageBucket: 'inkpal-407c3.firebasestorage.app',
    iosBundleId: 'com.example.inkpalsApp',
  );
}
