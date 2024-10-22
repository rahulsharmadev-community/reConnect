// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
      apiKey: 'AIzaSyCFGG7EorumibMo8zH0Ur7Zms5_T_5JPXo',
      appId: '1:556878679351:web:6a3d21d1adbb5b96485eb2',
      messagingSenderId: '556878679351',
      projectId: 're--connect',
      authDomain: 're--connect.firebaseapp.com',
      storageBucket: 're--connect.appspot.com',
      measurementId: 'G-QFZNWRFSS4',
      databaseURL:
          'https://re--connect-default-rtdb.asia-southeast1.firebasedatabase.app"');

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: 'AIzaSyAbs-9aqwbw7vHdF8y-aZs6zBtRRRHvmcs',
      appId: '1:556878679351:android:de1800453c568cc6485eb2',
      messagingSenderId: '556878679351',
      projectId: 're--connect',
      storageBucket: 're--connect.appspot.com',
      databaseURL:
          'https://re--connect-default-rtdb.asia-southeast1.firebasedatabase.app"');
}
