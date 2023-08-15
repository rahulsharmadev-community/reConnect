// ignore_for_file: avoid_logs.info

import 'package:flutter/widgets.dart';
import 'package:logs/logs.dart';

/// The Navigator observer.
class AppNavigatorObserver extends NavigatorObserver {
  /// Creates a [AppNavigatorObserver].
  List<String> stack = [];
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) stack.add(route.settings.name!);
    _printLogs('push', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (stack.isNotEmpty) stack.removeLast();
    _printLogs('pop', previousRoute, route);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    for (int i = stack.length - 1; i > -1; i--) {
      if (stack[i] == previousRoute?.settings.name) {
        stack.removeAt(i);
        break;
      }
    }
    _printLogs('remove', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    for (int i = stack.length - 1; i > -1; i--) {
      if (stack[i] == oldRoute!.settings.name) {
        stack[i] = newRoute!.settings.name!;
        break;
      }
    }
    _printLogs('replace', newRoute, oldRoute);
  }

  @override
  void didStartUserGesture(
          Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _printLogs('startUserGesture', route, previousRoute);

  @override
  void didStopUserGesture() => logs.info('stopUserGesture');

  void _printLogs(
      String action, Route<dynamic>? route, Route<dynamic>? previousRoute) {
    logs.verbose([
      'ACTION: $action()',
      'ACTIVE ROUTE: ${route?.str ?? 'NULL'}',
      'PREVIOUS ROUTE: ${previousRoute?.str ?? 'NULL'}',
      'FULL PATH: /${stack.join('/')}'
    ]);
  }
}

extension on Route<dynamic> {
  String get str {
    var arg = settings.arguments ?? '{}';
    return '${settings.name}${'$arg' == '{}' ? '' : '($arg)'}';
  }
}
