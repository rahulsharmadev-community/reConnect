import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui' show PlatformDispatcher, Size;
import 'package:android_info/android_info.dart';
import 'package:cached_image/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:reConnect/core/services/notifications_service.dart';
import 'package:reConnect/tokens/account.credentials.dart';
import 'package:reConnect/tokens/flutter.credentials.dart';
import 'package:shared/shared.dart';
import 'flutter_app_run.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebaseApi();
  NotificationService.setInstance(
    credentials: credentials,
    application: application,
  );
  CachedImage.isolate = true;
  Bloc.observer = FlutterBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory());
  if (Platform.isAndroid) {
    runApp(reConnectAppRunner(await _deviceInfo));
  }
}

Future<DeviceInfo> get _deviceInfo async {
  final androidInfo = await AndroidInfoPlugin().androidInfo;
  Size? logicalPixels = PlatformDispatcher.instance.implicitView?.physicalSize;
  return DeviceInfo(
    sdkInt: androidInfo.version.sdkInt,
    model: androidInfo.model,
    androidId: androidInfo.androidId,
    buildId: androidInfo.buildId,
    device: androidInfo.device,
    hardware: androidInfo.hardware,
    isPhysicalDevice: androidInfo.isPhysicalDevice,
    logicalPixels: {
      "width": logicalPixels?.width.toInt(),
      "height": logicalPixels?.height.toInt()
    },
    physicalPixels: {
      "width": androidInfo.buildIdMetrics.widthPx.toInt(),
      "height": androidInfo.buildIdMetrics.heightPx.toInt()
    },
  );
}
