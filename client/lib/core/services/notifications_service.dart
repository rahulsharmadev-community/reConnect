import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logs/logs.dart';
import 'package:shared/fcm_service/fcm_service.dart';
import 'package:shared/fcm_service/models/android_config.dart';
import 'package:shared/fcm_service/models/message.dart';
import 'package:shared/fcm_service/models/notification.dart';
import 'package:reConnect/utility/routes/app_router.dart';
import 'package:shared/shared.dart';
import 'package:shared/shared.dart' as shared;
import '../APIs/firebase_api/firebase_api.dart';

/// Top-level function for handling background notifications
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await initializeFirebaseApi();
  var instance = FirebaseNotificationService.instance;
  await instance.initializeFlutterNotificationSettings();
  instance.showFlutterNotification(message);
  logs.config('Handling a background message ${message.messageId}');
}

class FirebaseNotificationService {
  final FlutterLocalNotificationsPlugin flutterNotifications;
  final FirebaseMessaging firebaseMessaging;
  FirebaseNotificationService._()
      : flutterNotifications = FlutterLocalNotificationsPlugin(),
        firebaseMessaging = FirebaseMessaging.instance {
    firebaseMessaging.onTokenRefresh.listen((token) {
      _firebaseMessagingToken = token;
      logs.config(token, 'From: onTokenRefresh');
    });
    FirebaseMessaging.onMessage.listen((message) {
      logs.config(message.toMap(), 'From: onMessage');
      instance.showFlutterNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      logs.config(message.toMap(), 'From: onMessageOpenedApp');
      AppNavigator.on((router) {
        router.goNamed(AppRoutes.ChatScreen.name,
            pathParameters: {"id": message.data["chatRoomId"]});
      });
    });
  }

  static void initializeBackgroundHandler() =>
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

  late String _firebaseMessagingToken;
  String get firebaseMessagingToken => _firebaseMessagingToken;

  static FirebaseNotificationService instance = FirebaseNotificationService._();

  Future<NotificationSettings> get firebaseMessagingSettings async =>
      await firebaseMessaging.getNotificationSettings();

  Future<AuthorizationStatus> get firebaseMessagingAuthStatus async =>
      (await firebaseMessagingSettings).authorizationStatus;

  Future<void> requestPermission() async {
    await firebaseMessaging.requestPermission(
      announcement: true,
      criticalAlert: true,
      provisional: true,
    );
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void sendFirebaseMessaging(List<String> receiverFCMids, String senderName,
      shared.Message msg) async {
    var e = receiverFCMids.first;
    try {
      FCMService.sendMessage(
          message: FirebaseMessage(
              token: e,
              android: const FirebaseAndroidConfig(
                  ttl: 60, priority: AndroidMessagePriority.high),
              notification: FirebaseNotification(
                title: senderName,
                body: msg.text,
              ))).then((_) => logs.config('send FCM Successfull'),
          onError: (_) => logs
              .severeError(_ == null ? 'Error return null' : 'Get error: $_'));
      // await Future.wait(futures);
    } catch (e) {
      logs.severeError(e);
    }
  }

  Future<void> initializeFlutterNotificationSettings() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const appleSettings = DarwinInitializationSettings(
        requestCriticalPermission: true, requestProvisionalPermission: true);

    const linuxSettings =
        LinuxInitializationSettings(defaultActionName: 'reConnect');

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidSettings,
            iOS: appleSettings,
            macOS: appleSettings,
            linux: linuxSettings);
    try {
      await flutterNotifications.initialize(initializationSettings);
      _firebaseMessagingToken = (await firebaseMessaging.getToken())!;
      logs.shout(_firebaseMessagingToken);
    } catch (e) {
      logs.severeError(e);
    }
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification == null || android == null) return;
    logs.shout(message.toMap());
    const androidDetails = AndroidNotificationDetails(
        'com.app.reConnect', 'reConnect',
        channelDescription: 'got an notification.',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        ticker: 'ticker');
    flutterNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(android: androidDetails),
    );
  }
}
