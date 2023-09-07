// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:reConnect/tokens/flutter.credentials.dart';
import 'package:reConnect/utility/routes/app_routes.dart';
import 'widgets/tiles.dart';
import 'package:shared/shared.dart';

class SettingMetaData<A> {
  static get advanced_encryption => SettingMetaData(
        name: "Advanced encryption",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => SwitchTile(
          title: "Advanced encryption",
          subtitle: "Encrypt messages between all users in a chat",
          selectedThumb: const Icon(Icons.lock),
          unSelectedThumb: const Icon(Icons.lock_open),
          value: old!.advancedEncryption,
          onChanged: (bool value) =>
              onChanged!(old.copyWith(advancedEncryption: value)),
        ),
      );

  static get show_security_notifications => SettingMetaData(
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

  static get hide_credential => SettingMetaData(
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

  static get hide_about => SettingMetaData(
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

  static get hide_profile_img => SettingMetaData(
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

  static get status_reply_permission => SettingMetaData(
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

  static get hide_status => SettingMetaData(
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

  static SettingMetaData<List<String>> get blocked_users => SettingMetaData(
      name: "Blocked contacts",
      defaultValue: <String>[],
      widget: (context, {required old, required onChanged}) => ListTile(
          title: const Text("Blocked contacts"),
          subtitle: const Text(
              "Blocked contacts will no longer be able to call you or send you messages"),
          onTap: () {}));

  static get theme_mode => SettingMetaData(
        name: "Theme mode",
        defaultValue: 0,
        widget: (context, {required old, required onChanged}) => SwitchTile(
            title: "Switch Theme mode",
            value: old!.themeMode == ThemeMode.dark,
            subtitle: 'Active theme mode is ${old.themeMode.name}',
            selectedThumb: const Icon(Icons.nights_stay),
            unSelectedThumb: const Icon(Icons.light_mode),
            onChanged: (value) {
              return onChanged!(old.copyWith(
                themeMode: value ? ThemeMode.dark : ThemeMode.light,
              ));
            }),
      );

  static get message_font_size => SettingMetaData(
      name: "Font size",
      defaultValue: 14,
      widget: (context, {required old, required onChanged}) => SliderTile(
            title: "Message Font size (${old!.messageFontSize}px)",
            subtitle: "Only message fonts size will effect",
            max: 20,
            min: 8,
            divisions: 12,
            initalValue: old.messageFontSize.toDouble(),
            onDone: (value) {
              onChanged!(old.copyWith(MessagefontSize: value.toInt()));
            },
          ));

  static get message_corners => SettingMetaData(
        name: "Message corners",
        defaultValue: 8,
        widget: (context, {required old, required onChanged}) => SliderTile(
            max: 10,
            min: 1,
            divisions: 9,
            title: "Message corners (${old!.messageCorners}px)",
            subtitle: "Only message corners will effect",
            initalValue: old.messageCorners.toDouble(),
            onDone: (value) =>
                onChanged!(old.copyWith(messageCorners: value.toInt()))),
      );
  static get message_sound => SettingMetaData(
        name: "Message sound",
        defaultValue: "DEFAULT",
        widget: (context, {required old, required onChanged}) =>
            ListTile(title: const Text("Message sound"), onTap: () {}),
      );
  static get group_sound => SettingMetaData(
        name: "Group Message sound",
        defaultValue: "DEFAULT",
        widget: (context, {required old, required onChanged}) =>
            ListTile(title: const Text("Group Message sound"), onTap: () {}),
      );
  static get auto_download_with_mobile_data => SettingMetaData(
        name: "When using Mobile Data",
        defaultValue: [],
        widget: (context, {required old, required onChanged}) =>
            DialogCheckBoxTile(
          title: "When using Mobile Data",
          subtitle:
              "Using mobile data, media files are downloaded automatically.",
          selected: old!.autoDownloadWithMobileData.map((e) => e.name).toList(),
          list: MediaType.values.map((e) => e.name).toList(),
          onSelected: (p0) => onChanged!(
            old.copyWith(autoDownloadWithMobileData: [
              ...p0.map((e) => MediaType.from(e))
            ]),
          ),
        ),
      );
  static get auto_download_with_wifi => SettingMetaData(
        name: "When connected to WiFi",
        defaultValue: [],
        widget: (context, {required old, required onChanged}) =>
            DialogCheckBoxTile(
          title: "When connected to WiFi",
          subtitle: "When using WiFi, media files automatically download.",
          list: MediaType.values.map((e) => e.name).toList(),
          selected: old!.autoDownloadWithWiFi.map((e) => e.name).toList(),
          onSelected: (p0) => onChanged!(
            old.copyWith(
              autoDownloadWithWiFi: [...p0.map((e) => MediaType.from(e))],
            ),
          ),
        ),
      );
  static get wifi_upload_quality => SettingMetaData(
        name: "WiFi upload quality",
        defaultValue: "ORIGINAL",
        widget: (context, {required old, required onChanged}) => DialogTile(
          title: "WiFi upload quality",
          subtitle: "WiFi upload quality",
          trailing: old!.wiFiUploadQuality.name,
          list: UploadQuality.values.map((e) => e.name).toList(),
          onChanged: (p0) => onChanged!(
            old.copyWith(wiFiUploadQuality: UploadQuality.from(p0)),
          ),
        ),
      );
  static get mobile_data_upload_quality => SettingMetaData(
        name: "Mobile Data upload quality",
        defaultValue: "ORIGINAL",
        widget: (context, {required old, required onChanged}) => DialogTile(
          title: "Mobile Data upload quality",
          subtitle: "Mobile Data upload quality",
          trailing: old!.mobileDataUploadQuality.name,
          list: UploadQuality.values.map((e) => e.name).toList(),
          onChanged: (p0) => onChanged!(
            old.copyWith(mobileDataUploadQuality: UploadQuality.from(p0)),
          ),
        ),
      );

  static get screenshot_restriction => SettingMetaData(
        name: "Screenshot restriction",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => SwitchTile(
          title: "Screenshot restriction",
          subtitle: "Stop third-party apps from taking screenshots your chats.",
          value: old!.screenshotRestriction,
          selectedThumb: const Icon(Icons.visibility_off),
          unSelectedThumb: const Icon(Icons.visibility),
          onChanged: (bool value) =>
              onChanged!(old.copyWith(screenshotRestriction: value)),
        ),
      );
  static get recording_restriction => SettingMetaData(
        name: "Recording restriction",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => SwitchTile(
          title: "Recording restriction",
          subtitle: "Stop third-party apps to screen-recording your chats.",
          selectedThumb: const Icon(Icons.visibility_off),
          unSelectedThumb: const Icon(Icons.visibility),
          value: old!.recordingRestriction,
          onChanged: (bool value) =>
              onChanged!(old.copyWith(recordingRestriction: value)),
        ),
      );
  static get sync_contacts => SettingMetaData(
        name: "Sync contacts",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => SwitchTile(
          title: "Sync contacts",
          subtitle: "Enabling me to interact with more people from my contact",
          value: old!.syncContacts,
          onChanged: (bool value) =>
              onChanged!(old.copyWith(syncContacts: value)),
        ),
      );
  static get notify_on_credential_change => SettingMetaData(
        name: "Alert on email/number change",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => SwitchTile(
          title: "Alert on email/number change",
          value: old!.notifyOnCredentialChange,
          onChanged: (bool value) =>
              onChanged!(old.copyWith(notifyOnCredentialChange: value)),
        ),
      );

  static get in_app_sound => SettingMetaData(
        name: "In-App sound",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => SwitchTile(
          title: "In-App sound",
          value: old!.inAppSound,
          onChanged: (bool value) =>
              onChanged!(old.copyWith(inAppSound: value)),
        ),
      );

  static get in_app_vibrate => SettingMetaData(
        name: "In-App vibration",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => SwitchTile(
          title: "In-App vibration",
          subtitle: "In-App vibration",
          value: old!.inAppVibrate,
          onChanged: (bool value) =>
              onChanged!(old.copyWith(inAppVibrate: value)),
        ),
      );
  static get group_vibrate_type => SettingMetaData(
        name: "Group vibration",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => DialogTile(
          title: "Group vibration",
          subtitle: "Group vibration",
          trailing: old!.groupVibrateType.name,
          list: VibrationType.values.map((e) => e.name).toList(),
          onChanged: (p0) => onChanged!(
            old.copyWith(groupVibrateType: VibrationType.from(p0)),
          ),
        ),
      );

  static SettingMetaData<VibrationType> get message_vibrate_type =>
      SettingMetaData(
        name: "Message vibration",
        defaultValue: VibrationType.DEFAULT,
        widget: (context, {required old, required onChanged}) => DialogTile(
          title: "Message vibration",
          subtitle: "Message vibration",
          trailing: old!.messageVibrateType.name,
          list: VibrationType.values.map((e) => e.name).toList(),
          onChanged: (p0) => onChanged!(old.copyWith(
            messageVibrateType: VibrationType.from(p0),
          )),
        ),
      );
  static get background_message_notification => SettingMetaData(
        name: "Background message alert",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => SwitchTile(
          title: "Background message alert",
          value: old!.backgroundMessageNotification,
          onChanged: (bool value) =>
              onChanged!(old.copyWith(backgroundMessageNotification: value)),
        ),
      );

  static get background_group_notification => SettingMetaData(
        name: "Background group alert",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => SwitchTile(
          title: "Background group alert",
          value: old!.backgroundGroupNotification,
          onChanged: (bool value) =>
              onChanged!(old.copyWith(backgroundGroupNotification: value)),
        ),
      );

  static get message_reaction_notification => SettingMetaData(
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

  static get group_reaction_notification => SettingMetaData(
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
  static get in_app_message_notification => SettingMetaData(
        name: "In-App message alert",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => SwitchTile(
          title: "In-App message alert",
          value: old!.inAppMessageNotification,
          onChanged: (bool value) =>
              onChanged!(old.copyWith(inAppMessageNotification: value)),
        ),
      );
  static get in_app_group_notification => SettingMetaData(
        name: "In-App group alert",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => SwitchTile(
          title: "In-App group alert",
          value: old!.inAppGroupNotification,
          onChanged: (bool value) =>
              onChanged!(old.copyWith(inAppGroupNotification: value)),
        ),
      );
  static get app_licence => SettingMetaData(
        name: "App Licence",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => ListTile(
          leading: const Icon(Icons.info_outline_rounded),
          title: const Text("App Licence"),
          subtitle: Text('v${application.versionName}'),
          onTap: () {
            showLicensePage(
              context: context,
              applicationName: application.name,
              applicationVersion: 'v${application.versionName}',
              applicationLegalese:'Developed by Rahul Sharma' 
            );
          },
        ),
      );
  static get privacy_policy => SettingMetaData(
        name: "Privacy policy",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => const ListTile(
          leading: Icon(Icons.receipt_long),
          title: Text("Privacy policy"),
        ),
      );
  static get terms_of_service => SettingMetaData(
        name: "Terms of service",
        defaultValue: false,
        widget: (context, {required old, required onChanged}) => const ListTile(
          leading: Icon(Icons.policy_outlined),
          title: Text("Terms of service"),
        ),
      );
  static get contact_us => SettingMetaData(
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
