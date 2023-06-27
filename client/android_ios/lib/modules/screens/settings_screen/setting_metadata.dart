// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:reConnect/utility/navigation/app_navigator.dart';
import 'package:reConnect/utility/routes/app_router.dart';
import 'widgets/tiles.dart';
import 'package:shared/enums/basic.dart';
import 'package:shared/models/user.dart';

class SettingMetaData<A> {
  static SettingMetaData<bool> get advanced_encryption => SettingMetaData(
        name: "Advanced encryption",
        about: "Encrypt messages between all users in a chat",
        identifier: "advanced_encryption",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: advanced_encryption.name,
          subtitle: advanced_encryption.about,
          value: old.advancedEncryption,
          onChanged: (bool value) =>
              onTap(old.copyWith(advancedEncryption: value)),
        ),
      );

  static SettingMetaData<bool> get show_security_notifications =>
      SettingMetaData(
        name: "Security notifications",
        about: "Get notified when some one try to access your account.",
        identifier: "show_security_notifications",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: show_security_notifications.name,
          subtitle: show_security_notifications.about,
          value: old.showSecurityNotifications,
          onChanged: (bool value) =>
              onTap(old.copyWith(showSecurityNotifications: value)),
        ),
      );

  static SettingMetaData<Privacy> get hide_credential => SettingMetaData(
        name: "Phone no. or Email",
        about: "Who can see my Phone number or Email",
        identifier: "hide_phone_number",
        defaultValue: Privacy(),
        widget: (old, onTap) => DisplayTile(
            title: hide_credential.name,
            subtitle: hide_credential.about,
            onTap: () => AppNavigator.on((router) async {
                  final newValue = await router.pushNamed<Privacy>(
                      AppRoutes.PrivacyHandlingScreen.name,
                      extra: {
                        "privacy": old.hideCredential,
                        "title": hide_credential.name,
                        "subtitle": hide_credential.about,
                      });
                  onTap(old.copyWith(hidePhoneNumber: newValue));
                })),
      );

  static get hide_about => SettingMetaData(
        name: "About",
        about: "Who can see my About",
        identifier: "hide_about",
        defaultValue: Privacy(),
        widget: (old, onTap) => DisplayTile(
            title: hide_about.name,
            subtitle: hide_about.about,
            onTap: () => AppNavigator.on((router) async {
                  final newValue = await router.pushNamed<Privacy>(
                      AppRoutes.PrivacyHandlingScreen.name,
                      extra: {
                        "privacy": old.hideAbout,
                        "title": hide_about.name,
                        "subtitle": hide_about.about,
                      });
                  onTap(old.copyWith(hidePhoneNumber: newValue));
                })),
      );

  static get hide_profile_img => SettingMetaData(
        name: "Profile photo",
        about: "Who can see my Profile Photo",
        identifier: "hide_profile_img",
        defaultValue: Privacy(),
        widget: (old, onTap) => DisplayTile(
            title: hide_profile_img.name,
            subtitle: hide_profile_img.about,
            onTap: () => AppNavigator.on((router) async {
                  final newValue = await router.pushNamed<Privacy>(
                      AppRoutes.PrivacyHandlingScreen.name,
                      extra: {
                        "privacy": old.hideProfileImg,
                        "title": hide_profile_img.name,
                        "subtitle": hide_profile_img.about,
                      });
                  onTap(old.copyWith(hideProfileImg: newValue));
                })),
      );

  static get status_reply_permission => SettingMetaData(
        name: "Status Reply Permission",
        about: "Who can reply on my status",
        identifier: "status_reply_permission",
        defaultValue: Privacy(),
        widget: (old, onTap) => DisplayTile(
            title: status_reply_permission.name,
            subtitle: status_reply_permission.about,
            onTap: () => AppNavigator.on((router) async {
                  final newValue = await router.pushNamed<Privacy>(
                      AppRoutes.PrivacyHandlingScreen.name,
                      extra: {
                        "privacy": old.statusReplyPermission,
                        "title": status_reply_permission.name,
                        "subtitle": status_reply_permission.about,
                      });
                  onTap(old.copyWith(statusReplyPermission: newValue));
                })),
      );

  static get hide_status => SettingMetaData(
        name: "Status",
        about: "Who can see my status updates",
        identifier: "hide_status",
        defaultValue: Privacy(),
        widget: (old, onTap) => DisplayTile(
            title: hide_status.name,
            subtitle: hide_status.about,
            onTap: () => AppNavigator.on((router) async {
                  final newValue = await router.pushNamed<Privacy>(
                      AppRoutes.PrivacyHandlingScreen.name,
                      extra: {
                        "privacy": old.hideStatus,
                        "title": hide_status.name,
                        "subtitle": hide_status.about,
                      });
                  onTap(old.copyWith(statusReplyPermission: newValue));
                })),
      );

  static get blocked_users => SettingMetaData(
      name: "Blocked contacts",
      about:
          "Blocked contacts will no longer be able to call you or send you messages",
      identifier: "blocked_users",
      defaultValue: <String>[],
      widget: (old, onTap) => DisplayTile(
          title: blocked_users.name,
          subtitle: blocked_users.about,
          onTap: null));

  static get theme_mode => SettingMetaData(
        name: "Theme mode",
        identifier: "theme_mode",
        defaultValue: 0,
        widget: (old, onTap) => DisplayTile(
            title: theme_mode.name,
            subtitle: theme_mode.about,
            onTap: () {
              onTap(old.copyWith(
                  themeMode: old.themeMode.index == 1
                      ? ThemeMode.dark
                      : ThemeMode.light));
            }),
      );

  static get message_font_size => SettingMetaData(
        name: "Font size",
        about: "Only message fonts size will effect",
        identifier: "message_font_size",
        defaultValue: 14,
        widget: (old, onTap) => DisplayTile(
            title: message_font_size.name,
            subtitle: message_font_size.about,
            onTap: null),
      );

  static get message_corners => SettingMetaData(
        name: "Message corners",
        about: "Only message corners will effect",
        identifier: "message_corners",
        defaultValue: 8,
        widget: (old, onTap) => DisplayTile(
            title: message_corners.name,
            subtitle: message_corners.about,
            onTap: null),
      );
  static get message_sound => SettingMetaData(
        name: "Message sound",
        identifier: "message_sound",
        defaultValue: "DEFAULT",
        widget: (old, onTap) => DisplayTile(
            title: message_sound.name,
            subtitle: message_sound.about,
            onTap: null),
      );
  static get group_sound => SettingMetaData(
        name: "Group Message sound",
        identifier: "group_sound",
        defaultValue: "DEFAULT",
        widget: (old, onTap) => DisplayTile(
            title: group_sound.name, subtitle: group_sound.about, onTap: null),
      );
  static get auto_download_with_mobile_data => SettingMetaData(
        name: "When using Mobile Data",
        about: "Using mobile data, media files are downloaded automatically.",
        identifier: "auto_download_with_mobile_data",
        defaultValue: [],
        widget: (old, onTap) => DisplayTile(
            title: auto_download_with_mobile_data.name,
            subtitle: auto_download_with_mobile_data.about,
            onTap: null),
      );
  static get auto_download_with_wifi => SettingMetaData(
        name: "When connected to WiFi",
        about: "When using WiFi, media files automatically download.",
        identifier: "auto_download_with_wifi",
        defaultValue: [],
        widget: (old, onTap) => DisplayTile(
            title: auto_download_with_wifi.name,
            subtitle: auto_download_with_wifi.about,
            onTap: null),
      );
  static get wifi_upload_quality => SettingMetaData(
        name: "WiFi upload quality",
        identifier: "wifi_upload_quality",
        defaultValue: "ORIGINAL",
        widget: (old, onTap) => DisplayTile(
            title: wifi_upload_quality.name,
            subtitle: wifi_upload_quality.about,
            onTap: null),
      );
  static get mobile_data_upload_quality => SettingMetaData(
        name: "Mobile Data upload quality",
        identifier: "mobile_data_upload_quality",
        defaultValue: "ORIGINAL",
        widget: (old, onTap) => DisplayTile(
            title: mobile_data_upload_quality.name,
            subtitle: mobile_data_upload_quality.about,
            onTap: null),
      );

  static get screenshot_restriction => SettingMetaData(
        name: "Screenshot restriction",
        about: "Stop third-party apps from taking screenshots your chats.",
        identifier: "screenshot_restriction",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: screenshot_restriction.name,
          subtitle: screenshot_restriction.about,
          value: old.screenshotRestriction,
          onChanged: (bool value) =>
              onTap(old.copyWith(screenshotRestriction: value)),
        ),
      );
  static get recording_restriction => SettingMetaData(
        name: "Recording restriction",
        about: "Stop third-party apps to screen-recording your chats.",
        identifier: "recording_restriction",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: recording_restriction.name,
          subtitle: recording_restriction.about,
          value: old.recordingRestriction,
          onChanged: (bool value) =>
              onTap(old.copyWith(recordingRestriction: value)),
        ),
      );
  static SettingMetaData<bool> get sync_contacts => SettingMetaData(
        name: "Sync contacts",
        identifier: "sync_contacts",
        about: "Enabling me to interact with more people from my contact",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: sync_contacts.name,
          subtitle: sync_contacts.about,
          value: old.syncContacts,
          onChanged: (bool value) => onTap(old.copyWith(syncContacts: value)),
        ),
      );
  static SettingMetaData<bool> get notify_on_credential_change =>
      SettingMetaData(
        name: "Alert on email/number change",
        identifier: "notify_on_credential_change",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: notify_on_credential_change.name,
          subtitle: notify_on_credential_change.about,
          value: old.notifyOnCredentialChange,
          onChanged: (bool value) =>
              onTap(old.copyWith(notifyOnCredentialChange: value)),
        ),
      );

  static SettingMetaData<bool> get in_app_sound => SettingMetaData(
        name: "In-App sound",
        identifier: "in_app_sound",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: in_app_sound.name,
          subtitle: in_app_sound.about,
          value: old.inAppSound,
          onChanged: (bool value) => onTap(old.copyWith(inAppSound: value)),
        ),
      );

  static SettingMetaData<bool> get in_app_vibrate => SettingMetaData(
        name: "In-App vibration",
        identifier: "in_app_vibrate",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: in_app_vibrate.name,
          subtitle: in_app_vibrate.about,
          value: old.inAppVibrate,
          onChanged: (bool value) => onTap(old.copyWith(inAppVibrate: value)),
        ),
      );
  static get group_vibrate_type => SettingMetaData(
        name: "Group vibration",
        identifier: "group_vibrate_type",
        defaultValue: false,
        widget: (old, onTap) => DisplayTile(
            title: group_vibrate_type.name,
            subtitle: group_vibrate_type.about,
            onTap: null),
      );

  static get message_vibrate_type => SettingMetaData(
        name: "Message vibration",
        identifier: "message_vibrate_type",
        defaultValue: VibrationType.DEFAULT,
        widget: (old, onTap) => DisplayTile(
            title: message_vibrate_type.name,
            subtitle: message_vibrate_type.about,
            onTap: null),
      );
  static SettingMetaData<bool> get background_message_notification =>
      SettingMetaData(
        name: "Background message alert",
        identifier: "background_message_notification",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: background_message_notification.name,
          subtitle: background_message_notification.about,
          value: old.backgroundMessageNotification,
          onChanged: (bool value) =>
              onTap(old.copyWith(backgroundMessageNotification: value)),
        ),
      );

  static SettingMetaData<bool> get background_group_notification =>
      SettingMetaData(
        name: "Background group alert",
        identifier: "background_group_notification",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: background_group_notification.name,
          subtitle: background_group_notification.about,
          value: old.backgroundGroupNotification,
          onChanged: (bool value) =>
              onTap(old.copyWith(backgroundGroupNotification: value)),
        ),
      );

  static SettingMetaData<bool> get message_reaction_notification =>
      SettingMetaData(
        name: "message_reaction_notification",
        identifier: "message_reaction_notification",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: message_reaction_notification.name,
          subtitle: message_reaction_notification.about,
          value: old.messageReactionNotification,
          onChanged: (bool value) =>
              onTap(old.copyWith(messageReactionNotification: value)),
        ),
      );

  static SettingMetaData<bool> get group_reaction_notification =>
      SettingMetaData(
        name: "group_reaction_alert",
        identifier: "group_reaction_notification",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: group_reaction_notification.name,
          subtitle: group_reaction_notification.about,
          value: old.groupReactionNotification,
          onChanged: (bool value) =>
              onTap(old.copyWith(groupReactionNotification: value)),
        ),
      );
  static SettingMetaData<bool> get in_app_message_notification =>
      SettingMetaData(
        name: "In-App message alert",
        identifier: "in_app_message_notification",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: in_app_message_notification.name,
          subtitle: in_app_message_notification.about,
          value: old.inAppMessageNotification,
          onChanged: (bool value) =>
              onTap(old.copyWith(inAppMessageNotification: value)),
        ),
      );
  static SettingMetaData<bool> get in_app_group_notification => SettingMetaData(
        name: "In-App group alert",
        identifier: "in_app_group_notification",
        defaultValue: false,
        widget: (old, onTap) => SwitchTile(
          title: in_app_group_notification.name,
          subtitle: in_app_group_notification.about,
          value: old.inAppGroupNotification,
          onChanged: (bool value) =>
              onTap(old.copyWith(inAppGroupNotification: value)),
        ),
      );

  final String name;
  final String? about;
  final String identifier;
  final A defaultValue;
  final Widget Function(UserSettings old, Function(UserSettings) onTap) widget;

  const SettingMetaData(
      {required this.name,
      this.about,
      required this.identifier,
      required this.defaultValue,
      required this.widget});

  Map<String, dynamic> get toJson => {
        "name": name,
        "about": about,
        "identifier": identifier,
        "default_value": defaultValue,
      };

  static List<SettingMetaData> get list => [
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
        background_message_notification,
        background_group_notification,
        message_reaction_notification,
        group_reaction_notification,
        in_app_message_notification,
        in_app_group_notification
      ];
  // static SettingMetaData from(String type) =>
  //     SettingMetaData.values.firstWhere((e) => e.name == type);
}
