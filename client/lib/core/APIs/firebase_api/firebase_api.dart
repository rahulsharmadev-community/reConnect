export 'src/firestore_api/chatrooms_api.dart';
export 'src/firestore_api/messages_api.dart';
export 'src/realtime_api/primary_user_api.dart';
export 'src/realtime_api/user_api.dart';
export 'src/realtime_api/appmetadata_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logs/logs.dart';
import '../../../tokens/firebase.options.dart';

Future<void> initializeFirebaseApi() async {
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } on FirebaseException catch (_) {
    logs.severeError(_.message, _.code);
  }
}
