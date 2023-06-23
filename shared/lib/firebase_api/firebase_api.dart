/// Support for doing something awesome.
///
/// More dartdocs go here.
export 'src/firestore_repository/firestore_repository.dart';
export 'src/realtime_repository/realtime_repository.dart';
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
