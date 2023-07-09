/// Support for doing something awesome.
///
/// More dartdocs go here.
export 'src/firestore_repository/chatrooms_repository.dart';
export 'src/firestore_repository/messages_repository.dart';
export 'src/firestore_repository/primary_user_repository.dart';
export 'src/firestore_repository/user_repository.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:shared/shared.dart';
import 'src/firebase_options.dart';

Future<void> initializeFirebaseApi() async {
  try {
    final app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    logs(app.name);
  } on FirebaseException catch (e) {
    logs('Error Occer $e');
  } catch (e) {
    logs(e);
  }
}
