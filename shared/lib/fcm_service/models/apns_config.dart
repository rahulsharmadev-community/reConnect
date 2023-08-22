/// Apple Push Notification Service.
class FCMsApnsConfig {
  final Map<String, String>? headers;

  /// APNs payload as a JSON object, including both aps dictionary and custom payload.
  /// See [Payload Key Reference.](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/generating_a_remote_notification)
  ///
  /// If present, it overrides [FirebaseNotification] title, body.
  final Map<String, dynamic>? payload;

  /// Contains the URL of an image that is going to be displayed in a notification.
  /// If present, it will override [FirebaseNotification]
  final String? image;
  const FCMsApnsConfig({this.headers, this.payload, this.image});

  static FCMsApnsConfig? fromMapOrNull(Map<String, dynamic>? map) => map == null
      ? null
      : FCMsApnsConfig(
          image: map['image'],
          headers: (map['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ),
          payload: map['payload'],
        );

  Map<String, dynamic> get toMap => {
        'image': image,
        'headers': headers,
        'payload': payload,
      };
}
