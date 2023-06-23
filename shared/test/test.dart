import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/firebase_api/firebase_api.dart';
import 'package:shared/firebase_api/src/firebase_options.dart';

void main() {
  test('Inital test', () async {
    FirebaseFirestore.instanceFor(
        app: await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform));
    final user =
        await UserRepository().fetchLogInUserById('2a97215100f5f8365d8b');
    print(user?.toMap ?? "NULL");
  });
}
