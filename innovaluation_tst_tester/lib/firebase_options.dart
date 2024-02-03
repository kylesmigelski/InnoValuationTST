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
    apiKey: 'AIzaSyBT1xY-kEoE1w_SJjqXb1G-zXGFN9a0tCg',
    appId: '1:847719342986:web:cf5844af9e875bf6319e73',
    messagingSenderId: '847719342986',
    projectId: 'innovaluation-tst',
    authDomain: 'innovaluation-tst.firebaseapp.com',
    storageBucket: 'innovaluation-tst.appspot.com',
    measurementId: 'G-0ERTB19FPG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC4WjQhse6n56kAvCpxAx4byNh6HxRw5iE',
    appId: '1:847719342986:android:811b12af797862f7319e73',
    messagingSenderId: '847719342986',
    projectId: 'innovaluation-tst',
    storageBucket: 'innovaluation-tst.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZZ8rb8sPhJ5GHJbfFNdt2vwGX-rJSkYc',
    appId: '1:847719342986:ios:b47f1bacfe70b049319e73',
    messagingSenderId: '847719342986',
    projectId: 'innovaluation-tst',
    storageBucket: 'innovaluation-tst.appspot.com',
    iosBundleId: 'com.example.innovaluationTstTester',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZZ8rb8sPhJ5GHJbfFNdt2vwGX-rJSkYc',
    appId: '1:847719342986:ios:abe42d23dd6ad941319e73',
    messagingSenderId: '847719342986',
    projectId: 'innovaluation-tst',
    storageBucket: 'innovaluation-tst.appspot.com',
    iosBundleId: 'com.example.innovaluationTstTester.RunnerTests',
  );
}
