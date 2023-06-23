import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/_models.dart';
import 'package:shared/shared.dart';

class UserRepository {
  UserRepository() : usersColl = FirebaseFirestore.instance.collection('USERS');
  final CollectionReference<Map<String, dynamic>> usersColl;

  Future<LogInUser?> fetchLogInUserById(String id) async {
    final raw = await usersColl.doc(id).get();
    if (!raw.exists) return null;
    return LogInUser.fromMap(raw.data()!);
  }

  Future<LogInUser?> fetchLoginUserByDevice(DeviceInfo deviceInfo) async {
    final raw = await usersColl
        .where('device_info.androidId', isEqualTo: deviceInfo.androidId)
        .limit(1)
        .get();
    if (raw.docs.isEmpty || !raw.docs.first.exists) return null;
    return LogInUser.fromMap(raw.docs.first.data());
  }

  Future<User?> fetchUserByPhoneNumberOrEmail(String phoneOrEmail) async {
    var or = Filter.or(
      Filter('phone_number', isEqualTo: phoneOrEmail),
      Filter('email', isEqualTo: phoneOrEmail),
    );
    final raw = await usersColl
        .where(or)
        .withConverter(
            fromFirestore: User.fromFirestore, toFirestore: User.toFirestore)
        .limit(1)
        .get();

    if (raw.docs.isEmpty) return null;
    return raw.docs.first.data();
  }

  Future<void> CreateLogInUserAccount(LogInUser logInUser) async {
    await usersColl.doc(logInUser.userId).set(logInUser.toMap);
  }
}
