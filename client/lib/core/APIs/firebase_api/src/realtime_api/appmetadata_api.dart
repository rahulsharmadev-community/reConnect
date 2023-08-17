import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared/models/src/chatroom_roles.dart';
import '../error_handler.dart';

class AppMetaDataApi with FirebaseExceptionHandler {
  final DatabaseReference ref;
  AppMetaDataApi() : ref = FirebaseDatabase.instance.ref('AppMetaData');

  Future<ChatRoomRoles> chatRoomDefaultPermissions() async {
    final resp = await errorHandler(
        () async => await ref.child('chatRoomDefaultPermissions').get());
    return ChatRoomRoles.fromMap(jsonDecode(jsonEncode(resp!.value)));
  }

  Future<String> aboutUs() async {
    final resp =
        await errorHandler(() async => await ref.child('about-us').get());
    return resp!.value.toString();
  }

  Future<String> contactUs() async {
    final resp =
        await errorHandler(() async => await ref.child('contact-us').get());
    return resp!.value.toString();
  }

  Future<String> privacyPolicy() async {
    final resp =
        await errorHandler(() async => await ref.child('privacy-policy').get());
    return resp!.value.toString();
  }

  Future<String> termsOfService() async {
    final resp = await errorHandler(
        () async => await ref.child('terms-of-service').get());
    return resp!.value.toString();
  }
}
