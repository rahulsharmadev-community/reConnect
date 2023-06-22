/// Support for doing something awesome.
///
/// More dartdocs go here.
library firebase_repositories;

import 'package:firebase_core/firebase_core.dart';
import 'src/firebase_options.dart';

Future<void> initializeFirebaseApi() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
