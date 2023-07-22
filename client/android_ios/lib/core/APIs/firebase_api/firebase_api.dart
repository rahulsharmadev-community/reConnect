/// Support for doing something awesome.
///
/// More dartdocs go here.
export 'src/firestore_repository/chatrooms_repository.dart';
export 'src/firestore_repository/messages_repository.dart';
export 'src/realtime_repository/primary_user_repository.dart';
export 'src/realtime_repository/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/firebase_options.dart';

Future<void> initializeFirebaseApi() async {
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } on FirebaseException catch (_) {
  }
}
