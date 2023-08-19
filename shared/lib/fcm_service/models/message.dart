import 'dart:convert';

import 'android_config.dart';
import 'apns_config.dart';
import 'fcm_options.dart';
import 'notification.dart';
import 'webpush_config.dart';

class FCMsMessage {
  ///Output Only. The identifier of the message sent, in the format of projects/*/messages/{message_id}.
  final String? name;

  ///Input only. Arbitrary key/value payload. The key should not be a reserved word ("from", "message_type", or any word starting with "google" or "gcm").
  //
  //An object containing a list of "key": value pairs. Example: { "name": "wrench", "mass": "1.3kg", "count": "3" }.
  final Map<String, dynamic>? data;

  ///Input only. Basic notification template to use across all platforms.
  final FCMsNotification? notification;

  ///Input only. Android specific options for messages sent through FCM connection server.
  final FCMsAndroidConfig? android;
  final FCMsWebpushConfig? webpush;
  final FCMsApnsConfig? apns;

  final FCMsOptions? fcmOptions;

  /// Registration token to send a message to.
  final String? token;

  /// Topic name to send a message to, e.g. "weather". Note: "/topics/" prefix should not be provided.
  final String? topic;

  /// Condition to send a message to, e.g. "'foo' in topics && 'bar' in topics".
  final String? condition;

  factory FCMsMessage.fromMap(Map<String, dynamic> map) => FCMsMessage(
        name: map['name'],
        data: (map['data'] ?? {}).map((k, v) => MapEntry(k, json.decode(v))),
        notification: FCMsNotification.fromMap(map['notification']),
        android: FCMsAndroidConfig.fromMap(map['android']),
        webpush: FCMsWebpushConfig.fromJson(map['webpush']),
        apns: FCMsApnsConfig.fromMap(map['apns']),
        fcmOptions: FCMsOptions.fromMap(map['fcm_options']),
        token: map['token'],
        topic: map['topic'],
        condition: map['condition'],
      );

  Map<String, dynamic> get toMap => {
        'name': name,
        'data': data?.map((k, v) => MapEntry(k, json.encode(v))),
        'notification': notification?.toMap,
        'android': android?.toMap,
        'webpush': webpush?.toMap,
        'apns': apns?.toMap,
        'fcm_options': fcmOptions?.toMap,
        'token': token,
        'topic': topic,
        'condition': condition,
      };

  const FCMsMessage({
    this.token,
    this.topic,
    this.condition,
    this.name,
    this.data,
    this.notification,
    this.android,
    this.webpush,
    this.apns,
    this.fcmOptions,
  }) : assert(
            (token != null ? 1 : 0) +
                    (topic != null ? 1 : 0) +
                    (condition != null ? 1 : 0) ==
                1,
            "Only one of token, topic, or condition should be provided.");

  @override
  String toString() => toMap.toString();
}
