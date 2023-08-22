import 'android_notification.dart';

class FCMsAndroidConfig {
  /// An identifier of a group of messages that can be collapsed, so that only the last message gets
  /// sent when delivery can be resumed. A maximum of 4 different collapse keys is allowed at any given time.
  final String? collapseKey;

  /// Message priority. Can take "normal" and "high" values. For more information,
  /// see [Setting the priority of a message](https://firebase.google.com/docs/cloud-messaging/concept-options#setting-the-priority-of-a-message)
  final AndroidMessagePriority priority;

  /// How long (in seconds) the message should be kept in FCM storage if the device is offline.
  /// The maximum time to live supported is 4 weeks, and the default value is 4 weeks if not set.
  ///
  /// Set it to 0 if want to send the message immediately. In JSON format, the Duration type
  /// is encoded as a string rather than an object, where the string ends in the suffix "s"
  /// (indicating seconds) and is preceded by the number of seconds, with nanoseconds expressed
  /// as fractional seconds.
  ///
  /// For example, 3 seconds with 0 nanoseconds should be encoded in
  /// JSON format as "3s", while 3 seconds and 1 nanosecond should be expressed in JSON format
  /// as "3.000000001s". The ttl will be rounded down to the nearest second.
  final String ttl;

  ///Package name of the application where the registration token must match in order to receive the message.
  final String? restrictedPackageName;

  ///Arbitrary key/value payload. If present, it will override google.firebase.fcm.v1.Message.data.
  ///
  ///An object containing a list of "key": value pairs.\
  ///Example: { "name": "wrench", "mass": "1.3kg", "count": "3" }.
  final Map<String, String>? data;

  ///Notification to send to android devices.
  final FCMsAndroidNotification? notification;

  static FCMsAndroidConfig? fromMapOrNull(Map<String, dynamic>? map) =>
      map == null
          ? null
          : FCMsAndroidConfig(
              collapseKey: map['collapse_key'],
              priority: AndroidMessagePriority.values.byName(map['priority']),
              ttl: map['ttl'],
              restrictedPackageName: map['restricted_package_name'],
              data: map['data']?.map((k, e) => MapEntry(k, e as String)),
              notification: map['notification'] == null
                  ? null
                  : FCMsAndroidNotification.fromMap(map['notification']),
            );

  Map<String, dynamic> get toMap => {
        'collapse_key': collapseKey,
        'priority': priority.name,
        'ttl': ttl,
        'restricted_package_name': restrictedPackageName,
        'data': data,
        'notification': notification,
      };

  /// Default [ttl] is 86400s (24 hr)
  const FCMsAndroidConfig({
    this.priority = AndroidMessagePriority.normal,
    int ttl = 86400,
    this.collapseKey,
    this.restrictedPackageName,
    this.data,
    this.notification,
  }) : ttl = '${ttl}s';
}

enum AndroidMessagePriority {
  normal,
  high;
}
