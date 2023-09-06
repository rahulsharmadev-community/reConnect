import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';
import 'package:shared/theme/src/themes/app_themes.dart';
import 'package:uuid/uuid.dart';

class PrimaryUser extends Equatable {
  PrimaryUser({
    String? userId,
    required this.name,
    required this.fCMid,
    required this.deviceInfo,
    this.email,
    this.phoneNumber,
    this.profileImg,
    this.status = const {},
    this.chatRooms = const {},
    this.contacts = const {},
    String? about,
    UserSettings? settings,
    DateTime? joinAt,
    DateTime? lastActiveAt,
    DateTime? lastCachedAt,
  })  : assert(!(name.isEmpty), 'name should not be empty.'),
        assert(!(email == null && phoneNumber == null),
            'email or phoneNumber should not be empty.'),
        userId = userId ?? const Uuid().v4(),
        about = about ?? 'Hey there! I am using reConnect.',
        settings = settings ?? UserSettings(),
        joinAt = joinAt ?? DateTime.now(),
        lastActiveAt = lastActiveAt ?? DateTime.now();

  final String userId;
  final String fCMid;
  final DeviceInfo deviceInfo;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String about;
  final String? profileImg;
  final DateTime lastActiveAt;

  /// Map to prevent duplicate chat rooms, where
  /// `keys : chatRoomIds, values : ChatRoomInfo objects`.
  final Map<String, ChatRoomInfo> chatRooms;

  /// Map to prevent duplicate contacts, where
  /// `keys : userIds, values : User objects`.
  final Map<String, User> contacts;

  /// Map to prevent duplicate status, where
  /// `keys : ids, values : Status objects`.
  final Map<String, Status> status;

  final UserSettings settings;
  final DateTime joinAt;

  PrimaryUser copyWith({
    String? userId,
    String? fCMid,
    DeviceInfo? deviceInfo,
    String? name,
    String? email,
    String? phoneNumber,
    String? about,
    String? profileImg,
    Map<String, ChatRoomInfo>? chatRooms,
    Map<String, User>? contacts,
    DateTime? lastActiveAt,
    Map<String, Status>? status,
    UserSettings? settings,
    DateTime? joinAt,
    DateTime? lastCachedAt,
  }) =>
      PrimaryUser(
        userId: userId ?? this.userId,
        fCMid: fCMid ?? this.fCMid,
        name: name ?? this.name,
        email: email ?? this.email,
        contacts: contacts ?? this.contacts,
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

  factory PrimaryUser.fromMap(Map<String, dynamic> json) {
    var contacts =
        List<User>.from((json["contacts"] ?? []).map((x) => User.fromMap(x)));

    var status =
        List<Status>.from((json["status"] ?? []).map((x) => Status.fromMap(x)));

    var chatRooms = List<ChatRoomInfo>.from(
        (json["chatRooms"] ?? []).map((x) => ChatRoomInfo.fromMap(x)));

    return PrimaryUser(
      userId: json["userId"],
      name: json["name"],
      fCMid: json["fCMid"],
      email: json["email"],
      deviceInfo: DeviceInfo.fromMap(json["deviceInfo"]),
      phoneNumber: json["phoneNumber"],
      about: json["about"],
      contacts: Map.fromIterable(contacts, key: (e) => e.userId),
      status: Map.fromIterable(status, key: (e) => e.id),
      chatRooms: Map.fromIterable(chatRooms, key: (e) => e.chatRoomId),
      profileImg: json["profileImg"],
      lastActiveAt: (json["lastActiveAt"] != null)
          ? DateTime.fromMillisecondsSinceEpoch(json["lastActiveAt"])
          : null,
      joinAt: DateTime.fromMillisecondsSinceEpoch(json["joinAt"]),
      settings: UserSettings.fromMap(json["settings"]),
    );
  }

  Map<String, dynamic> get toMap => {
        "userId": userId,
        "name": name,
        "fCMid": fCMid,
        "deviceInfo": deviceInfo.toMap,
        if (phoneNumber != null) "phoneNumber": phoneNumber,
        if (email != null) "email": email,
        "about": about,
        "status": status.values.map((x) => x.toMap).toList(),
        "contacts": contacts.values.map((x) => x.toMap).toList(),
        if (profileImg != null) "profileImg": profileImg,
        "lastActiveAt": lastActiveAt.millisecondsSinceEpoch,
        "joinAt": joinAt.millisecondsSinceEpoch,
        "chatRooms": List<Map>.from(chatRooms.values.map((x) => x.toMap)),
        "settings": settings.toMap,
      };

  @override
  List<Object?> get props => [
        userId,
        fCMid,
        deviceInfo,
        name,
        email,
        phoneNumber,
        about,
        profileImg,
        contacts,
        lastActiveAt,
        chatRooms,
        status,
        joinAt,
        settings
      ];
}

class UserSettings extends Equatable {
  UserSettings(
      {this.theme = AppThemes.DEFAULT,
      this.themeMode = ThemeMode.system,
      this.messageFontSize = 14,
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
        assert((7 < messageFontSize && messageCorners < 29),
            'FontSize should be greater then 7 & less then 29, 0<fontSize<29'),
        statusReplyPermission = statusReplyPermission ?? Privacy(),
        hideStatus = hideStatus ?? Privacy(),
        hideProfileImg = hideProfileImg ?? Privacy(),
        hideCredential = hideCredential ?? Privacy(),
        hideAbout = hideAbout ?? Privacy();

  final AppThemes theme;
  final ThemeMode themeMode;
  final int messageFontSize;
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
          {AppThemes? theme,
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
        messageFontSize: MessagefontSize ?? this.messageFontSize,
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
        theme: AppThemes.from(json["theme"] ?? AppThemes.DEFAULT.name),
        themeMode: ThemeMode.values[json["themeMode"]],
        messageFontSize: json["messageFontSize"],
        messageCorners: json["messageCorners"],
        autoDownloadWithMobileData:
            List.from(json["autoDownloadWithMobileData"] ?? [])
                .map((e) => MediaType.from(e))
                .toList(),
        autoDownloadWithWiFi: List.from(json["autoDownloadWithWiFi"] ?? [])
            .map((e) => MediaType.from(e))
            .toList(),
        wiFiUploadQuality: UploadQuality.from(json["wiFiUploadQuality"]),
        mobileDataUploadQuality:
            UploadQuality.from(json["mobileDataUploadQuality"]),
        inAppSound: json["inAppSound"],
        inAppVibrate: json["inAppVibrate"],
        backgroundMessageNotification: json["backgroundMessageNotification"],
        backgroundGroupNotification: json["backgroundGroupNotification"],
        messageReactionNotification: json["messageReactionNotification"],
        groupReactionNotification: json["groupReactionNotification"],
        inAppMessageNotification: json["inAppMessageNotification"],
        inAppGroupNotification: json["inAppGroupNotification"],
        messageSound: json["messageSound"],
        groupSound: json["groupSound"],
        messageVibrateType:
            VibrationType.values.byName(json["messageVibrateType"]),
        groupVibrateType: VibrationType.values.byName(json["groupVibrateType"]),
        showSecurityNotifications: json["showSecurityNotifications"],
        advancedEncryption: json["advancedEncryption"],
        statusReplyPermission: Privacy.fromMap(json["statusReplyPermission"]),
        hideStatus: Privacy.fromMap(json["hideStatus"]),
        hideProfileImg: Privacy.fromMap(json['hideProfileImg']),
        hideCredential: Privacy.fromMap(json['hideCredential']),
        hideAbout: Privacy.fromMap(json["hideAbout"]),
        blockedUsers:
            List<String>.from((json["blockedUsers"] ?? []).map((x) => x)),
        screenshotRestriction: json["screenshotRestriction"],
        recordingRestriction: json["recordingRestriction"],
        syncContacts: json["syncContacts"],
        notifyOnCredentialChange: json["notifyOnCredentialChange"],
      );

  Map<String, dynamic> get toMap => {
        "theme": theme.name,
        "themeMode": themeMode.index,
        "messageFontSize": messageFontSize,
        "messageCorners": messageCorners,
        "autoDownloadWithMobileData":
            autoDownloadWithMobileData.map((e) => e.name).toList(),
        "autoDownloadWithWiFi":
            autoDownloadWithWiFi.map((e) => e.name).toList(),
        "wiFiUploadQuality": wiFiUploadQuality.name,
        "mobileDataUploadQuality": mobileDataUploadQuality.name,
        "inAppSound": inAppSound,
        "inAppVibrate": inAppVibrate,
        "backgroundMessageNotification": backgroundMessageNotification,
        "backgroundGroupNotification": backgroundGroupNotification,
        "messageReactionNotification": messageReactionNotification,
        "groupReactionNotification": groupReactionNotification,
        "inAppMessageNotification": inAppMessageNotification,
        "inAppGroupNotification": inAppGroupNotification,
        "messageSound": messageSound,
        "groupSound": groupSound,
        "messageVibrateType": messageVibrateType.name,
        "groupVibrateType": groupVibrateType.name,
        "showSecurityNotifications": showSecurityNotifications,
        "advancedEncryption": advancedEncryption,
        "blockedUsers": blockedUsers,
        "screenshotRestriction": screenshotRestriction,
        "recordingRestriction": recordingRestriction,
        "syncContacts": syncContacts,
        "notifyOnCredentialChange": notifyOnCredentialChange,
        "statusReplyPermission": statusReplyPermission.toMap,
        "hideStatus": hideStatus.toMap,
        "hideProfileImg": hideProfileImg.toMap,
        "hideCredential": hideCredential.toMap,
        "hideAbout": hideAbout.toMap
      };

  @override
  List<Object?> get props => [
        theme,
        themeMode,
        messageFontSize,
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
        hideProfileImg,
        hideCredential,
        hideAbout,
        blockedUsers,
        screenshotRestriction,
        recordingRestriction,
        syncContacts,
        notifyOnCredentialChange
      ];
}

/// Helper class
class Privacy extends Equatable {
  final PrivacyType type;
  // List of Users
  final List<String> except;
  final List<String> only;
  Privacy(
      {this.type = PrivacyType.everybody,
      this.except = const [],
      this.only = const []});

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
      except: List<String>.from(map['except'] ?? []),
      only: List<String>.from(map['only'] ?? []));

  Map<String, dynamic> get toMap =>
      {"type": type.name, "except": except, "only": only};

  @override
  List<Object?> get props => [type, except, only];
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
        expireAt: DateTime.fromMillisecondsSinceEpoch(json["expireAt"]),
        createAt: DateTime.fromMillisecondsSinceEpoch(json["createAt"]),
      );

  Map<String, dynamic> get toMap => {
        "id": id,
        if (text != null) "text": text,
        if (image != null) "image": image,
        if (caption != null) "caption": caption,
        "color": color.toHex,
        "expireAt": expireAt.millisecondsSinceEpoch,
        "createAt": createAt.millisecondsSinceEpoch,
      };

  @override
  List<Object?> get props =>
      [id, text, image, caption, color, expireAt, createAt];
}
