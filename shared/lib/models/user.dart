import 'dart:convert';
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
  })  : assert(!(name.hasData || name.data!.isNotEmpty),
            'name should not be empty.'),
        assert((!email.hasData && !phoneNumber.hasData),
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

  factory LogInUser.fromJson(String str) => LogInUser.fromMap(json.decode(str));

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
  UserSettings({
    ChatSettings? chatSettings,
    PrivacySecurity? privacySecurity,
    this.notificationsSounds = const NotificationsSounds(),
    this.dateStorage = const DateStorage(),
  })  : chatSettings = chatSettings ?? ChatSettings(),
        privacySecurity = privacySecurity ?? PrivacySecurity();

  final ChatSettings chatSettings;
  final PrivacySecurity privacySecurity;
  final NotificationsSounds notificationsSounds;
  final DateStorage dateStorage;

  UserSettings copyWith({
    ChatSettings? chatSettings,
    PrivacySecurity? privacySecurity,
    NotificationsSounds? notificationsSounds,
    DateStorage? dateStorage,
  }) =>
      UserSettings(
        chatSettings: chatSettings ?? this.chatSettings,
        privacySecurity: privacySecurity ?? this.privacySecurity,
        notificationsSounds: notificationsSounds ?? this.notificationsSounds,
        dateStorage: dateStorage ?? this.dateStorage,
      );

  factory UserSettings.fromJson(String str) =>
      UserSettings.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserSettings.fromMap(Map<String, dynamic> json) => UserSettings(
        chatSettings: ChatSettings.fromMap(json["chat_settings"]),
        privacySecurity: PrivacySecurity.fromMap(json["privacy_security"]),
        notificationsSounds:
            NotificationsSounds.fromMap(json["notifications_sounds"]),
        dateStorage: DateStorage.fromMap(json["date_storage"]),
      );

  Map<String, dynamic> toMap() => {
        "chat_settings": chatSettings.toMap(),
        "privacy_security": privacySecurity.toMap(),
        "notifications_sounds": notificationsSounds.toMap(),
        "date_storage": dateStorage.toMap(),
      };

  @override
  List<Object?> get props =>
      [chatSettings, privacySecurity, notificationsSounds, dateStorage];
}

class ChatSettings extends Equatable {
  const ChatSettings({
    this.theme = 'DEFAULT',
    this.themeMode = ThemeMode.system,
    this.fontSize = 14,
    this.messageCorners = 7,
  })  : assert((0 < messageCorners && messageCorners < 11),
            'Message corners should be greater then 0 & less then 11, 0<messageCorners<11'),
        assert((7 < fontSize && messageCorners < 29),
            'FontSize should be greater then 7 & less then 29, 0<fontSize<29');

  final String theme;
  final ThemeMode themeMode;
  final int fontSize;
  final int messageCorners;

  ChatSettings copyWith({
    String? theme,
    ThemeMode? themeMode,
    int? fontSize,
    int? messageCorners,
  }) =>
      ChatSettings(
        theme: theme ?? this.theme,
        themeMode: themeMode ?? this.themeMode,
        fontSize: fontSize ?? this.fontSize,
        messageCorners: messageCorners ?? this.messageCorners,
      );

  factory ChatSettings.fromJson(String str) =>
      ChatSettings.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChatSettings.fromMap(Map<String, dynamic> json) => ChatSettings(
        theme: json["theme"],
        themeMode: ThemeMode.values[json["theme_mode"]],
        fontSize: json["font_size"],
        messageCorners: json["message_corners"],
      );

  Map<String, dynamic> toMap() => {
        "theme": theme,
        "theme_mode": themeMode.index,
        "font_size": fontSize,
        "message_corners": messageCorners,
      };

  @override
  List<Object?> get props => [theme, themeMode, fontSize, messageCorners];
}

class DateStorage extends Equatable {
  const DateStorage(
      {this.autoDownloadAudio = true,
      this.autoDownloadImage = true,
      this.autoDownloadGif = true,
      this.autoDownloadVideo = true});

  final bool autoDownloadAudio;
  final bool autoDownloadImage;
  final bool autoDownloadGif;
  final bool autoDownloadVideo;

  DateStorage copyWith(
          {bool? autoDownloadAudio,
          bool? autoDownloadImage,
          bool? autoDownloadGif,
          bool? autoDownloadVideo}) =>
      DateStorage(
          autoDownloadAudio: autoDownloadAudio ?? this.autoDownloadAudio,
          autoDownloadImage: autoDownloadImage ?? this.autoDownloadImage,
          autoDownloadGif: autoDownloadGif ?? this.autoDownloadGif,
          autoDownloadVideo: autoDownloadVideo ?? this.autoDownloadVideo);

  factory DateStorage.fromJson(String str) =>
      DateStorage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DateStorage.fromMap(Map<String, dynamic> map) => DateStorage(
      autoDownloadAudio: map["auto_download_audio"],
      autoDownloadImage: map["auto_download_image"],
      autoDownloadGif: map["auto_download_gif"],
      autoDownloadVideo: map["auto_download_video"]);

  Map<String, dynamic> toMap() => {
        "auto_download_audio": autoDownloadAudio,
        "auto_download_image": autoDownloadImage,
        "auto_download_gif": autoDownloadGif,
        "auto_download_video": autoDownloadVideo
      };

  @override
  List<Object?> get props => [
        autoDownloadAudio,
        autoDownloadImage,
        autoDownloadGif,
        autoDownloadVideo
      ];
}

class NotificationsSounds extends Equatable {
  const NotificationsSounds({
    this.inAppSound = false,
    this.inAppVibrate = false,
    this.statusNotifications = false,
    this.backgroundMessageNotification = false,
    this.backgroundGroupNotification = false,
    this.messageReactionNotification = false,
    this.groupReactionNotification = false,
    this.messageNotification = false,
    this.groupNotification = false,
    this.messageSound = 'DEFAULT',
    this.groupSound = 'DEFAULT',
    this.messageVibrate = VibrationType.DEFAULT,
    this.groupVibrate = VibrationType.DEFAULT,
    this.showSecurityNotifications = false,
  });

  final bool inAppSound;
  final bool inAppVibrate;
  final bool statusNotifications;
  final bool backgroundMessageNotification;
  final bool backgroundGroupNotification;
  final bool messageReactionNotification;
  final bool groupReactionNotification;
  final bool messageNotification;
  final bool groupNotification;
  final String messageSound;
  final String groupSound;
  final VibrationType messageVibrate;
  final VibrationType groupVibrate;
  final bool showSecurityNotifications;

  NotificationsSounds copyWith({
    bool? inAppSound,
    bool? inAppVibrate,
    bool? statusNotifications,
    bool? backgroundMessageNotification,
    bool? backgroundGroupNotification,
    bool? messageReactionNotification,
    bool? groupReactionNotification,
    bool? messageNotification,
    bool? groupNotification,
    String? messageSound,
    String? groupSound,
    VibrationType? messageVibrate,
    VibrationType? groupVibrate,
    bool? showSecurityNotifications,
  }) =>
      NotificationsSounds(
        inAppSound: inAppSound ?? this.inAppSound,
        inAppVibrate: inAppVibrate ?? this.inAppVibrate,
        statusNotifications: statusNotifications ?? this.statusNotifications,
        backgroundMessageNotification:
            backgroundMessageNotification ?? this.backgroundMessageNotification,
        backgroundGroupNotification:
            backgroundGroupNotification ?? this.backgroundGroupNotification,
        messageReactionNotification:
            messageReactionNotification ?? this.messageReactionNotification,
        groupReactionNotification:
            groupReactionNotification ?? this.groupReactionNotification,
        messageNotification: messageNotification ?? this.messageNotification,
        groupNotification: groupNotification ?? this.groupNotification,
        messageSound: messageSound ?? this.messageSound,
        groupSound: groupSound ?? this.groupSound,
        messageVibrate: messageVibrate ?? this.messageVibrate,
        groupVibrate: groupVibrate ?? this.groupVibrate,
        showSecurityNotifications:
            showSecurityNotifications ?? this.showSecurityNotifications,
      );

  factory NotificationsSounds.fromJson(String str) =>
      NotificationsSounds.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationsSounds.fromMap(Map<String, dynamic> json) =>
      NotificationsSounds(
        inAppSound: json["in_app_sound"],
        inAppVibrate: json["in_app_vibrate"],
        statusNotifications: json["status_notifications"],
        backgroundMessageNotification: json["background_message_notification"],
        backgroundGroupNotification: json["background_group_notification"],
        messageReactionNotification: json["message_reaction_notification"],
        groupReactionNotification: json["group_reaction_notification"],
        messageNotification: json["message_notification"],
        groupNotification: json["group_notification"],
        messageSound: json["message_sound"],
        groupSound: json["group_sound"],
        messageVibrate: VibrationType.values.byName(json["message_vibrate"]),
        groupVibrate: VibrationType.values.byName(json["group_vibrate"]),
        showSecurityNotifications: json["show_security_notifications"],
      );

  Map<String, dynamic> toMap() => {
        "in_app_sound": inAppSound,
        "in_app_vibrate": inAppVibrate,
        "status_notifications": statusNotifications,
        "background_message_notification": backgroundMessageNotification,
        "background_group_notification": backgroundGroupNotification,
        "message_reaction_notification": messageReactionNotification,
        "group_reaction_notification": groupReactionNotification,
        "message_notification": messageNotification,
        "group_notification": groupNotification,
        "message_sound": messageSound,
        "group_sound": groupSound,
        "message_vibrate": messageVibrate.name,
        "group_vibrate": groupVibrate.name,
        "show_security_notifications": showSecurityNotifications,
      };

  @override
  List<Object?> get props => [
        inAppSound,
        inAppVibrate,
        statusNotifications,
        backgroundMessageNotification,
        backgroundGroupNotification,
        messageReactionNotification,
        groupReactionNotification,
        messageNotification,
        groupNotification,
        messageSound,
        groupSound,
        messageVibrate,
        groupVibrate,
        showSecurityNotifications
      ];
}

class PrivacySecurity extends Equatable {
  PrivacySecurity(
      {this.advancedEncryption = false,
      StatusPrivacy? statusPrivacy,
      ProfilePrivacy? profilePrivacy,
      ChatPrivacy? chatPrivacy,
      this.blockedUsers,
      this.disableScreenshot = false,
      this.disableScreenRecording = false,
      this.syncContacts = true,
      this.suggestContacts = true,
      this.notifyUserChangeNumber = true})
      : statusPrivacy = statusPrivacy ?? StatusPrivacy(),
        profilePrivacy = profilePrivacy ?? ProfilePrivacy(),
        chatPrivacy = chatPrivacy ?? ChatPrivacy();

  final bool advancedEncryption;
  final StatusPrivacy statusPrivacy;
  final ProfilePrivacy profilePrivacy;
  final ChatPrivacy chatPrivacy;
  final List<String>? blockedUsers;
  final bool disableScreenshot;
  final bool disableScreenRecording;
  final bool syncContacts;
  final bool suggestContacts;
  final bool notifyUserChangeNumber;

  PrivacySecurity copyWith({
    bool? advancedEncryption,
    StatusPrivacy? statusPrivacy,
    ProfilePrivacy? profilePrivacy,
    List<String>? blockedUsers,
    ChatPrivacy? chatPrivacy,
    bool? disableScreenshot,
    bool? disableScreenRecording,
    bool? syncContacts,
    bool? suggestContacts,
    bool? notifyUserChangeNumber,
  }) =>
      PrivacySecurity(
        advancedEncryption: advancedEncryption ?? this.advancedEncryption,
        statusPrivacy: statusPrivacy ?? this.statusPrivacy,
        profilePrivacy: profilePrivacy ?? this.profilePrivacy,
        blockedUsers: blockedUsers ?? this.blockedUsers,
        chatPrivacy: chatPrivacy ?? this.chatPrivacy,
        disableScreenshot: disableScreenshot ?? this.disableScreenshot,
        disableScreenRecording:
            disableScreenRecording ?? this.disableScreenRecording,
        syncContacts: syncContacts ?? this.syncContacts,
        suggestContacts: suggestContacts ?? this.suggestContacts,
        notifyUserChangeNumber:
            notifyUserChangeNumber ?? this.notifyUserChangeNumber,
      );

  factory PrivacySecurity.fromJson(String str) =>
      PrivacySecurity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrivacySecurity.fromMap(Map<String, dynamic> json) => PrivacySecurity(
        advancedEncryption: json["advanced_encryption"],
        statusPrivacy: StatusPrivacy.fromMap(json["status_privacy"]),
        profilePrivacy: ProfilePrivacy.fromMap(json["profile_privacy"]),
        blockedUsers:
            List<String>.from(json["blocked_users"] ?? [].map((x) => x)),
        chatPrivacy: ChatPrivacy.fromMap(json["chat_privacy"]),
        disableScreenshot: json["disable_screenshot"],
        disableScreenRecording: json["disable_screen_recording"],
        syncContacts: json["sync_contacts"],
        suggestContacts: json["suggest_contacts"],
        notifyUserChangeNumber: json["notify_user_change_number"],
      );

  Map<String, dynamic> toMap() => {
        "advanced_encryption": advancedEncryption,
        "status_privacy": statusPrivacy.toMap(),
        "profile_privacy": profilePrivacy.toMap(),
        "blocked_users": blockedUsers,
        "chat_privacy": chatPrivacy.toMap(),
        "disable_screenshot": disableScreenshot,
        "disable_screen_recording": disableScreenRecording,
        "sync_contacts": syncContacts,
        "suggest_contacts": suggestContacts,
        "notify_user_change_number": notifyUserChangeNumber,
      };

  @override
  List<Object?> get props => [
        advancedEncryption,
        statusPrivacy,
        profilePrivacy,
        chatPrivacy,
        blockedUsers,
        disableScreenshot,
        disableScreenRecording,
        syncContacts,
        suggestContacts,
        notifyUserChangeNumber
      ];
}

/// Helper class
class Privacy {
  final PrivacyType type;
  // List of Users
  final List<String> except;
  final List<String> only;
  Privacy(this.type, {this.except = const [], this.only = const []})
      : assert(!(type == PrivacyType.except && except.isEmpty),
            'PrivacyType.except'),
        assert(!(type == PrivacyType.only && only.isEmpty), 'PrivacyType.only');

  Privacy copyWith({
    PrivacyType? type,
    List<String>? except,
    List<String>? only,
  }) =>
      Privacy(type ?? this.type,
          except: except ?? this.except, only: only ?? this.only);

  factory Privacy.fromJson(String str) => Privacy.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Privacy.fromMap(Map<String, dynamic> map) =>
      Privacy(PrivacyType.values.byName(map['type']),
          except: List<String>.from(map['except']),
          only: List<String>.from(map['only']));

  Map<String, dynamic> toMap() =>
      {"type": type.name, "except": except, "only": only};
}

class ChatPrivacy {
  ChatPrivacy({Privacy? hideOnlineStatus, Privacy? hideLastSeen})
      : hideOnlineStatus = hideOnlineStatus ?? Privacy(PrivacyType.nobody),
        hideLastSeen = hideLastSeen ?? Privacy(PrivacyType.nobody);

  final Privacy hideOnlineStatus;
  final Privacy hideLastSeen;

  ChatPrivacy copyWith({Privacy? hideOnlineStatus, Privacy? hideLastSeen}) =>
      ChatPrivacy(
          hideOnlineStatus: hideOnlineStatus ?? this.hideOnlineStatus,
          hideLastSeen: hideLastSeen ?? this.hideLastSeen);

  factory ChatPrivacy.fromJson(String str) =>
      ChatPrivacy.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChatPrivacy.fromMap(Map<String, dynamic> map) => ChatPrivacy(
      hideLastSeen: Privacy.fromMap(map["hide_last_seen"]),
      hideOnlineStatus: Privacy.fromMap(map["hide_online_status"]));

  Map<String, dynamic> toMap() => {
        "hide_online_status": hideOnlineStatus.toMap(),
        "hide_last_seen": hideLastSeen.toMap()
      };
}

class ProfilePrivacy {
  ProfilePrivacy(
      {Privacy? hideProfileImg, Privacy? hidePhoneNumber, Privacy? hideAbout})
      : hideProfileImg = hideProfileImg ?? Privacy(PrivacyType.nobody),
        hidePhoneNumber = hidePhoneNumber ?? Privacy(PrivacyType.nobody),
        hideAbout = hideAbout ?? Privacy(PrivacyType.nobody);

  final Privacy hideProfileImg;
  final Privacy hidePhoneNumber;
  final Privacy hideAbout;

  ProfilePrivacy copyWith(
          {Privacy? hideProfileImg,
          Privacy? hidePhoneNumber,
          Privacy? hideAbout}) =>
      ProfilePrivacy(
          hideProfileImg: hideProfileImg ?? hideProfileImg,
          hidePhoneNumber: hidePhoneNumber ?? hidePhoneNumber,
          hideAbout: hideAbout ?? hideAbout);

  factory ProfilePrivacy.fromJson(String str) =>
      ProfilePrivacy.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfilePrivacy.fromMap(Map<String, dynamic> map) => ProfilePrivacy(
      hideProfileImg: Privacy.fromMap(map['hide_profile_img']),
      hidePhoneNumber: Privacy.fromMap(map['hide_phone_number']),
      hideAbout: Privacy.fromMap(map["hide_about"]));

  Map<String, dynamic> toMap() => {
        "hide_profile_img": hideProfileImg.toMap(),
        "hide_phone_number": hidePhoneNumber.toMap(),
        "hide_about": hideAbout.toMap()
      };
}

class StatusPrivacy {
  StatusPrivacy({
    Privacy? replyPermission,
    Privacy? hide,
  })  : replyPermission = replyPermission ?? Privacy(PrivacyType.nobody),
        hide = hide ?? Privacy(PrivacyType.nobody);

  final Privacy replyPermission;
  final Privacy hide;

  StatusPrivacy copyWith({
    Privacy? replyPermission,
    Privacy? hide,
  }) =>
      StatusPrivacy(
          replyPermission: replyPermission ?? this.replyPermission,
          hide: hide ?? this.hide);

  factory StatusPrivacy.fromJson(String str) =>
      StatusPrivacy.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory StatusPrivacy.fromMap(Map<String, dynamic> json) => StatusPrivacy(
        replyPermission: Privacy.fromMap(json["reply_permission"]),
        hide: Privacy.fromMap(json["hide"]),
      );

  Map<String, dynamic> toMap() => {
        "reply_permission": replyPermission.toMap(),
        "hide": hide.toMap(),
      };
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

  factory Status.fromJson(String str) => Status.fromMap(json.decode(str));

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
