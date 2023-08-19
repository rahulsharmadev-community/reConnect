// ignore_for_file: constant_identifier_names
import 'dart:typed_data';

import 'package:go_router/go_router.dart';
import 'package:reConnect/modules/screens/camera_screen/camera_screen.dart';
import 'package:shared/models/models.dart';
import 'package:shared/utility/utility.dart';
import 'package:reConnect/modules/screens/screens.dart';

/// This enum represents the different routes or screens available in the app.
///
/// A static [config] variable that holds the [GoRouter] configuration.
enum AppRoutes {
  AppDashBoard('app_dashboard'),
  UserSearchScreen('user_search_screen'),

  ///  The parameters for this match, e.g. {'id': 'f2'}
  ChatScreen('chat_screen'),

  ///onDone: void Function(List<Uint8List>)
  CameraScreen('camera_screen'),
  SendAndPreviewImagesScreen('send_and_preview_images_screen'),
  ChatroomEditorScreen('chatroom_editor_screen'),
  SettingsScreen('settings_screen'),
  PrivacyHandlingScreen('privacy_handling_screen'),
  ErrorScreen('error_screen'),
  LoadingScreen('loading_screen');

  const AppRoutes(this.name);
  final String name;
  // get path => '/$this';

  static GoRouter config = _AppRouter.internal().run;
}

class _AppRouter {
  _AppRouter.internal();

  GoRouter get run => GoRouter(
      initialLocation: '/${AppRoutes.AppDashBoard.name}',
      navigatorKey: AppNavigator.navigatorKey,
      observers: [AppNavigatorObserver()],
      routes: routes);

  var routes = [
    GoRoute(
        path: '/${AppRoutes.AppDashBoard.name}',
        name: AppRoutes.AppDashBoard.name,
        builder: (context, state) => AppDashBoard(
            initialPageIndex:
                int.parse(state.pathParameters['initialPageIndex'] ?? '0')),
        routes: [
          GoRoute(
            path: AppRoutes.UserSearchScreen.name,
            name: AppRoutes.UserSearchScreen.name,
            builder: (context, state) => const UserSearchScreen(),
          ),
          GoRoute(
            name: AppRoutes.ChatroomEditorScreen.name,
            path: '${AppRoutes.ChatroomEditorScreen.name}/:id',
            builder: (context, state) =>
                ChatroomEditorScreen(initRoom: state.extra as ChatRoomInfo?),
          ),
          GoRoute(
            name: AppRoutes.CameraScreen.name,
            path: AppRoutes.CameraScreen.name,
            builder: (context, state) => CameraScreen(
              onPreview: state.extra as Function(List<(String, Uint8List)>),
              onPop: AppNavigator.pop,
            ),
          ),
          GoRoute(
            name: AppRoutes.ChatScreen.name,
            path: '${AppRoutes.ChatScreen.name}/:id',
            builder: (context, state) =>
                ChatScreen(chatroomId: state.pathParameters['id']!),
          ),
          GoRoute(
              path: AppRoutes.SettingsScreen.name,
              name: AppRoutes.SettingsScreen.name,
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: AppRoutes.PrivacyHandlingScreen.name,
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
              ]),
        ]),
    GoRoute(
      path: '/${AppRoutes.LoadingScreen.name}',
      name: AppRoutes.LoadingScreen.name,
      pageBuilder: (context, state) {
        var extra =
            state.extra != null ? (state.extra as Map<String, dynamic>) : null;
        return NoTransitionPage(
            child: LoadingScreen(canPop: extra?["canPop"] ?? false));
      },
    ),
    GoRoute(
      path: '/${AppRoutes.ErrorScreen.name}',
      name: AppRoutes.ErrorScreen.name,
      pageBuilder: (context, state) {
        var extra = (state.extra as Map<String, dynamic>);

        return NoTransitionPage(
            child: ErrorScreen(canPop: extra["canPop"] ?? false));
      },
    ),
  ];
}
