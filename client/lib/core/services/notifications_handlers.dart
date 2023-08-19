part of 'notifications_service.dart';

/// @pragma('vm:entry-point') Top-level function for handling background notifications
@pragma('vm:entry-point')
Future<void> backgroundMessageRenderer(FCMsMessage message) async {
  await initializeFirebaseApi();
  NotificationService.setInstance(
    credentials: credentials,
    application: application,
  );
  await NotificationService.instance._initializeDefaultNotificationSettings();
  logs.config(message.data, 'Handling a background message');
}

Future<void> backgroundMessageAppHandler(Map<String, dynamic> message) async {
  var chatroomId = message['chatRoomId'] as String;
  AppNavigator.pushNamed(AppRoutes.ChatScreen.name,
      pathParameters: {'id': chatroomId});
}

Future<void> forgroundMessageAppHandler(Map<String, dynamic> message) async {
  var chatroomId = message['chatRoomId'] as String;
  AppNavigator.pushNamed(AppRoutes.ChatScreen.name,
      pathParameters: {'id': chatroomId});
}

Future<void> forgroundMessageRenderer(FCMsMessage message) async {
  NotificationService.instance.renderFlutterNotification(message);
}
