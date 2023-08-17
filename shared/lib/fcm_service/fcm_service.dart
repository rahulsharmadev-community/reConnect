import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart' as google;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logs/logs.dart';
import 'package:http/http.dart' as http;
import 'package:shared/fcm_service/models/account_credentials.dart';
import 'models/message.dart';

class FCMService extends BlocBase<google.AccessCredentials?>
    with HydratedMixin<google.AccessCredentials?> {
  final FirebaseAccountCredentials credentials;
  FCMService._({required this.credentials}) : super(null);

  static late final FCMService _instance;
  static loadCredentials(FirebaseAccountCredentials credentials) =>
      _instance = FCMService._(credentials: credentials);

  static Future<void> sendMessage(
          {bool? validateOnly, required FirebaseMessage message}) =>
      _instance.send(message: message, validateOnly: validateOnly);

  Future<void> send(
      {bool? validateOnly, required FirebaseMessage message}) async {
    try {
      if (state == null) {
        await _performAuth();
      } else if (DateTime.now().isAfter(state!.accessToken.expiry)) {
        await _refreshAccessCredentials(state!);
      }
      // Send Message Request and Save it's response
      final response = await http.post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/${credentials.projectID}/messages:send',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${state!.accessToken.data}'
        },
        body: json.encode({
          'validate_only': validateOnly,
          'message': message.toMap,
        }),
      );

      logs.shout(response.body, response.statusCode);
      if (response.statusCode == 200) logs.config(response.body, 'Succesfull');
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
      emit(value);
    } catch (e) {
      rethrow;
    }

    client.close();
    logs.shout(state?.toJson());
  }

  Future<void> _refreshAccessCredentials(
      google.AccessCredentials accessCredentials) async {
    final http.Client client = http.Client();
    try {
      var value = await google.refreshCredentials(
          credentials.googleAccountCredentials.clientId,
          accessCredentials,
          client);
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
