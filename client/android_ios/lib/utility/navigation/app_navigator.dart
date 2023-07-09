// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart'
    show BuildContext, GlobalKey, NavigatorState, ScaffoldMessengerState;
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

///```
///  callback != null
///       ? callback!(GoRouter.of(_context))
///       : GoRouter.of(_context).goNamed('loading');
/// ```
typedef Callback = void Function(GoRouter router);

class AppNavigator {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static final navigatorKey = GlobalKey<NavigatorState>();

  const AppNavigator._internal([this.task, this.callback]);

  static Future<void> after(Callback goRouter,
      {required Future task, Callback? callback}) {
    return AppNavigator._internal(task, callback)._on(goRouter);
  }

  static Future<void> on(Callback goRouter) {
    return const AppNavigator._internal()._on(goRouter);
  }

  /// For quick access
  static void pop<T extends Object?>([T? result]) =>
      GoRouter.of(context!).pop(result);

  /// For quick access
  static Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) =>
      GoRouter.of(context!).pushNamed(name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra);

  final Future? task;
  final Callback? callback;

  static BuildContext? get context => navigatorKey.currentContext;
  static bool? get mounted => navigatorKey.currentState?.mounted;
  static NavigatorState? get currentState => navigatorKey.currentState;

  Future<void> _on(Callback goRouter) =>
      waitForTask().whenComplete(() => goRouter(GoRouter.of(context!)));

  Future<void> waitForTask() async {
    logs('Before AfterTast ');
    if (task != null) {
      logs('Alert-- AfterTast not null');
      callback != null
          ? callback!(GoRouter.of(context!))
          : GoRouter.of(context!).goNamed('loading');
      await task;
    }
    return;
  }
}
