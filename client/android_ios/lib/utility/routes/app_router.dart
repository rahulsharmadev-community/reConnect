// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:reConnect/modules/screens/app_dashboard_screens/app_dashboard.dart';
import 'package:reConnect/modules/screens/app_inital_setup_screen.dart';
import 'package:reConnect/modules/screens/privacy_handling_screen/privacy_handling_screen.dart';
import 'package:reConnect/modules/screens/settings_screen/settings_screen.dart';
import 'package:reConnect/utility/navigation/app_navigator.dart';
import 'package:shared/models/user.dart';
import '../navigation/app_navigator_observer.dart';
import 'package:reConnect/modules/screens/screens.dart';

final appRouterConfig = _AppRouter.internal().run;

enum AppRoutes {
  AppDashBoard('app_dashboard'),
  UserSearchScreen('user_search_screen'),

  /// {"chatRoomId": "xyz"}
  ChatScreen('chat_route'),
  SettingsScreen('settings_screen'),
  LogInScreen('login_screen'),
  AppInitalSetupScreen('app_inital_screen'),
  PrivacyHandlingScreen('privacy_handling_screen');

  const AppRoutes(this.name);
  final String name;
  get path => '/$this';
}

class _AppRouter {
  _AppRouter.internal();

  GoRouter get run => GoRouter(
      initialLocation: AppRoutes.AppInitalSetupScreen.path,
      navigatorKey: AppNavigator.navigatorKey,
      debugLogDiagnostics: kDebugMode,
      observers: [AppNavigatorObserver()],
      routes: routes);

  var routes = [
    GoRoute(
      path: AppRoutes.AppInitalSetupScreen.path,
      name: AppRoutes.AppInitalSetupScreen.name,
      builder: (context, state) => const AppInitalSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.AppDashBoard.path,
      name: AppRoutes.AppDashBoard.name,
      builder: (context, state) => AppDashBoard(
        initialPageIndex:
            int.parse(state.pathParameters['initialPageIndex'] ?? '0'),
      ),
    ),
    GoRoute(
      path: AppRoutes.UserSearchScreen.path,
      name: AppRoutes.UserSearchScreen.name,
      builder: (context, state) => const UserSearchScreen(),
    ),
    GoRoute(
      path: AppRoutes.ChatScreen.path,
      name: AppRoutes.ChatScreen.name,
      builder: (context, state) =>
          ChatScreen(chatRoomId: state.pathParameters['chatRoomId']!),
    ),
    GoRoute(
      path: AppRoutes.SettingsScreen.path,
      name: AppRoutes.SettingsScreen.name,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.PrivacyHandlingScreen.path,
      name: AppRoutes.PrivacyHandlingScreen.name,
      builder: (context, state) {
        var extra = (state.extra as Map<String, dynamic>);
        return PrivacyHandlingScreen(
          extra["privacy"] as Privacy,
          title: extra["title"],
          subtitle: extra["subtitle"],
        );
      },
    ),

    // GoRoute(
    //   path: AppRoutes.HomeScreen.path,
    //   name: AppRoutes.ChatScreen.name,
    //   builder: (context, state) =>
    //       const NoTransitionPage(child: TestSchedule()),
    // ),
  ];
}
