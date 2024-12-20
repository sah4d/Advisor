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
    apiKey: 'AIzaSyDVkuWMuen73r9KA3juIW-YXnFQGugJQlw',
    appId: '1:799016554740:web:4a2569ff8a922052074ea1',
    messagingSenderId: '799016554740',
    projectId: 'billboard-15d1d',
    authDomain: 'billboard-15d1d.firebaseapp.com',
    databaseURL: 'https://billboard-15d1d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'billboard-15d1d.appspot.com',
    measurementId: 'G-KB77MCTSYV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQQ1Az1vMPdAiirhuiTMbv3wWeXHLOx44',
    appId: '1:799016554740:android:25751a18c845398e074ea1',
    messagingSenderId: '799016554740',
    projectId: 'billboard-15d1d',
    databaseURL: 'https://billboard-15d1d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'billboard-15d1d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuIZ8a498MD2jupQ9p3M7inv0-LmEhcIA',
    appId: '1:799016554740:ios:9bbe08fe16313917074ea1',
    messagingSenderId: '799016554740',
    projectId: 'billboard-15d1d',
    databaseURL: 'https://billboard-15d1d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'billboard-15d1d.appspot.com',
    iosBundleId: 'com.example.advertisement',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuIZ8a498MD2jupQ9p3M7inv0-LmEhcIA',
    appId: '1:799016554740:ios:9bbe08fe16313917074ea1',
    messagingSenderId: '799016554740',
    projectId: 'billboard-15d1d',
    databaseURL: 'https://billboard-15d1d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'billboard-15d1d.appspot.com',
    iosBundleId: 'com.example.advertisement',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDVkuWMuen73r9KA3juIW-YXnFQGugJQlw',
    appId: '1:799016554740:web:36ca87d3dc37d73e074ea1',
    messagingSenderId: '799016554740',
    projectId: 'billboard-15d1d',
    authDomain: 'billboard-15d1d.firebaseapp.com',
    databaseURL: 'https://billboard-15d1d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'billboard-15d1d.appspot.com',
    measurementId: 'G-KRG8N65169',
  );
}
