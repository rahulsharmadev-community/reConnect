import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/shared.dart';

abstract class Service {
  static final firestore = FirebaseFirestore.instance.collection('USERS');

  static Future<List<User>> findByPhoneNumber(String input) async {
    print('\nrun: findByPhoneNumber');
    var raw = await firestore.where('phone_number', isEqualTo: input).get();

    print('\nlength: ${raw.docs.length}');
    return raw.docs.map((e) => User.fromMap(e.data())).toList();
  }

  static Future<List<User>> findByEmail(String input) async {
    print('\nrun: findByEmail');
    var raw = await firestore.where('email', isEqualTo: input).get();

    print('\nlength: ${raw.docs.length}');
    return raw.docs.map((e) => User.fromMap(e.data())).toList();
  }
}
