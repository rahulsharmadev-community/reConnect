import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/_models.dart';
import 'package:shared/models/bloc_utils/basic_bloc_data.dart';
import '../extensions/_extenstions.dart';
import 'package:uuid/uuid.dart';
import '../enums/basic.dart';

class LogInUser extends Equatable {
  LogInUser({
    String? userId,
    required String name,
    required this.deviceInfo,
    String? email,
    String? phoneNumber,
    String? about,
    this.status,
    UserSettings? settings,
    DateTime? joinAt,
    DateTime? lastActiveAt,
    String? profileImg,
    List<String> chatRooms = const [],
  })  : assert(!(name.isEmpty), 'name should not be empty.'),
        assert(!(email == null && phoneNumber == null),
            'email or phoneNumber should not be empty.'),
        userId = userId ?? const Uuid().v4(),
        name = BlocData.idle(name),
        email = BlocData.idle(email),
        phoneNumber = BlocData.idle(phoneNumber),
        about = BlocData.idle(about),
        settings = UserSettings(),
        joinAt = joinAt ?? DateTime.now(),
        profileImg = BlocData.idle(profileImg),
        chatRooms = BlocData.idle(chatRooms),
        lastActiveAt = BlocData.idle(lastActiveAt ?? DateTime.now());

  LogInUser.raw({
    required this.userId,
    required this.name,
    required this.deviceInfo,
    required this.email,
    required this.phoneNumber,
    required this.about,
    required this.status,
    required this.settings,
    required this.joinAt,
    required this.lastActiveAt,
    required this.profileImg,
    required this.chatRooms,
  })  : assert(!(!name.hasData && name.data!.isEmpty),
            'name should not be empty.'),
        assert(!(!email.hasData && !phoneNumber.hasData),
            'email or phoneNumber should not be empty.');

  final String userId;
  final DeviceInfo deviceInfo;
  final BlocData<String> name;
  final BlocData<String> email;
  final BlocData<String> phoneNumber;
  final BlocData<String> about;
  final BlocData<String> profileImg;
  final BlocData<List<String>> chatRooms;
  final BlocData<DateTime> lastActiveAt;
  final List<Status>? status;
  final UserSettings settings;
  final DateTime joinAt;

  LogInUser copyWith({
    String? userId,
    DeviceInfo? deviceInfo,
    BlocData<String>? name,
    BlocData<String>? email,
    BlocData<String>? phoneNumber,
    BlocData<String>? about,
    BlocData<String>? profileImg,
    BlocData<List<String>>? chatRooms,
    BlocData<DateTime>? lastActiveAt,
    List<Status>? status,
    UserSettings? settings,
    DateTime? joinAt,
  }) =>
      LogInUser.raw(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        deviceInfo: deviceInfo ?? this.deviceInfo,
        about: about ?? this.about,
        status: status ?? this.status,
        profileImg: profileImg ?? this.profileImg,
        lastActiveAt: lastActiveAt ?? this.lastActiveAt,
        chatRooms: chatRooms ?? this.chatRooms,
        settings: settings ?? this.settings,
        joinAt: joinAt ?? this.joinAt,
      );

  factory LogInUser.fromMap(Map<String, dynamic> json) => LogInUser(
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        deviceInfo: DeviceInfo.fromMap(json["device_info"]),
        phoneNumber: json["phone_number"],
        about: json["about"],
        status: List<Status>.from(
            json["status"] ?? [].map((x) => Status.fromMap(x))),
        profileImg: json["profile_img"],
        lastActiveAt: json["last_active_at"],
        joinAt: DateTime.fromMillisecondsSinceEpoch(json["join_at"]),
        chatRooms: List<String>.from(json["chat_rooms"] ?? [].map((x) => x)),
        settings: UserSettings.fromMap(json["settings"]),
      );

  Map<String, dynamic> get toMap => {
        "user_id": userId,
        "name": name.data,
        "device_info": deviceInfo.toJson,
        "phone_number": phoneNumber.data,
        if (!email.hasData) "email": email.data,
        if (!about.hasData) "about": about.data,
        if (status != null)
          "status": List<Status>.from(status ?? [].map((x) => x.toMap())),
        if (!profileImg.hasData) "profile_img": profileImg.data,
        "last_active_at": lastActiveAt.data?.millisecondsSinceEpoch,
        "join_at": joinAt.millisecondsSinceEpoch,
        "chat_rooms": List<String>.from(chatRooms.data ?? [].map((x) => x)),
        "settings": settings.toMap(),
      };

  @override
  List<Object?> get props => [
        userId,
        deviceInfo.toJson,
        name.toMap,
        email.toMap,
        phoneNumber.toMap,
        about.toMap,
        profileImg.toMap,
        lastActiveAt.toMap,
        chatRooms.toMap,
        status,
        joinAt,
        settings
      ];
}

class UserSettings extends Equatable {
  UserSettings(
      {this.theme = 'DEFAULT',
      this.themeMode = ThemeMode.system,
      this.MessagefontSize = 14,
      this.messageCorners = 7,
      this.advancedEncryption = false,
      Privacy? statusReplyPermission,
      Privacy? hideStatus,
      Privacy? hideProfileImg,
      Privacy? hideCredential,
      Privacy? hideAbout,
      this.blockedUsers,
      this.screenshotRestriction = false,
      this.recordingRestriction = false,
      this.syncContacts = true,
      this.notifyOnCredentialChange = true,
      this.inAppSound = false,
      this.inAppVibrate = false,
      this.backgroundMessageNotification = false,
      this.backgroundGroupNotification = false,
      this.messageReactionNotification = false,
      this.groupReactionNotification = false,
      this.inAppMessageNotification = false,
      this.inAppGroupNotification = false,
      this.messageSound = 'DEFAULT',
      this.groupSound = 'DEFAULT',
      this.messageVibrateType = VibrationType.DEFAULT,
      this.groupVibrateType = VibrationType.DEFAULT,
      this.showSecurityNotifications = false,
      this.autoDownloadWithMobileData = const [],
      this.autoDownloadWithWiFi = const [],
      this.wiFiUploadQuality = UploadQuality.ORIGINAL,
      this.mobileDataUploadQuality = UploadQuality.ORIGINAL})
      : assert((0 < messageCorners && messageCorners < 11),
            'Message corners should be greater then 0 & less then 11, 0<messageCorners<11'),
        assert((7 < MessagefontSize && messageCorners < 29),
            'FontSize should be greater then 7 & less then 29, 0<fontSize<29'),
        statusReplyPermission = statusReplyPermission ?? Privacy(),
        hideStatus = hideStatus ?? Privacy(),
        hideProfileImg = hideProfileImg ?? Privacy(),
        hideCredential = hideCredential ?? Privacy(),
        hideAbout = hideAbout ?? Privacy();

  final String theme;
  final ThemeMode themeMode;
  final int MessagefontSize;
  final int messageCorners;
  final bool advancedEncryption;
  final Privacy statusReplyPermission;
  final Privacy hideStatus;
  final List<String>? blockedUsers;
  final bool screenshotRestriction;
  final bool recordingRestriction;
  final bool syncContacts;

// Profile Privacy
  final Privacy hideProfileImg;
  final Privacy hideCredential;
  final Privacy hideAbout;

  /// Alert on email/number change
  final bool notifyOnCredentialChange;
  final bool inAppSound;
  final bool inAppVibrate;
  final bool backgroundMessageNotification;
  final bool backgroundGroupNotification;
  final bool messageReactionNotification;
  final bool groupReactionNotification;
  final bool inAppMessageNotification;
  final bool inAppGroupNotification;
  final String messageSound;
  final String groupSound;
  final VibrationType messageVibrateType;
  final VibrationType groupVibrateType;
  final bool showSecurityNotifications;
  final List<MediaType> autoDownloadWithMobileData;
  final List<MediaType> autoDownloadWithWiFi;
  final UploadQuality wiFiUploadQuality;
  final UploadQuality mobileDataUploadQuality;

  UserSettings copyWith(
          {String? theme,
          ThemeMode? themeMode,
          int? MessagefontSize,
          int? messageCorners,
          List<MediaType>? autoDownloadWithMobileData,
          List<MediaType>? autoDownloadWithWiFi,
          UploadQuality? wiFiUploadQuality,
          UploadQuality? mobileDataUploadQuality,
          bool? inAppSound,
          bool? inAppVibrate,
          bool? backgroundMessageNotification,
          bool? backgroundGroupNotification,
          bool? messageReactionNotification,
          bool? groupReactionNotification,
          bool? inAppMessageNotification,
          bool? inAppGroupNotification,
          String? messageSound,
          String? groupSound,
          VibrationType? messageVibrateType,
          VibrationType? groupVibrateType,
          bool? showSecurityNotifications,
          bool? advancedEncryption,
          Privacy? statusReplyPermission,
          Privacy? hideStatus,
          List<String>? blockedUsers,
          bool? screenshotRestriction,
          bool? recordingRestriction,
          bool? syncContacts,
          bool? notifyOnCredentialChange,
          Privacy? hideProfileImg,
          Privacy? hidePhoneNumber,
          Privacy? hideAbout}) =>
      UserSettings(
        theme: theme ?? this.theme,
        themeMode: themeMode ?? this.themeMode,
        MessagefontSize: MessagefontSize ?? this.MessagefontSize,
        messageCorners: messageCorners ?? this.messageCorners,
        autoDownloadWithMobileData:
            autoDownloadWithMobileData ?? this.autoDownloadWithMobileData,
        autoDownloadWithWiFi: autoDownloadWithWiFi ?? this.autoDownloadWithWiFi,
        wiFiUploadQuality: wiFiUploadQuality ?? this.wiFiUploadQuality,
        mobileDataUploadQuality:
            mobileDataUploadQuality ?? this.mobileDataUploadQuality,
        inAppSound: inAppSound ?? this.inAppSound,
        inAppVibrate: inAppVibrate ?? this.inAppVibrate,
        backgroundMessageNotification:
            backgroundMessageNotification ?? this.backgroundMessageNotification,
        backgroundGroupNotification:
            backgroundGroupNotification ?? this.backgroundGroupNotification,
        messageReactionNotification:
            messageReactionNotification ?? this.messageReactionNotification,
        groupReactionNotification:
            groupReactionNotification ?? this.groupReactionNotification,
        inAppMessageNotification:
            inAppMessageNotification ?? this.inAppMessageNotification,
        inAppGroupNotification:
            inAppGroupNotification ?? this.inAppGroupNotification,
        messageSound: messageSound ?? this.messageSound,
        groupSound: groupSound ?? this.groupSound,
        messageVibrateType: messageVibrateType ?? this.messageVibrateType,
        groupVibrateType: groupVibrateType ?? this.groupVibrateType,
        showSecurityNotifications:
            showSecurityNotifications ?? this.showSecurityNotifications,
        advancedEncryption: advancedEncryption ?? this.advancedEncryption,
        statusReplyPermission:
            statusReplyPermission ?? this.statusReplyPermission,
        hideStatus: hideStatus ?? this.hideStatus,
        hideProfileImg: hideProfileImg ?? hideProfileImg,
        hideCredential: hidePhoneNumber ?? hidePhoneNumber,
        hideAbout: hideAbout ?? hideAbout,
        blockedUsers: blockedUsers ?? this.blockedUsers,
        screenshotRestriction:
            screenshotRestriction ?? this.screenshotRestriction,
        recordingRestriction: recordingRestriction ?? this.recordingRestriction,
        syncContacts: syncContacts ?? this.syncContacts,
        notifyOnCredentialChange:
            notifyOnCredentialChange ?? this.notifyOnCredentialChange,
      );

  factory UserSettings.fromMap(Map<String, dynamic> json) => UserSettings(
        theme: json["theme"],
        themeMode: ThemeMode.values[json["theme_mode"]],
        MessagefontSize: json["message_font_size"],
        messageCorners: json["message_corners"],
        autoDownloadWithMobileData:
            List.from(json["auto_download_with_mobile_data"] ?? [])
                .map((e) => MediaType.from(e))
                .toList(),
        autoDownloadWithWiFi: List.from(json["auto_download_with_wifi"] ?? [])
            .map((e) => MediaType.from(e))
            .toList(),
        wiFiUploadQuality: UploadQuality.from(json["wifi_upload_quality"]),
        mobileDataUploadQuality:
            UploadQuality.from(json["mobile_data_upload_quality"]),
        inAppSound: json["in_app_sound"],
        inAppVibrate: json["in_app_vibrate"],
        backgroundMessageNotification: json["background_message_notification"],
        backgroundGroupNotification: json["background_group_notification"],
        messageReactionNotification: json["message_reaction_notification"],
        groupReactionNotification: json["group_reaction_notification"],
        inAppMessageNotification: json["in_app_message_notification"],
        inAppGroupNotification: json["in_app_group_notification"],
        messageSound: json["message_sound"],
        groupSound: json["group_sound"],
        messageVibrateType:
            VibrationType.values.byName(json["message_vibrate_type"]),
        groupVibrateType:
            VibrationType.values.byName(json["group_vibrate_type"]),
        showSecurityNotifications: json["show_security_notifications"],
        advancedEncryption: json["advanced_encryption"],
        statusReplyPermission: Privacy.fromMap(json["status_reply_permission"]),
        hideStatus: Privacy.fromMap(json["hide_status"]),
        hideProfileImg: Privacy.fromMap(json['hide_profile_img']),
        hideCredential: Privacy.fromMap(json['hide_credential']),
        hideAbout: Privacy.fromMap(json["hide_about"]),
        blockedUsers:
            List<String>.from(json["blocked_users"] ?? [].map((x) => x)),
        screenshotRestriction: json["screenshot_restriction"],
        recordingRestriction: json["recording_restriction"],
        syncContacts: json["sync_contacts"],
        notifyOnCredentialChange: json["notify_on_credential_change"],
      );

  Map<String, dynamic> toMap() => {
        "theme": theme,
        "theme_mode": themeMode.index,
        "message_font_size": MessagefontSize,
        "message_corners": messageCorners,
        "auto_download_with_mobile_data":
            autoDownloadWithMobileData.map((e) => e.name).toList(),
        "auto_download_with_wifi":
            autoDownloadWithWiFi.map((e) => e.name).toList(),
        "wifi_upload_quality": wiFiUploadQuality.name,
        "mobile_data_upload_quality": mobileDataUploadQuality.name,
        "in_app_sound": inAppSound,
        "in_app_vibrate": inAppVibrate,
        "background_message_notification": backgroundMessageNotification,
        "background_group_notification": backgroundGroupNotification,
        "message_reaction_notification": messageReactionNotification,
        "group_reaction_notification": groupReactionNotification,
        "in_app_message_notification": inAppMessageNotification,
        "in_app_group_notification": inAppGroupNotification,
        "message_sound": messageSound,
        "group_sound": groupSound,
        "message_vibrate_type": messageVibrateType.name,
        "group_vibrate_type": groupVibrateType.name,
        "show_security_notifications": showSecurityNotifications,
        "advanced_encryption": advancedEncryption,
        "blocked_users": blockedUsers,
        "screenshot_restriction": screenshotRestriction,
        "recording_restriction": recordingRestriction,
        "sync_contacts": syncContacts,
        "notify_on_credential_change": notifyOnCredentialChange,
        "status_reply_permission": statusReplyPermission.toMap,
        "hide_status": hideStatus.toMap,
        "hide_profile_img": hideProfileImg.toMap,
        "hide_credential": hideCredential.toMap,
        "hide_about": hideAbout.toMap
      };

  @override
  List<Object?> get props => [
        theme,
        themeMode,
        MessagefontSize,
        messageCorners,
        autoDownloadWithMobileData,
        autoDownloadWithWiFi,
        wiFiUploadQuality,
        mobileDataUploadQuality,
        inAppSound,
        inAppVibrate,
        backgroundMessageNotification,
        backgroundGroupNotification,
        messageReactionNotification,
        groupReactionNotification,
        inAppGroupNotification,
        inAppGroupNotification,
        messageSound,
        groupSound,
        messageVibrateType,
        groupVibrateType,
        showSecurityNotifications,
        advancedEncryption,
        statusReplyPermission,
        hideStatus,
        hideProfileImg.toMap,
        hideCredential.toMap,
        hideAbout.toMap,
        blockedUsers,
        screenshotRestriction,
        recordingRestriction,
        syncContacts,
        notifyOnCredentialChange
      ];
}

/// Helper class
class Privacy {
  final PrivacyType type;
  // List of Users
  final List<String> except;
  final List<String> only;
  Privacy(
      {this.type = PrivacyType.everybody,
      this.except = const [],
      this.only = const []})
      : assert(!(type == PrivacyType.except && except.isEmpty),
            'PrivacyType.except'),
        assert(!(type == PrivacyType.only && only.isEmpty), 'PrivacyType.only');

  Privacy copyWith({
    PrivacyType? type,
    List<String>? except,
    List<String>? only,
  }) =>
      Privacy(
          type: type ?? this.type,
          except: except ?? this.except,
          only: only ?? this.only);

  factory Privacy.fromMap(Map<String, dynamic> map) => Privacy(
      type: PrivacyType.values.byName(map['type']),
      except: List<String>.from(map['except']),
      only: List<String>.from(map['only']));

  Map<String, dynamic> get toMap =>
      {"type": type.name, "except": except, "only": only};
}

class Status extends Equatable {
  Status({
    String? id,
    this.text,
    this.image,
    this.caption,
    Color? color,
    DateTime? expireAt,
    DateTime? createAt,
  })  : assert(!(text != null && image != null),
            'Only one option from text or image should be used.'),
        id = id ?? const Uuid().v4(),
        color = color ?? '#096e92'.toColor,
        createAt = createAt ?? DateTime.now(),
        expireAt = expireAt ?? DateTime.now() + 24.hours;

  final String id;
  final String? text;
  final String? image;
  final String? caption;
  final Color color;
  final DateTime expireAt;
  final DateTime createAt;

  Status copyWith({
    String? id,
    String? text,
    String? image,
    String? caption,
    Color? color,
    DateTime? expireAt,
    DateTime? createAt,
  }) =>
      Status(
        id: id ?? this.id,
        text: text ?? this.text,
        image: image ?? this.image,
        caption: caption ?? this.caption,
        color: color ?? this.color,
        expireAt: expireAt ?? this.expireAt,
        createAt: createAt ?? this.createAt,
      );

  factory Status.fromMap(Map<String, dynamic> json) => Status(
        id: json["id"],
        text: json["text"],
        image: json["image"],
        caption: json["caption"],
        color: '${json["color"]}'.toColor,
        expireAt: DateTime.fromMillisecondsSinceEpoch(json["expire_at"]),
        createAt: DateTime.fromMillisecondsSinceEpoch(json["create_at"]),
      );

  Map<String, dynamic> get toMap => {
        "id": id,
        if (text != null) "text": text,
        if (image != null) "image": image,
        if (caption != null) "caption": caption,
        "color": color.toHex,
        "expire_at": expireAt.millisecondsSinceEpoch,
        "create_at": createAt.millisecondsSinceEpoch,
      };

  @override
  List<Object?> get props =>
      [id, text, image, caption, color, expireAt, createAt];
}
