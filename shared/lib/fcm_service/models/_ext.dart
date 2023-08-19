import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared/fcm_service/fcm_service.dart';

extension EnumByName<T extends Enum> on Iterable<T> {
  T? byNameOrNull(String? name) {
    if (name == null) return null;
    for (var value in this) {
      if (value.name == name) return value;
    }
    return null;
  }
}

extension ExtRemoteMessage on RemoteMessage {
  FCMsMessage get toFCMs {
    var android = notification?.android;
    var apple = notification?.apple;

    var web = notification?.web;
    return FCMsMessage(
        token: messageId,
        name: from,
        data: data.map((k, v) => MapEntry(k, json.decode(v))),
        apns: FCMsApnsConfig(image: apple?.imageUrl),
        webpush: FCMsWebpushConfig(
            webPushFcmOptions: WebpushFcmOptions(
          analyticsLabel: web?.analyticsLabel,
          link: web?.link,
        )),
        android: FCMsAndroidConfig(
          collapseKey: collapseKey,
          ttl: ttl ?? 86400,
          notification: FCMsAndroidNotification(
            title: notification?.title,
            titleLocArgs: notification?.titleLocArgs,
            titleLocKey: notification?.titleLocKey,
            body: notification?.body,
            bodyLocArgs: notification?.bodyLocArgs,
            bodyLocKey: notification?.bodyLocKey,
            image: android?.imageUrl,
            channelID: android?.channelId,
            clickAction: android?.clickAction,
            color: android?.color,
            notificationCount: android?.count,
            tag: android?.tag,
            sound: android?.sound,
            ticker: android?.ticker,
            icon: android?.smallIcon,
          ),
        ),
        notification: FCMsNotification(
          title: notification?.title,
          body: notification?.body,
        ));
  }
}
