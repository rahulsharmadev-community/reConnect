import 'android_config.dart';
import 'apns_config.dart';
import 'fcm_options.dart';
import 'notification.dart';
import 'webpush_config.dart';

class FirebaseMessage {
  ///Output Only. The identifier of the message sent, in the format of projects/*/messages/{message_id}.
  final String? name;

  ///Input only. Arbitrary key/value payload. The key should not be a reserved word ("from", "message_type", or any word starting with "google" or "gcm").
  //
  //An object containing a list of "key": value pairs. Example: { "name": "wrench", "mass": "1.3kg", "count": "3" }.
  final Map<String, String>? data;

  ///Input only. Basic notification template to use across all platforms.
  final FirebaseNotification? notification;

  ///Input only. Android specific options for messages sent through FCM connection server.
  final FirebaseAndroidConfig? android;
  final FirebaseWebpushConfig? webpush;
  final FirebaseApnsConfig? apns;

  final FirebaseFcmOptions? fcmOptions;

  ///Union field target. Required. Input only. Target to send a message to. target can be only one of token, topic or condition.
  final String? token;

  ///Union field target. Required. Input only. Target to send a message to. target can be only one of token, topic or condition.
  final String? topic;

  /// Condition to send a message to, e.g. "'foo' in topics && 'bar' in topics".
  ///
  /// Union field target. Required. Input only. Target to send a message to. target can be only one of token, topic or condition.
  final String? condition;

  factory FirebaseMessage.fromJson(Map<String, dynamic> json) =>
      FirebaseMessage(
        name: json['name'],
        data: (json['data'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(k, e as String),
        ),
        notification: FirebaseNotification.fromMap(json['notification']),
        android: FirebaseAndroidConfig.fromMap(json['android']),
        webpush: FirebaseWebpushConfig.fromJson(json['webpush']),
        apns: FirebaseApnsConfig.fromMap(json['apns']),
        fcmOptions: FirebaseFcmOptions.fromMap(json['fcm_options']),
        token: json['token'],
        topic: json['topic'],
        condition: json['condition'],
      );

  Map<String, dynamic> get toMap => {
        'name': name,
        'data': data,
        'notification': notification?.toMap,
        'android': android?.toMap,
        'webpush': webpush?.toMap,
        'apns': apns?.toMap,
        'fcm_options': fcmOptions?.toMap,
        'token': token,
        'topic': topic,
        'condition': condition,
      };

  const FirebaseMessage({
    this.name,
    this.data,
    this.notification,
    this.android,
    this.webpush,
    this.apns,
    this.fcmOptions,
    this.token,
    this.topic,
    this.condition,
  });

  @override
  String toString() => toMap.toString();
}
