import 'dart:io';

import 'package:android_info/android_info.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared/firebase_api/firebase_api.dart';
import 'utility/bloc_observer/bloc_observer.dart';
import 'flutter_app_run.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebaseApi();
  Bloc.observer = FlutterBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory());

  if (Platform.isAndroid) {
    final androidInfo = await AndroidInfoPlugin().androidInfo;
    runApp(FlutterAppRunner(android: androidInfo));
  }
}
