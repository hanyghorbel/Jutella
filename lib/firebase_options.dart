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
    apiKey: 'AIzaSyCgTNVWsnUXuzdDRYOELJDZSB2Lv7KVcik',
    appId: '1:725789420551:web:e0983640b1f5d247bb0ea2',
    messagingSenderId: '725789420551',
    projectId: 'jutella-d4f87',
    authDomain: 'jutella-d4f87.firebaseapp.com',
    storageBucket: 'jutella-d4f87.appspot.com',
    measurementId: 'G-VX2J4VFZ71',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvgg1VxnhtcigVVZbfQ5d6mAa_tlFo2Hk',
    appId: '1:725789420551:android:b8c6170065f61ad8bb0ea2',
    messagingSenderId: '725789420551',
    projectId: 'jutella-d4f87',
    storageBucket: 'jutella-d4f87.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBTFZLaq8g_S46bqG4VGaZsjxbvC4YJ8vU',
    appId: '1:725789420551:ios:9329d948c1d00c15bb0ea2',
    messagingSenderId: '725789420551',
    projectId: 'jutella-d4f87',
    storageBucket: 'jutella-d4f87.appspot.com',
    iosClientId: '725789420551-ekaj9omnqt03rqki82dlk6dng75ls15a.apps.googleusercontent.com',
    iosBundleId: 'com.example.whproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBTFZLaq8g_S46bqG4VGaZsjxbvC4YJ8vU',
    appId: '1:725789420551:ios:9329d948c1d00c15bb0ea2',
    messagingSenderId: '725789420551',
    projectId: 'jutella-d4f87',
    storageBucket: 'jutella-d4f87.appspot.com',
    iosClientId: '725789420551-ekaj9omnqt03rqki82dlk6dng75ls15a.apps.googleusercontent.com',
    iosBundleId: 'com.example.whproject',
  );
}
