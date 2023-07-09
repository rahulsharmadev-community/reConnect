import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../models/models.dart';

class UserRepository {
  final String? userId;
  final DatabaseReference usersRef;
  UserRepository([this.userId])
      : usersRef = FirebaseDatabase.instance.ref('USERS');

  Future<User?> fetchUserByPhoneNumberOrEmail(String input) async {
    DataSnapshot? raw;
    if (input.contains(RegExp(r'^[0-9]{10}$')))
      raw = await usersRef.orderByChild("phoneNumber").equalTo(input).get();
    else
      raw = await usersRef.orderByChild("email").equalTo(input).get();

    if (raw.exists)
      return User.fromMap(
          jsonDecode(jsonEncode((raw.value as Map).values.first)));
    return null;
  }

  Future<List<User>> fetchUserByIds(List<dynamic> userIds) async {
    var future = userIds.map((e) => usersRef.child(e).get()).toList();

    List<DataSnapshot> data = await Future.wait(future);
    if (data.isEmpty) return [];
    return data
        .map((e) => User.fromMap(jsonDecode(jsonEncode(e.value))))
        .toList();
  }

  /// Only add new ids in chatRooms
  Future<void> addNewChatRoom_ContactIds(
      List<String> chatRoomsId, List<String> contacts) async {
    var future = <Future>[];
    if (chatRoomsId.isNotEmpty)
      future.add(usersRef
          .child('$userId/chatRooms')
          .update(Map.fromIterable(chatRoomsId)));
    if (contacts.isNotEmpty)
      future.add(usersRef
          .child('$userId/contacts')
          .update(Map.fromIterable(contacts)));
    await await Future.wait(future);
  }

  /// Only remove existing ids from chatRooms
  Future<void> removeExistingChatRoomIds(List<String> list) async {
    if (list.isNotEmpty)
      await usersRef.child("$userId/chatRooms").update(Map.fromIterable(list));
  }

  /// Only add new ids in contacts
  Future<void> addNewContactsIds(String userId, List<String> list) async {
    if (list.isNotEmpty)
      await usersRef
          .child("$userId/contacts")
          .update(Map.fromIterable(list, value: (_) => null));
  }

  /// Only remove existing ids from contacts
  Future<void> removeExistingContactsIds(List<String> list) async {
    if (list.isNotEmpty)
      await usersRef.child("$userId/contacts").update(Map.fromIterable(list));
  }
}
