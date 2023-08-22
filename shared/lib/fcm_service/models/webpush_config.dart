class FCMsWebpushConfig {
  final Map<String, String>? headers;
  final Map<String, String>? data;

  /// Web Notification options as a JSON object. Supports Notification instance properties as defined in
  /// [Web Notification API.](https://developer.mozilla.org/en-US/docs/Web/API/Notification)
  ///
  /// If present, "title" and "body" fields override
  final Map<String, dynamic>? notification;
  final WebpushFcmOptions? webPushFcmOptions;

  static FCMsWebpushConfig? fromMapOrNull(Map<String, dynamic>? map) => map == null
      ? null
      : FCMsWebpushConfig(
          headers: (map['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ),
          data: (map['data'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ),
          notification: map['notification'] as Map<String, dynamic>?,
          webPushFcmOptions: WebpushFcmOptions.fromMap(map['fcm_options']),
        );

  Map<String, dynamic> get toMap => <String, dynamic>{
        'headers': headers,
        'data': data,
        'notification': notification,
        'fcm_options': webPushFcmOptions?.toMap,
      };

  const FCMsWebpushConfig({
    this.headers,
    this.data,
    this.notification,
    this.webPushFcmOptions,
  });
}

class WebpushFcmOptions {
  /// The link to open when the user clicks on the notification. For all URL values, HTTPS is required.
  final String? link;

  /// Label associated with the message's analytics data.
  final String? analyticsLabel;

  WebpushFcmOptions({
    this.link,
    this.analyticsLabel,
  });

  static WebpushFcmOptions? fromMap(Map<String, dynamic>? json) => json == null
      ? null
      : WebpushFcmOptions(
          link: json["link"],
          analyticsLabel: json["analytics_label"],
        );

  Map<String, dynamic> get toMap => {
        "link": link,
        "analytics_label": analyticsLabel,
      };
}
