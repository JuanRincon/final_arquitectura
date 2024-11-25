import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
    apiKey: 'AIzaSyAhqyP_tXsl_NjLuqs7hKAUk8oAcZ1DWNY',
    appId: '1:276813313432:web:62a4e96ec3833d282c67ed',
    messagingSenderId: '276813313432',
    projectId: 'aplicacionesmov-fba2f',
    authDomain: 'aplicacionesmov-fba2f.firebaseapp.com',
    storageBucket: 'aplicacionesmov-fba2f.firebasestorage.app',
    measurementId: 'G-NLKL8Y3C47',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtDd0zaq4UUqjrNKA1ZE1Z_gxN2BBymfw',
    appId: '1:276813313432:android:5a69f7b2141a5b742c67ed',
    messagingSenderId: '276813313432',
    projectId: 'aplicacionesmov-fba2f',
    storageBucket: 'aplicacionesmov-fba2f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAX6tYpgdIuBixM2VYGrQx4UUUDfZK9vxE',
    appId: '1:276813313432:ios:3f29061b19a925162c67ed',
    messagingSenderId: '276813313432',
    projectId: 'aplicacionesmov-fba2f',
    storageBucket: 'aplicacionesmov-fba2f.firebasestorage.app',
    iosBundleId: 'com.example.modernlogintute',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAX6tYpgdIuBixM2VYGrQx4UUUDfZK9vxE',
    appId: '1:276813313432:ios:3f29061b19a925162c67ed',
    messagingSenderId: '276813313432',
    projectId: 'aplicacionesmov-fba2f',
    storageBucket: 'aplicacionesmov-fba2f.firebasestorage.app',
    iosBundleId: 'com.example.modernlogintute',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAhqyP_tXsl_NjLuqs7hKAUk8oAcZ1DWNY',
    appId: '1:276813313432:web:f5c10ae5be07644a2c67ed',
    messagingSenderId: '276813313432',
    projectId: 'aplicacionesmov-fba2f',
    authDomain: 'aplicacionesmov-fba2f.firebaseapp.com',
    storageBucket: 'aplicacionesmov-fba2f.firebasestorage.app',
    measurementId: 'G-N5E6KVKW4M',
  );

}