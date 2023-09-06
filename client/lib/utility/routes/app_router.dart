part of 'app_routes.dart';

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
                  path: AppRoutes.ProfileSettingsScreen.name,
                  name: AppRoutes.ProfileSettingsScreen.name,
                  builder: (context, state) => const ProfileSettingsScreen(),
                ),
                GoRoute(
                  path: AppRoutes.NotificationSoundScreen.name,
                  name: AppRoutes.NotificationSoundScreen.name,
                  builder: (context, state) => NotificationSoundScreen(),
                ),
                GoRoute(
                  path: AppRoutes.ChatSettingsScreen.name,
                  name: AppRoutes.ChatSettingsScreen.name,
                  builder: (context, state) => ChatSettingsScreen(),
                ),
                GoRoute(
                  path: AppRoutes.PrivacySecurityScreen.name,
                  name: AppRoutes.PrivacySecurityScreen.name,
                  builder: (context, state) => PrivacySecurityScreen(),
                ),
                GoRoute(
                  path: AppRoutes.StorageDataScreen.name,
                  name: AppRoutes.StorageDataScreen.name,
                  builder: (context, state) => const StorageDataScreen(),
                ),
                GoRoute(
                  path: AppRoutes.HelpCenterScreen.name,
                  name: AppRoutes.HelpCenterScreen.name,
                  builder: (context, state) => const HelpCenterScreen(),
                ),
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
