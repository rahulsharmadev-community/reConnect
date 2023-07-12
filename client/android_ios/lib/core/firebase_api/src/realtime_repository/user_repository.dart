// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:reConnect/core/firebase_api/firebase_api.dart';
import 'package:shared/models/models.dart';

class UserRepository with FirebaseExceptionHandler {
  final String? userId;
  final DatabaseReference usersRef;
  UserRepository([this.userId])
      : usersRef = FirebaseDatabase.instance.ref('USERS');

  Future<User?> fetchUserByPhoneNumberOrEmail(String input) async {
    DataSnapshot? raw;

    if (input.contains(RegExp(r'^[0-9]{10}$'))) {
      raw = await errorHandler<DataSnapshot>(() async =>
          await usersRef.orderByChild("phoneNumber").equalTo(input).get());
    } else {
      raw = await errorHandler<DataSnapshot>(() async =>
          await usersRef.orderByChild("email").equalTo(input).get());
    }

    if (raw != null || raw!.exists) {
      return User.fromMap(
          jsonDecode(jsonEncode((raw.value as Map).values.first)));
    }
    return null;
  }

  Future<List<User>> fetchUserByIds(List<dynamic> userIds) async {
    var future = userIds.map((e) => usersRef.child(e).get()).toList();

    List<DataSnapshot>? data = await errorHandler<List<DataSnapshot>>(
        () async => await Future.wait(future));
    if (data == null || data.isEmpty) return [];
    return data
        .map((e) => User.fromMap(jsonDecode(jsonEncode(e.value))))
        .toList();
  }

  /// Only add new ids in chatRooms
  Future<void> addNewChatRoom_ContactIds(
      List<String> chatRoomsId, List<String> contacts) async {
    var future = <Future>[];
    if (chatRoomsId.isNotEmpty) {
      future.add(usersRef
          .child('$userId/chatRooms')
          .update(Map.fromIterable(chatRoomsId)));
    }
    if (contacts.isNotEmpty) {
      future.add(usersRef
          .child('$userId/contacts')
          .update(Map.fromIterable(contacts)));
    }
    await errorHandler(() async => await Future.wait(future));
  }

  /// Only remove existing ids from chatRooms
  Future<void> removeExistingChatRoomIds(List<String> list) async {
    if (list.isNotEmpty) {
      await errorHandler(() async => await usersRef
          .child("$userId/chatRooms")
          .update(Map.fromIterable(list)));
    }
  }

  /// Only add new ids in contacts
  Future<void> addNewContactsIds(String userId, List<String> list) async {
    if (list.isNotEmpty) {
      await errorHandler(() async {
        await usersRef
            .child("$userId/contacts")
            .update(Map.fromIterable(list, value: (_) => null));
      });
    }
  }

  /// Only remove existing ids from contacts
  Future<void> removeExistingContactsIds(List<String> list) async {
    if (list.isNotEmpty) {
      await errorHandler(() async => await usersRef
          .child("$userId/contacts")
          .update(Map.fromIterable(list)));
    }
  }
}
