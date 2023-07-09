import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:shared/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';

class PrimaryUserRepository {
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

  Future<PrimaryUser?> fetchPrimaryUser() async {
    final _raw = await usersRef
        .orderByChild('deviceInfo/androidId')
        .equalTo(deviceInfo.androidId)
        .get();
    Map? raw = _raw.exists ? _raw.value as Map : null;

    if (raw == null) return null;

    final data = jsonDecode(jsonEncode(raw.values.first));

    // internal variable..
    _setPrimaryUserId(raw.keys.first);

    List<ChatRoomInfo> _chatRooms = (data["chatRooms"] != null)
        ? await chatRoomsRepository
            .fetchChatRoomsByIds((data["chatRooms"] as Map).keys.toList())
        : [];
    List<User> _contacts = (data["contacts"] != null)
        ? await UserRepository()
            .fetchUserByIds((data["contacts"] as Map).keys.toList())
        : [];
    data.remove('chatRooms');
    data.remove('contacts');
    return PrimaryUser.fromMap(data)
        .copyWith(chatRooms: _chatRooms, contacts: _contacts);
  }

  /// Only settings will change
  Future<void> updateSettings(
      UserSettings newValue, UserSettings oldValue) async {
    var difference = newValue.toMap.difference(oldValue.toMap, false);
    if (difference.isNotEmpty)
      await usersRef.child('$_primaryUserId/settings').update(difference);
  }

  /// This Values NOT change \
  /// [settings, chatRooms, contacts, deviceInfo]
  Future<void> updateProfile(PrimaryUser newValue, PrimaryUser oldValue) async {
    bool remove(key, value) =>
        key == 'settings' ||
        key == 'chatRooms' ||
        key == 'contacts' ||
        key == 'deviceInfo';

    final _newMap = newValue.toMap..removeWhere(remove);
    final _oldMap = oldValue.toMap..removeWhere(remove);

    var difference = _newMap.difference(_oldMap);

    if (difference.isNotEmpty)
      await usersRef.child(_primaryUserId).update(difference);
  }

  /// Only add new ids in chatRooms
  Future<void> addNewChatRoomIds(List<String> list) async {
    if (list.isNotEmpty)
      await usersRef
          .child("$_primaryUserId/chatRooms/")
          .update(Map.fromIterable(list));
  }

  /// Only remove existing ids from chatRooms
  Future<void> removeExistingChatRoomIds(List<String> list) async {
    if (list.isNotEmpty)
      await usersRef
          .child("$_primaryUserId/chatRooms/")
          .update(Map.fromIterable(list, value: (e) => null));
  }

  /// Only add new ids in contacts
  Future<void> addNewContactsIds(List<String> list) async {
    print('==>$list');
    if (list.isNotEmpty)
      await usersRef
          .child("$_primaryUserId/contacts")
          .update(Map.fromIterable(list));
  }

  /// Only remove existing ids from contacts
  Future<void> removeExistingContactsIds(List<String> list) async {
    if (list.isNotEmpty)
      await usersRef
          .child("$_primaryUserId/contacts")
          .update(Map.fromIterable(list, value: (e) => null));
  }

  Future<void> CreatePrimaryUserAccount(PrimaryUser logInUser) async {
    await usersRef.child(logInUser.userId).set(logInUser.toMap);
  }
}
