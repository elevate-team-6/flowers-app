import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

// ignore: uri_does_not_exist
import '../../firebase_options.dart';

class FirebaseService {
  static Future<void> init() async {
    // Initialize Firebase
    await Firebase.initializeApp(
      // ignore: undefined_identifier
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Crashlytics - Flutter errors
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      originalOnError?.call(details);
    };

    // Crashlytics - Dart async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
