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
    apiKey: 'AIzaSyCxEiHQENB9jYJuqJfTRXL7XfIcSFbP0Kk',
    appId: '1:613061731298:web:b0c8ecdf66c976f5960fbb',
    messagingSenderId: '613061731298',
    projectId: 'temulik-2cef4',
    authDomain: 'temulik-2cef4.firebaseapp.com',
    storageBucket: 'temulik-2cef4.appspot.com',
    measurementId: 'G-4WR9CPFBTH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFVzzXjg_I6_fhjJZk1F8cOb3odC06Tmg',
    appId: '1:613061731298:android:467b86caa9173613960fbb',
    messagingSenderId: '613061731298',
    projectId: 'temulik-2cef4',
    storageBucket: 'temulik-2cef4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCosZodiuKlCt7jr2j6a8BWKqSYDIDAUNA',
    appId: '1:613061731298:ios:8a5af1de875001ce960fbb',
    messagingSenderId: '613061731298',
    projectId: 'temulik-2cef4',
    storageBucket: 'temulik-2cef4.appspot.com',
    androidClientId: '613061731298-n7aierm7fh4rt3okufsca2srpcvea8e3.apps.googleusercontent.com',
    iosClientId: '613061731298-ocf12gbdo90k3rqq5ir3k35dsesr7dpj.apps.googleusercontent.com',
    iosBundleId: 'com.example.temulik',
  );
}
