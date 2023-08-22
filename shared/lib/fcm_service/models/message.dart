import 'dart:convert';

import 'android_config.dart';
import 'apns_config.dart';
import 'fcm_options.dart';
import 'notification.dart';
import 'webpush_config.dart';

class FCMsMessage {
  ///Output Only. The identifier of the message sent, in the format of projects/*/messages/{message_id}.
  final String? name;

  ///Input only. Basic notification template to use across all platforms.
  final FCMsNotification notification;

  ///Input only. Android specific options for messages sent through FCM connection server.
  final FCMsAndroidConfig? android;
  final FCMsWebpushConfig? webpush;
  final FCMsApnsConfig? apns;

  final FCMsOptions? fcmOptions;

  /// Registration token to send a message to.
  final String? token;

  /// Topic name to send a message to, e.g. "weather".
  ///
  /// Note: "/topics/" prefix should NOT be provided.
  final String? topic;

  /// Condition to send a message to,
  ///
  /// **For example, the following condition will send messages to devices that are subscribed to TopicA and either TopicB or TopicC:**
  /// ```
  /// String condition = "TopicA && (TopicB || TopicC)"
  /// ```
  ///
  /// FCM first evaluates any conditions in parentheses, and then evaluates the expression from left to right.
  /// In the above expression, a user subscribed to any single topic does not receive the message.
  /// Likewise, a user who does not subscribe to TopicA does not receive the message. These combinations do receive it:
  ///
  /// - **TopicA** and **TopicB**
  /// - **TopicA** and **TopicC**
  ///
  /// You can include up to five topics in your conditional expression.
  ///
  final String? condition;

  /// Input only. Arbitrary key/value payload. The key should not be a reserved word ("from", "message_type", or any word starting with "google" or "gcm").
  ///
  /// An object containing a list of "key": value pairs. Example: { "name": "wrench", "mass": "1.3kg", "count": "3" }.
  final Map<String, String>? _data;

  Map<String, dynamic>? get data =>
      _data?.map((k, v) => MapEntry(k, json.decode(v)));

  factory FCMsMessage.fromMap(Map<String, dynamic> map) => FCMsMessage(
        name: map['name'],
        data: map['data'] as Map<String, dynamic>?,
        notification: FCMsNotification.fromMapOrNull(map['notification'])!,
        android: FCMsAndroidConfig.fromMapOrNull(map['android']),
        webpush: FCMsWebpushConfig.fromMapOrNull(map['webpush']),
        apns: FCMsApnsConfig.fromMapOrNull(map['apns']),
        fcmOptions: FCMsOptions.fromMapOrNull(map['fcm_options']),
        token: map['token'],
        topic: map['topic'],
        condition: map['condition'],
      );

  Map<String, dynamic> get toMap => {
        'name': name,
        'data': _data,
        'notification': notification.toMap,
        'android': android?.toMap,
        'webpush': webpush?.toMap,
        'apns': apns?.toMap,
        'fcm_options': fcmOptions?.toMap,
        'token': token,
        'topic': topic,
        'condition': condition,
      };

  ///
  /// FCMsMessage only and necessary one of the following tokens, topics, or conditions should be accepted
  ///
  /// ### Token:
  /// Registration token to send a message to.
  ///
  /// ### Topic:
  /// Topic name to send a message to, e.g. "weather".
  ///
  /// ### Condition:
  ///
  /// Condition to send a message to,
  ///
  /// **For example, the following condition will send messages to devices that are subscribed to TopicA and either TopicB or TopicC:**
  /// ```
  /// String condition = "TopicA && (TopicB || TopicC)"
  /// ```
  ///
  /// FCM first evaluates any conditions in parentheses, and then evaluates the expression from left to right.
  /// In the above expression, a user subscribed to any single topic does not receive the message.
  /// Likewise, a user who does not subscribe to TopicA does not receive the message. These combinations do receive it:
  ///
  /// - **TopicA** and **TopicB**
  /// - **TopicA** and **TopicC**
  ///
  /// You can include up to five topics in your conditional expression.
  ///
  FCMsMessage({
    this.token,
    this.topic,
    this.name,
    String? condition,
    required this.notification,
    Map<String, dynamic>? data,
    this.android,
    this.webpush,
    this.apns,
    this.fcmOptions,
  })  : assert(
            (token != null ? 1 : 0) +
                    (topic != null ? 1 : 0) +
                    (condition != null ? 1 : 0) ==
                1,
            "Only one of the following tokens, topics, or conditions should be accepted"),
        condition = condition != null ? syntexToCondition(condition) : null,
        _data = data?.map((k, v) => MapEntry(k, json.encode(v)));

  @override
  String toString() => toMap.toString();
}

String syntexToCondition(String input) {
  var list = _convertStringToList(input);
  final output = _errorChecker(list);
  if (output is String) throw output;

  return (output as List<String>).join(' ');
}

dynamic _errorChecker(List<String> list) {
  int operators = 0;
  int topics = 0;
  int closingRoundBracket = 0;
  int openingRoundBracket = 0;

  for (int i = 0; i < list.length; i++) {
    var e = list[i].trim();
    if (e == '&&' || e == '||')
      operators++;
    else {
      switch (e) {
        case '(':
          openingRoundBracket++;
        case ')':
          closingRoundBracket++;
        default:
          topics++;
          list[i] = '$e in topics';
      }
    }
  }

  if (topics != operators + 1) {
    return 'Invalid use of operators';
  }
  if (closingRoundBracket != openingRoundBracket) {
    return 'Invalid use of `(` and `)` RoundBracket';
  }
  return list;
}

List<String> _convertStringToList(String input) {
  List<String> result = [];
  StringBuffer buffer = StringBuffer();
  bool insideParentheses = false;

  for (int i = 0; i < input.length; i++) {
    String char = input[i];
    if (!RegExp(r'^[-_a-zA-Z0-9()&| ]+$').hasMatch(char)) {
      throw 'Syntax error: $char are not alowed';
    }
    if (char == '(' || char == ')') {
      if (buffer.isNotEmpty) {
        result.add(buffer.toString());
        buffer.clear();
      }
      result.add(char);
      insideParentheses = char == '(';
    } else if (char == ' ' && !insideParentheses) {
      if (buffer.isNotEmpty) {
        result.add(buffer.toString());
        buffer.clear();
      }
    } else if (char == '&' || char == '|') {
      if (buffer.isNotEmpty) {
        result.add(buffer.toString());
        buffer.clear();
      }
      if (i + 1 < input.length && input[i + 1] == char) {
        result.add('$char$char');
        i++; // Skip the next character
      } else {
        result.add(char);
      }
    } else {
      buffer.write(char);
    }
  }

  if (buffer.isNotEmpty) {
    result.add(buffer.toString());
  }

  return result;
}
