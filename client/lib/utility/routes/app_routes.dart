// ignore_for_file: constant_identifier_names
import 'dart:async';
import 'package:reConnect/modules/screens/camera_screen/camera_screen.dart';
import 'package:reConnect/modules/screens/other_screens/image_preview_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:reConnect/modules/screens/screens.dart';
import 'package:shared/shared.dart';
part 'app_router.dart';

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
  ProfileSettingsScreen('profile_settings_screen'),
  NotificationSoundScreen('notification_sound_screen'),
  ChatSettingsScreen('chat_settings_screen'),
  PrivacySecurityScreen('privacy_security_screen'),
  StorageDataScreen('storage_data_screen'),
  HelpCenterScreen('help_center_screen'),

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
