import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared/shared.dart';
import '../firestore_repository/chatrooms_repository.dart';
import 'user_repository.dart';
import 'package:logs/logs.dart';
part '../error_handler.dart';

class PrimaryUserRepository with FirebaseExceptionHandler {
  final logs = Logs('PrimaryUserRepository');
  final DeviceInfo deviceInfo;
  final DatabaseReference usersRef;
  final ChatRoomsRepository chatRoomsRepository;

  PrimaryUserRepository({
    required this.deviceInfo,
    required this.chatRoomsRepository,
  }) : usersRef = FirebaseDatabase.instance.ref('USERS');

  late final String _primaryUserId;
  bool _hasPrimaryUserInitialized = false;

  _setPrimaryUserId(String id) {
    if (!_hasPrimaryUserInitialized) {
      _primaryUserId = id;
      _hasPrimaryUserInitialized = true;
    }
  }

  /// Fetching Raw Data of Primary User
  Future<Map<String, dynamic>?> _fetchRawData() async {
    return await errorHandler<Map<String, dynamic>?>(() async {
      var raw = await usersRef
          .orderByChild('deviceInfo/androidId')
          .equalTo(deviceInfo.androidId)
          .get();
      return raw.exists
          ? jsonDecode(jsonEncode((raw.value as Map).values.first))
          : null;
    });
  }

  Future<List<User>> _fetchContacts(Iterable<dynamic> ids) async =>
      await UserRepository().fetchUserByIds(ids.toList());

  Future<List<ChatRoomInfo>> _fetchChatRooms(
      Iterable<dynamic> ids, List<User> contacts) async {
    var list = await chatRoomsRepository.fetchRawChatRoomsByIds(ids.toList());
    List<ChatRoomInfo> retlist = [];
    for (var map in list) {
      var mems = (map['members'] as List);
      if (mems.length == 2) {
        var userId = mems.firstWhere((e) => e != _primaryUserId);
        var user = contacts.firstWhere((e) => userId == e.userId);
        map['name'] = user.name;
        map['about'] = user.about;
        map['profileImg'] = user.profileImg;
      }
      retlist.add(ChatRoomInfo.fromJson(map));
    }
    return retlist;
  }

  /// Need to be improvement
  Future<PrimaryUser?> fetchPrimaryUser() async {
    final map = await _fetchRawData();
    if (map == null) return null;

    // internal variable..
    _setPrimaryUserId(map['userId']);

    List<User> contacts = await _fetchContacts((map['contacts'] ?? {}).keys);
    List<ChatRoomInfo> chatRooms =
        await _fetchChatRooms((map['chatRooms'] ?? {}).keys, contacts);

    map.remove('chatRooms');
    map.remove('contacts');

    return PrimaryUser.fromMap(map)
        .copyWith(chatRooms: chatRooms, contacts: contacts);
  }

  /// Only settings will change
  Future<void> updateSettings(
      UserSettings newValue, UserSettings oldValue) async {
    var difference = newValue.toMap.difference(oldValue.toMap, false);
    if (difference.isNotEmpty) {
      await errorHandler(
          () => usersRef.child('$_primaryUserId/settings').update(difference));
    }
  }

  /// This Values NOT change \
  /// [settings, chatRooms, contacts, deviceInfo]
  Future<void> updateProfile(PrimaryUser newValue, PrimaryUser oldValue) async {
    bool remove(key, value) =>
        key == 'settings' ||
        key == 'chatRooms' ||
        key == 'contacts' ||
        key == 'deviceInfo';

    final newMap = newValue.toMap..removeWhere(remove);
    final oldMap = oldValue.toMap..removeWhere(remove);

    var difference = newMap.difference(oldMap);

    if (difference.isNotEmpty) {
      await errorHandler(
          () => usersRef.child(_primaryUserId).update(difference));
    }
  }

  /// Only add new ids in chatRooms
  Future<void> addNewChatRoomIds(List<String> list) async {
    if (list.isNotEmpty) {
      await errorHandler(() => usersRef
          .child("$_primaryUserId/chatRooms/")
          .update(Map.fromIterable(list)));
    }
  }

  /// Only remove existing ids from chatRooms
  Future<void> removeExistingChatRoomIds(List<String> list) async {
    if (list.isNotEmpty) {
      await errorHandler(() async {
        usersRef
            .child("$_primaryUserId/chatRooms/")
            .update(Map.fromIterable(list, value: (e) => null));
      });
    }
  }

  /// Only add new ids in contacts
  Future<void> addNewContactsIds(List<String> list) async {
    if (list.isNotEmpty) {
      await errorHandler<void>(() => usersRef
          .child("$_primaryUserId/contacts")
          .update(Map.fromIterable(list)));
    }
  }

  /// Only remove existing ids from contacts
  Future<void> removeExistingContactsIds(List<String> list) async {
    if (list.isNotEmpty) {
      await errorHandler(() => usersRef
          .child("$_primaryUserId/contacts")
          .update(Map.fromIterable(list, value: (e) => null)));
    }
  }

  Future<void> CreatePrimaryUserAccount(PrimaryUser logInUser) async {
    await errorHandler(() async {
      await usersRef.child(logInUser.userId).set(logInUser.toMap);
    });
  }
}
