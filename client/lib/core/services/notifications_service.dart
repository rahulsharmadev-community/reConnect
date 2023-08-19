import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logs/logs.dart';
import 'package:reConnect/tokens/account.credentials.dart';
import 'package:reConnect/tokens/flutter.credentials.dart';
import 'package:reConnect/utility/routes/app_router.dart';
import 'package:shared/fcm_service/fcm_service.dart';
import 'package:shared/models/models.dart';
import 'package:shared/shared.dart' as shared;
import 'package:shared/utility/utility.dart';
import '../APIs/firebase_api/firebase_api.dart';

part 'notifications_handlers.dart';

class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance => _instance!;

  /// internally FCMs is initialize so, you don't have to initialize again
  static void setInstance(
          {required FirebaseAccountCredentials credentials,
          required Application application}) =>
      _instance ??= NotificationService._(credentials, application);

  final FlutterLocalNotificationsPlugin _flutterNotifications;
  final FirebaseAccountCredentials _credentials;
  final Application _application;
  NotificationService._(this._credentials, this._application)
      : _flutterNotifications = FlutterLocalNotificationsPlugin() {
    FCMs.initialize(_credentials,
        backgroundRenderer: backgroundMessageRenderer,
        backgroundAppHandler: backgroundMessageAppHandler,
        forgroundRenderer: forgroundMessageRenderer);
    _initializeDefaultNotificationSettings();
    FCMs.requestPermission();
  }

  String get token => FCMs.token;

  Future<void> _initializeDefaultNotificationSettings() async {
    final androidSettings =
        AndroidInitializationSettings(_application.androidNotificationIcon);
    const appleSettings = DarwinInitializationSettings(
        requestCriticalPermission: true, requestProvisionalPermission: true);
    final linuxSettings =
        LinuxInitializationSettings(defaultActionName: application.name);

    final initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: appleSettings,
      macOS: appleSettings,
      linux: linuxSettings,
    );
    try {
      await _flutterNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) =>
            forgroundMessageAppHandler(json.decode(details.payload!)),
      );
    } catch (e) {
      logs.severeError(e);
    }
  }

  void sendMessagingNotification(
      {required List<String> receiverFCMids,
      required String senderName,
      required shared.Message msg,
      required String chatRoomId,
      String? chatRoomName}) async {
    var token = receiverFCMids.first;
    try {
      FCMs.sendMessage(
          message: FCMsMessage(
        token: token,
        name: senderName,
        data: (msg.toFCM..addAll({"chatRoomId": chatRoomId})),
        android: FCMsAndroidConfig(
            collapseKey: chatRoomId,
            priority: AndroidMessagePriority.normal,
            notification: FCMsAndroidNotification(
              title: senderName,
              body: msg.text,
              clickAction: 'NOTIFICATION_CLICK',
            )),
      )).then((_) => logs.config('send FCM Successfull'),
          onError: (_) => logs
              .severeError(_ == null ? 'Error return null' : 'Get error: $_'));
      // await Future.wait(futures);
    } catch (e) {
      logs.severeError(e);
    }
  }

  void renderFlutterNotification(FCMsMessage message) {
    FCMsAndroidConfig? android = message.android;
    var notification = message.notification;
    if (notification == null || android == null) return;
    final androidDetails = AndroidNotificationDetails(
        _application.notificationChannelId,
        _application.notificationChannelName,
        channelDescription: _application.notificationChannelDescription,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        subText: 'SubText.',
        ticker: message.android?.notification?.ticker,
        tag: message.android?.notification?.tag);
    _flutterNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(android: androidDetails),
      payload: json.encode(message.data),
    );
  }
}
