// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:reConnect/tokens/flutter.credentials.dart';
import 'package:reConnect/utility/routes/app_routes.dart';
import 'widgets/tiles.dart';
import 'package:shared/shared.dart';

class SettingMetaData<A> {
  static final advanced_encryption = SettingMetaData(
    name: "Advanced encryption",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "Advanced encryption",
      subtitle: "Encrypt messages between all users in a chat",
      value: old!.advancedEncryption,
      onChanged: (bool value) =>
          onChanged!(old.copyWith(advancedEncryption: value)),
    ),
  );

  static final show_security_notifications = SettingMetaData(
    name: "Security notifications",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "Security notifications",
      subtitle: "Get notified when some one try to access your account.",
      value: old!.showSecurityNotifications,
      onChanged: (bool value) =>
          onChanged!(old.copyWith(showSecurityNotifications: value)),
    ),
  );

  static final hide_credential = SettingMetaData(
    name: "Phone no. or Email",
    defaultValue: Privacy(),
    widget: (context, {required old, required onChanged}) => ListTile(
        title: const Text("Phone no. or Email"),
        subtitle: const Text("Who can see my Phone number or Email"),
        onTap: () async {
          var newValue =
              await AppRoutes.PrivacyHandlingScreen.pushNamed(extra: {
            "privacy": old!.hideCredential,
            "title": "Phone no. or Email",
            "subtitle": "Who can see my Phone number or Email",
          });
          onChanged!(old.copyWith(hidePhoneNumber: newValue));
        }),
  );

  static final hide_about = SettingMetaData(
    name: "About",
    defaultValue: Privacy(),
    widget: (context, {required old, required onChanged}) => ListTile(
        title: const Text("About"),
        subtitle: const Text("Who can see my About"),
        onTap: () async {
          final newValue =
              await AppRoutes.PrivacyHandlingScreen.pushNamed(extra: {
            "privacy": old!.hideAbout,
            "title": "About",
            "subtitle": "Who can see my About",
          });
          onChanged!(old.copyWith(hidePhoneNumber: newValue));
        }),
  );

  static final hide_profile_img = SettingMetaData(
    name: "Profile photo",
    defaultValue: Privacy(),
    widget: (context, {required old, required onChanged}) => ListTile(
        title: const Text("Profile photo"),
        subtitle: const Text("Who can see my Profile Photo"),
        onTap: () async {
          final newValue =
              await AppRoutes.PrivacyHandlingScreen.pushNamed(extra: {
            "privacy": old!.hideProfileImg,
            "title": "Profile photo",
            "subtitle": "Who can see my Profile Photo",
          });
          onChanged!(old.copyWith(hideProfileImg: newValue));
        }),
  );

  static final status_reply_permission = SettingMetaData(
    name: "Status Reply Permission",
    defaultValue: Privacy(),
    widget: (context, {required old, required onChanged}) => ListTile(
        title: const Text("Status Reply Permission"),
        subtitle: const Text("Who can reply on my status"),
        onTap: () async {
          final newValue =
              await AppRoutes.PrivacyHandlingScreen.pushNamed(extra: {
            "privacy": old!.statusReplyPermission,
            "title": "Status Reply Permission",
            "subtitle": "Who can reply on my status",
          });
          onChanged!(old.copyWith(statusReplyPermission: newValue));
        }),
  );

  static final hide_status = SettingMetaData(
    name: "Status",
    defaultValue: Privacy(),
    widget: (context, {required old, required onChanged}) => ListTile(
        title: const Text("Status"),
        subtitle: const Text("Who can see my status updates"),
        onTap: () async {
          final newValue =
              await AppRoutes.PrivacyHandlingScreen.pushNamed(extra: {
            "privacy": old!.hideStatus,
            "title": "Status",
            "subtitle": "Who can see my status updates",
          });
          onChanged!(old.copyWith(statusReplyPermission: newValue));
        }),
  );

  static SettingMetaData<List<String>> blocked_users = SettingMetaData(
      name: "Blocked contacts",
      defaultValue: <String>[],
      widget: (context, {required old, required onChanged}) => ListTile(
          title: const Text("Blocked contacts"),
          subtitle: const Text(
              "Blocked contacts will no longer be able to call you or send you messages"),
          onTap: () {}));

  static final theme_mode = SettingMetaData(
    name: "Theme mode",
    defaultValue: 0,
    widget: (context, {required old, required onChanged}) => ListTile(
        title: const Text("Theme mode"),
        onTap: () {
          onChanged!(old!.copyWith(
              themeMode:
                  old.themeMode.index == 1 ? ThemeMode.dark : ThemeMode.light));
        }),
  );

  static final message_font_size = SettingMetaData(
    name: "Font size",
    defaultValue: 14,
    widget: (context, {required old, required onChanged}) => ListTile(
        title: const Text("Font size"),
        subtitle: const Text("Only message fonts size will effect"),
        onTap: () {}),
  );

  static final message_corners = SettingMetaData(
    name: "Message corners",
    defaultValue: 8,
    widget: (context, {required old, required onChanged}) => ListTile(
        title: const Text("Message corners"),
        subtitle: const Text("Only message corners will effect"),
        onTap: () {}),
  );
  static final message_sound = SettingMetaData(
    name: "Message sound",
    defaultValue: "DEFAULT",
    widget: (context, {required old, required onChanged}) =>
        ListTile(title: const Text("Message sound"), onTap: () {}),
  );
  static final group_sound = SettingMetaData(
    name: "Group Message sound",
    defaultValue: "DEFAULT",
    widget: (context, {required old, required onChanged}) =>
        ListTile(title: const Text("Group Message sound"), onTap: () {}),
  );
  static final auto_download_with_mobile_data = SettingMetaData(
    name: "When using Mobile Data",
    defaultValue: [],
    widget: (context, {required old, required onChanged}) => ListTile(
        title: const Text("When using Mobile Data"),
        subtitle: const Text(
            "Using mobile data, media files are downloaded automatically."),
        onTap: () {}),
  );
  static final auto_download_with_wifi = SettingMetaData(
    name: "When connected to WiFi",
    defaultValue: [],
    widget: (context, {required old, required onChanged}) => ListTile(
        title: const Text("When connected to WiFi"),
        subtitle:
            const Text("When using WiFi, media files automatically download."),
        onTap: () {}),
  );
  static final wifi_upload_quality = SettingMetaData(
    name: "WiFi upload quality",
    defaultValue: "ORIGINAL",
    widget: (context, {required old, required onChanged}) =>
        ListTile(title: const Text("WiFi upload quality"), onTap: () {}),
  );
  static final mobile_data_upload_quality = SettingMetaData(
    name: "Mobile Data upload quality",
    defaultValue: "ORIGINAL",
    widget: (context, {required old, required onChanged}) =>
        ListTile(title: const Text("Mobile Data upload quality"), onTap: () {}),
  );

  static final screenshot_restriction = SettingMetaData(
    name: "Screenshot restriction",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "Screenshot restriction",
      subtitle: "Stop third-party apps from taking screenshots your chats.",
      value: old!.screenshotRestriction,
      onChanged: (bool value) =>
          onChanged!(old.copyWith(screenshotRestriction: value)),
    ),
  );
  static final recording_restriction = SettingMetaData(
    name: "Recording restriction",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "Recording restriction",
      subtitle: "Stop third-party apps to screen-recording your chats.",
      value: old!.recordingRestriction,
      onChanged: (bool value) =>
          onChanged!(old.copyWith(recordingRestriction: value)),
    ),
  );
  static final sync_contacts = SettingMetaData(
    name: "Sync contacts",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "Sync contacts",
      subtitle: "Enabling me to interact with more people from my contact",
      value: old!.syncContacts,
      onChanged: (bool value) => onChanged!(old.copyWith(syncContacts: value)),
    ),
  );
  static final notify_on_credential_change = SettingMetaData(
    name: "Alert on email/number change",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "Alert on email/number change",
      value: old!.notifyOnCredentialChange,
      onChanged: (bool value) =>
          onChanged!(old.copyWith(notifyOnCredentialChange: value)),
    ),
  );

  static final in_app_sound = SettingMetaData(
    name: "In-App sound",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "In-App sound",
      value: old!.inAppSound,
      onChanged: (bool value) => onChanged!(old.copyWith(inAppSound: value)),
    ),
  );

  static final in_app_vibrate = SettingMetaData(
    name: "In-App vibration",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "In-App vibration",
      value: old!.inAppVibrate,
      onChanged: (bool value) => onChanged!(old.copyWith(inAppVibrate: value)),
    ),
  );
  static final group_vibrate_type = SettingMetaData(
    name: "Group vibration",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) =>
        ListTile(title: const Text("Group vibration"), onTap: () {}),
  );

  static SettingMetaData<VibrationType> message_vibrate_type = SettingMetaData(
    name: "Message vibration",
    defaultValue: VibrationType.DEFAULT,
    widget: (context, {required old, required onChanged}) =>
        ListTile(title: const Text("Message vibration"), onTap: () {}),
  );
  static final background_message_notification = SettingMetaData(
    name: "Background message alert",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "Background message alert",
      value: old!.backgroundMessageNotification,
      onChanged: (bool value) =>
          onChanged!(old.copyWith(backgroundMessageNotification: value)),
    ),
  );

  static final background_group_notification = SettingMetaData(
    name: "Background group alert",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "Background group alert",
      value: old!.backgroundGroupNotification,
      onChanged: (bool value) =>
          onChanged!(old.copyWith(backgroundGroupNotification: value)),
    ),
  );

  static final message_reaction_notification = SettingMetaData(
    name: "message_reaction_notification",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "message_reaction_notification",
      subtitle: "Show notifications for reactions to messages you send",
      value: old!.messageReactionNotification,
      onChanged: (bool value) =>
          onChanged!(old.copyWith(messageReactionNotification: value)),
    ),
  );

  static final group_reaction_notification = SettingMetaData(
    name: "group_reaction_alert",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "group_reaction_alert",
      subtitle: "Show notifications for reactions to messages you send",
      value: old!.groupReactionNotification,
      onChanged: (bool value) =>
          onChanged!(old.copyWith(groupReactionNotification: value)),
    ),
  );
  static final in_app_message_notification = SettingMetaData(
    name: "In-App message alert",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "In-App message alert",
      value: old!.inAppMessageNotification,
      onChanged: (bool value) =>
          onChanged!(old.copyWith(inAppMessageNotification: value)),
    ),
  );
  static final in_app_group_notification = SettingMetaData(
    name: "In-App group alert",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => SwitchTile(
      title: "In-App group alert",
      value: old!.inAppGroupNotification,
      onChanged: (bool value) =>
          onChanged!(old.copyWith(inAppGroupNotification: value)),
    ),
  );
  static final app_licence = SettingMetaData(
    name: "App Licence",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => ListTile(
      leading: const Icon(Icons.info_outline_rounded),
      title: const Text("App Licence"),
      subtitle: Text('v${application.versionName}'),
      onTap: () {
        showLicensePage(context: context);
      },
    ),
  );
  static final privacy_policy = SettingMetaData(
    name: "Privacy policy",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => const ListTile(
      leading: Icon(Icons.receipt_long),
      title: Text("Privacy policy"),
    ),
  );
  static final terms_of_service = SettingMetaData(
    name: "Terms of service",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => const ListTile(
      leading: Icon(Icons.policy_outlined),
      title: Text("Terms of service"),
    ),
  );
  static final contact_us = SettingMetaData(
    name: "Contact us",
    defaultValue: false,
    widget: (context, {required old, required onChanged}) => const ListTile(
      leading: Icon(Icons.contact_support_outlined),
      title: Text("Contact us"),
      subtitle: Text('Questions? Need help?'),
    ),
  );

  final String name;
  final A defaultValue;
  final Widget Function(
    BuildContext context, {
    required UserSettings? old,
    required Function(UserSettings)? onChanged,
  }) widget;

  const SettingMetaData({
    required this.name,
    required this.defaultValue,
    required this.widget,
  });

  static List<SettingMetaData> get all => [
        advanced_encryption,
        show_security_notifications,
        hide_credential,
        hide_about,
        hide_profile_img,
        status_reply_permission,
        hide_status,
        blocked_users,
        theme_mode,
        message_font_size,
        message_corners,
        message_sound,
        group_sound,
        auto_download_with_mobile_data,
        auto_download_with_wifi,
        wifi_upload_quality,
        mobile_data_upload_quality,
        screenshot_restriction,
        recording_restriction,
        sync_contacts,
        notify_on_credential_change,
        in_app_sound,
        in_app_vibrate,
        group_vibrate_type,
        message_vibrate_type,
        background_group_notification,
        message_reaction_notification,
        group_reaction_notification,
        in_app_message_notification,
        in_app_group_notification,
        background_message_notification
      ];

  static List<SettingMetaData> get privacy => [
        advanced_encryption,
        hide_credential,
        hide_about,
        hide_profile_img,
        status_reply_permission,
        hide_status,
        blocked_users,
        screenshot_restriction,
        recording_restriction,
        sync_contacts,
      ];

  static List<SettingMetaData> get notification => [
        notify_on_credential_change,
        in_app_sound,
        in_app_vibrate,
        message_sound,
        group_sound,
        group_vibrate_type,
        message_vibrate_type,
        background_group_notification,
        message_reaction_notification,
        group_reaction_notification,
        in_app_message_notification,
        in_app_group_notification,
        background_message_notification,
        show_security_notifications,
      ];

  static List<SettingMetaData> get storage_and_data => [
        wifi_upload_quality,
        mobile_data_upload_quality,
        auto_download_with_mobile_data,
        auto_download_with_wifi,
      ];
  static List<SettingMetaData> get chat_settings => [
        theme_mode,
        message_font_size,
        message_corners,
      ];
  static List<SettingMetaData> get help_center => [
        contact_us,
        privacy_policy,
        terms_of_service,
        app_licence,
      ];
}
