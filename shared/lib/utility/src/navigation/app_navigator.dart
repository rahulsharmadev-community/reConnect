// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart'
    show BuildContext, GlobalKey, NavigatorState, ScaffoldMessengerState;
import 'package:go_router/go_router.dart' show GoRouter;

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
  static void pop<T extends Object?>({T? result, int count = 1}) {
    if (count == 1)
      return GoRouter.of(context!).pop(result);
    else
      while (count > 0) {
        GoRouter.of(context!).pop();
        count--;
      }
  }

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
  static NavigatorState? get navigatorState => navigatorKey.currentState;
  static ScaffoldMessengerState? get messengerState =>
      messengerKey.currentState;

  Future<void> _on(Callback goRouter) =>
      waitForTask().whenComplete(() => goRouter(GoRouter.of(context!)));

  Future<void> waitForTask() async {
    if (task != null) {
      callback != null
          ? callback!(GoRouter.of(context!))
          : GoRouter.of(context!).goNamed('loading_screen');
      await task;
    }
    return;
  }
}
