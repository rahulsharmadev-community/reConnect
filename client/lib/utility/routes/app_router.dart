// ignore_for_file: constant_identifier_names
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:reConnect/modules/screens/camera_screen/camera_screen.dart';
import 'package:reConnect/modules/screens/other_screens/image_preview_screen.dart';
import 'package:shared/utility/src/navigation/app_navigator.dart';
import 'package:shared/utility/src/navigation/app_navigator_observer.dart';
import 'package:shared/models/models.dart';
import 'package:reConnect/modules/screens/screens.dart';

/// This enum represents the different routes or screens available in the app.
///
/// A static [config] variable that holds the [GoRouter] configuration.
enum AppRoutes {
  AppDashBoard('app_dashboard'),
  UserSearchScreen('user_search_screen'),

  ///  The parameters for this match, e.g. {'id': 'f2'}
  ChatScreen('chat_screen'),

  ///```
  /// Function(List<(String, Uint8List)>) onPreview: extra['onPreview'],
  /// bool forceOnlyOneClick: extra['forceOnlyOneClick'],
  /// VoidCallback onPop: AppNavigator.pop,
  /// ```
  CameraScreen(
    'camera_screen',
  ),

  /// String title\
  /// String? url\
  /// Uint8List? bytes
  ImagePreviewScreen('image_preview_screen'),

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

  static void pop<T extends Object?>({T? result, int count = 1}) =>
      AppNavigator.pop<T>(count: count, result: result);

  Future<dynamic> pushNamed(
          {Map<String, String> pathParameters = const <String, String>{},
          Map<String, dynamic> queryParameters = const <String, dynamic>{},
          Object? extra}) =>
      AppNavigator.on((router) => router.pushNamed(name,
          extra: extra,
          pathParameters: pathParameters,
          queryParameters: queryParameters));

  Future<void> goNamed(
          {Map<String, String> pathParameters = const <String, String>{},
          Map<String, dynamic> queryParameters = const <String, dynamic>{},
          Object? extra}) =>
      AppNavigator.on((router) => router.goNamed(name,
          extra: extra,
          pathParameters: pathParameters,
          queryParameters: queryParameters));

  Future<void> replaceNamed(
          {Map<String, String> pathParameters = const <String, String>{},
          Map<String, dynamic> queryParameters = const <String, dynamic>{},
          Object? extra}) =>
      AppNavigator.on((router) => router.replaceNamed(name,
          extra: extra,
          pathParameters: pathParameters,
          queryParameters: queryParameters));

  Future<void> pushReplacementNamed(
          {Map<String, String> pathParameters = const <String, String>{},
          Map<String, dynamic> queryParameters = const <String, dynamic>{},
          Object? extra}) =>
      AppNavigator.on((router) => router.pushReplacementNamed(name,
          extra: extra,
          pathParameters: pathParameters,
          queryParameters: queryParameters));

  Future<void> push({Object? extra}) => AppNavigator.on((router) => router.push(
        name,
        extra: extra,
      ));

  Future<void> replace({Object? extra}) =>
      AppNavigator.on((router) => router.replace(
            name,
            extra: extra,
          ));
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
            builder: (context, state) {
              var extra = state.extra as Map;
              return CameraScreen(
                onPreview: extra['onPreview'],
                forceOnlyOneClick: extra['forceOnlyOneClick'],
                onPop: AppNavigator.pop,
              );
            },
          ),
          GoRoute(
            name: AppRoutes.ChatScreen.name,
            path: '${AppRoutes.ChatScreen.name}/:id',
            builder: (context, state) =>
                ChatScreen(chatroomId: state.pathParameters['id']!),
          ),
          GoRoute(
            name: AppRoutes.ImagePreviewScreen.name,
            path: AppRoutes.ImagePreviewScreen.name,
            builder: (context, state) {
              var extra = state.extra as Map<String, dynamic>;
              return ImagePreviewScreen(
                title: extra['title'],
                url: extra['url'],
                bytes: extra['bytes'],
                onDone: extra['onDone'],
              );
            },
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
