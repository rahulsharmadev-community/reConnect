export 'models/webpush_config.dart';
export 'models/account_credentials.dart';
export 'models/android_config.dart';
export 'models/android_notification.dart';
export 'models/apns_config.dart';
export 'models/fcm_options.dart';
export 'models/message.dart';
export 'models/notification.dart';
export 'models/_ext.dart';
import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart' as google;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logs/logs.dart';
import 'package:http/http.dart' as http;
import 'package:shared/fcm_service/models/_ext.dart';
import 'package:shared/fcm_service/models/account_credentials.dart';
import 'models/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class _FCMsBase extends BlocBase<google.AccessCredentials?>
    with HydratedMixin<google.AccessCredentials?> {
  final Uri coreUri;
  final FirebaseAccountCredentials credentials;
  _FCMsBase(super.state, this.credentials)
      : coreUri = Uri.parse(
            'https://fcm.googleapis.com/v1/projects/${credentials.projectID}/messages:send');

  Future<void> _send({bool? validateOnly, required FCMsMessage message}) async {
    try {
      if (state == null || DateTime.now().isAfter(state!.accessToken.expiry)) {
        await _performAuth();
      }
      // Send Message Request and Save it's response
      await http.post(
        coreUri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${state!.accessToken.data}'
        },
        body: json.encode({
          'validate_only': validateOnly,
          'message': message.toMap,
        }),
      );
    } on HttpException catch (e) {
      logs.severeError(e, 'From: FirebaseMessagingApi');
    } catch (e) {
      logs.severeError(e, 'From: FirebaseMessagingApi');
    }
  }

  Future<void> _performAuth() async {
    // Get Service Account Credentials from Given Map
    // We only required messaging scope to send messages
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final http.Client client = http.Client();
    try {
      var value = await google.obtainAccessCredentialsViaServiceAccount(
        credentials.googleAccountCredentials,
        scopes,
        client,
      );
      logs.verbose(value.toJson(),
          'After the last credentials expire, request service account credentials.');
      emit(value);
    } catch (e) {
      rethrow;
    }

    client.close();
    logs.shout(state?.toJson());
  }

  @override
  google.AccessCredentials? fromJson(Map<String, dynamic> json) =>
      json.isEmpty ? null : google.AccessCredentials.fromJson(json);

  @override
  Map<String, dynamic>? toJson(google.AccessCredentials? state) =>
      state?.toJson() ?? {};
}

/// The Firebase Cloud Messaging Service(FCMs).
class FCMs extends _FCMsBase {
  final FirebaseAccountCredentials credentials;

  FCMs._({required this.credentials}) : super(null, credentials);
  static late final FCMs _instance;
  static String _token = 'null';
  static String get token => _token;

  static void initialize(
    FirebaseAccountCredentials credentials, {
    Future<void> Function(RemoteMessage)? backgroundRenderer,
    Future<void> Function(FCMsMessage)? forgroundRenderer,
    Future<void> Function(Map<String, dynamic>)? backgroundAppHandler,
  }) async {
    _instance = FCMs._(credentials: credentials);
    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging
        .getToken()
        .then((value) => _token = value ?? 'null');

    firebaseMessaging.onTokenRefresh.listen((token) => token = token,
        onError: (e) => logs.severeError(e, 'Error: onTokenRefresh'));

    if (forgroundRenderer != null)
      FirebaseMessaging.onMessage.listen((_) => forgroundRenderer(_.toFCMs),
          onError: (e) => logs.severeError(e, 'Error: onMessage'));

    if (backgroundAppHandler != null)
      FirebaseMessaging.onMessageOpenedApp.listen(
          (_) => backgroundAppHandler(
              _.data.map((k, v) => MapEntry(k, json.decode(v)))),
          onError: (e) => logs.severeError(e, 'Error: onMessageOpenedApp'));

    if (backgroundRenderer != null) {
      FirebaseMessaging.onBackgroundMessage(backgroundRenderer);
    }
  }

  /// Subscribe to topic in background.
  static Future<void> subscribeToTopic(String topic) async =>
      await FirebaseMessaging.instance.subscribeToTopic(topic);

  /// Unsubscribe from topic in background.
  static Future<void> unsubscribeFromTopic(String topic) async =>
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);

  static Future<void> sendMessage(
      {bool? validateOnly, required FCMsMessage message}) async {
    try {
      await _instance._send(message: message, validateOnly: validateOnly);
    } catch (e) {
      logs.severeError(e);
    }
  }

  static Future<void> requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      criticalAlert: true,
      provisional: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
