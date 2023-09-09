import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:jars/jars.dart';
import 'package:shared/shared.dart';
import '../firestore_api/chatrooms_api.dart';
import 'user_api.dart';
import '../error_handler.dart';

class PrimaryUserApi with FirebaseExceptionHandler {
  final DeviceInfo deviceInfo;
  final DatabaseReference usersRef;
  final ChatRoomsApi chatRoomsApi;

  PrimaryUserApi({
    required this.deviceInfo,
    required this.chatRoomsApi,
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

  Future<Map<String, User>> _fetchContacts(Iterable<dynamic> ids) async {
    var list = await UserApi().fetchUserByIds(ids.toList());
    return Map.fromIterable(list, key: (e) => e.userId);
  }

  Future<Map<String, ChatRoomInfo>> _fetchChatRooms(
    Iterable<dynamic> ids,
    List<User> contacts,
  ) async {
    var list = await chatRoomsApi.fetchChatRoomsByIds(ids.toList());
    list.forEach((key, value) {
      if (value.members.length == 2) {
        var userId = value.members.firstWhere((e) => e != _primaryUserId);
        var user = contacts.firstWhere((e) => userId == e.userId);
        list[key] = value.copyWith(
          name: user.name,
          about: user.about,
          profileImg: user.profileImg,
        );
      }
    });
    return list;
  }

  Future<PrimaryUser?> fetchPrimaryUser() async {
    final map = await _fetchRawData();
    if (map == null) return null;

    // internal variable..
    _setPrimaryUserId(map['userId']);

    var contacts = (await _fetchContacts((map['contacts'] ?? {}).keys));

    Map<String, ChatRoomInfo> chatRooms = await _fetchChatRooms(
        (map['chatRooms'] ?? {}).keys, contacts.values.toList());

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
  Future<void> addNewChatRoomIds(Iterable<String> list) async {
    if (list.isNotEmpty) {
      await errorHandler(() => usersRef
          .child("$_primaryUserId/chatRooms/")
          .update(Map.fromIterable(list)));
    }
  }

  /// Only remove existing ids from chatRooms
  Future<void> removeExistingChatRoomIds(Iterable<String> list) async {
    if (list.isNotEmpty) {
      await usersRef
          .child("$_primaryUserId/chatRooms/")
          .update(Map.fromIterable(list, value: (e) => null));
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

  Future<void> createPrimaryUserAccount(PrimaryUser logInUser) async {
    await errorHandler(() async {
      await usersRef.child(logInUser.userId).set(logInUser.toMap);
    });
  }
}
