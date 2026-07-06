import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../../core/utils/app_constants.dart';
import '../../core/utils/app_keys.dart';
// ignore: uri_does_not_exist
import '../../firebase_options.dart';
import '../cache/secure_cache_helper.dart';
import '../di/di.dart';

@singleton
class FirebaseService {
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;

  FirebaseService(this._firestore, this._messaging);

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  static Future<void> initFirebase() async {
    await Firebase.initializeApp(
      // ignore: undefined_identifier
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> init() async {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      originalOnError?.call(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    await _initLocalNotifications();
    await _initNotificationListeners();
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  Future<void> _initNotificationListeners() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _messaging.onTokenRefresh.listen((newToken) async {
      final userId = await getIt<SecureCacheHelper>().readData(
        key: AppKeys.userIdKey,
      );
      if (userId != null) {
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .update({AppConstants.fcmTokenField: newToken});
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //todo: Navigate to the tracking screen with order id form message data
    });
  }

  void _showForegroundNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: _channel.importance,
            priority: Priority.high,
            icon: android.smallIcon,
          ),
        ),
      );
    }
  }

  Future<void> updateUserLanguage(String languageCode) async {
    final userId = await getIt<SecureCacheHelper>().readData(
      key: AppKeys.userIdKey,
    );

    if (userId != null) {
      try {
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .update({AppConstants.languageField: languageCode});
        log("Firestore: Language updated to $languageCode");
      } catch (e) {
        log("Error updating Firestore language: $e");
      }
    }
  }
}
