class FirebaseWebpushConfig {
  final Map<String, String>? headers;
  final Map<String, String>? data;
  final Map<String, dynamic>? notification;
  final Map<String, dynamic>? webPushFcmOptions;

  static FirebaseWebpushConfig? fromJson(Map<String, dynamic>? map) =>
      map == null
          ? null
          : FirebaseWebpushConfig(
              headers: (map['headers'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ),
              data: (map['data'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ),
              notification: map['notification'] as Map<String, dynamic>?,
              webPushFcmOptions: map['fcm_options'] as Map<String, dynamic>?,
            );

  Map<String, dynamic> get toMap => <String, dynamic>{
        'headers': headers,
        'data': data,
        'notification': notification,
        'fcm_options': webPushFcmOptions,
      };

  const FirebaseWebpushConfig({
    this.headers,
    this.data,
    this.notification,
    this.webPushFcmOptions,
  });
}
