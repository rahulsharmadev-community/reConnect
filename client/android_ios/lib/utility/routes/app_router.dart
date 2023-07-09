// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:reConnect/modules/screens/app_dashboard_screens/app_dashboard.dart';
import 'package:reConnect/modules/screens/privacy_handling_screen/privacy_handling_screen.dart';
import 'package:reConnect/modules/screens/settings_screen/settings_screen.dart';
import 'package:shared/models/models.dart';
import 'package:shared/utility/utility.dart';
import 'package:reConnect/modules/screens/screens.dart';

final appRouterConfig = _AppRouter.internal().run;

enum AppRoutes {
  AppDashBoard('app_dashboard'),
  UserSearchScreen('user_search_screen'),
  StartNewConversationScreen('start_new_conversation_screen'),

  /// {"chatRoomId": "xyz"}
  ChatScreen('chat_screen'),
  SettingsScreen('settings_screen'),
  PrivacyHandlingScreen('privacy_handling_screen');

  const AppRoutes(this.name);
  final String name;
  get path => '/$this';
}

class _AppRouter {
  _AppRouter.internal();

  GoRouter get run => GoRouter(
      initialLocation: AppRoutes.AppDashBoard.path,
      navigatorKey: AppNavigator.navigatorKey,
      debugLogDiagnostics: kDebugMode,
      observers: [AppNavigatorObserver()],
      routes: routes);

  var routes = [
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
          ChatScreen(chatRoomId: state.extra! as String),
    ),
    GoRoute(
      path: AppRoutes.StartNewConversationScreen.path,
      name: AppRoutes.StartNewConversationScreen.name,
      builder: (context, state) => ChatScreen.startNewConversation(
          chatRoom: state.extra as ChatRoomInfo),
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
          privacy: extra["privacy"] as Privacy,
          title: extra["title"],
          about: extra["subtitle"],
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
