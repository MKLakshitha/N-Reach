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
    apiKey: 'AIzaSyBSNo1GecwTcDZajCdi0cE6hB-zVZaoodQ',
    appId: '1:458064021210:web:aa586ad4f123d6dec507e3',
    messagingSenderId: '458064021210',
    projectId: 'nreach-b8dee',
    authDomain: 'nreach-b8dee.firebaseapp.com',
    storageBucket: 'nreach-b8dee.appspot.com',
    measurementId: 'G-0Q00MSC3XJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcc8PHB3VnJrZH0_Mqdckf4mhUbYbCNq0',
    appId: '1:458064021210:android:1beac97164e62ed0c507e3',
    messagingSenderId: '458064021210',
    projectId: 'nreach-b8dee',
    storageBucket: 'nreach-b8dee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDt8YDXSOJOtbzWb3XT97SNksJwvjq1WPQ',
    appId: '1:458064021210:ios:0bfd36d6fdc625cdc507e3',
    messagingSenderId: '458064021210',
    projectId: 'nreach-b8dee',
    storageBucket: 'nreach-b8dee.appspot.com',
    androidClientId: '458064021210-iiavfm7h9jrgtsilspp06d2ks1mn1qrg.apps.googleusercontent.com',
    iosClientId: '458064021210-qt8sn5tv81m7embafkc61qei43gtripp.apps.googleusercontent.com',
    iosBundleId: 'com.example.nReachNsbm',
  );
}
