class Application {
  final String name;
  final String id;
  final String description;
  final int minSdkVersion;
  final int targetSdkVersion;
  final int compileSdkVersion;
  final int versionCode;
  final String versionName;
  final String defaultIcon;
  final String defaultNotificationIcon;
  final String androidIcon;
  final String iosIcon;
  final String webIcon;
  final String macOsIcon;
  final String windowsIcons;
  final String androidNotificationIcon;
  final String iosNotificationIcon;
  final String webNotificationIcon;
  final String macOsNotificationIcon;
  final String windowsNotificationIcon;
  final String notificationChannelId;
  final String notificationChannelName;
  final String notificationChannelDescription;

  const Application({
    required this.name,
    required this.id,
    required this.description,
    required this.minSdkVersion,
    required this.targetSdkVersion,
    required this.compileSdkVersion,
    required this.versionName,
    required this.versionCode,
    required this.defaultIcon,
    required this.defaultNotificationIcon,
    String? androidIcon,
    String? iosIcon,
    String? webIcon,
    String? macOsIcon,
    String? windowsIcons,
    String? androidNotificationIcon,
    String? iosNotificationIcon,
    String? webNotificationIcon,
    String? macOsNotificationIcon,
    String? windowsNotificationIcon,
    String? notificationChannelId,
    String? notificationChannelName,
    String? notificationChannelDescription,
  })  : androidIcon = androidIcon ?? defaultIcon,
        iosIcon = iosIcon ?? defaultIcon,
        webIcon = webIcon ?? defaultIcon,
        macOsIcon = macOsIcon ?? defaultIcon,
        windowsIcons = windowsIcons ?? defaultIcon,
        androidNotificationIcon =
            androidNotificationIcon ?? defaultNotificationIcon,
        iosNotificationIcon = iosNotificationIcon ?? defaultNotificationIcon,
        webNotificationIcon = webNotificationIcon ?? defaultNotificationIcon,
        macOsNotificationIcon =
            macOsNotificationIcon ?? defaultNotificationIcon,
        windowsNotificationIcon =
            windowsNotificationIcon ?? defaultNotificationIcon,
        notificationChannelId = notificationChannelId ?? id,
        notificationChannelName = notificationChannelName ?? name,
        notificationChannelDescription =
            notificationChannelDescription ?? 'notification form $name';

  factory Application.fromJson(Map<String, dynamic> json) => Application(
        name: json["Name"],
        id: json["Id"],
        description: json["description"],
        minSdkVersion: json["minSdkVersion"],
        targetSdkVersion: json["targetSdkVersion"],
        compileSdkVersion: json["compileSdkVersion"],
        versionName: json["versionName"],
        versionCode: json["versionCode"],
        defaultIcon: json["defaultIcon"],
        defaultNotificationIcon: json["defaultNotificationIcon"],
        androidIcon: json["androidIcon"],
        iosIcon: json["iosIcon"],
        webIcon: json["webIcon"],
        macOsIcon: json["macOsIcon"],
        windowsIcons: json["windowsIcons"],
        androidNotificationIcon: json["androidNotificationIcon"],
        iosNotificationIcon: json["iosNotificationIcon"],
        webNotificationIcon: json["webNotificationIcon"],
        macOsNotificationIcon: json["macOsNotificationIcon"],
        windowsNotificationIcon: json["windowsNotificationIcon"],
      );

  Map<String, dynamic> get toMap => {
        "Name": name,
        "Id": id,
        "description": description,
        "minSdkVersion": minSdkVersion,
        "targetSdkVersion": targetSdkVersion,
        "compileSdkVersion": compileSdkVersion,
        "versionName": versionName,
        "versionCode": versionCode,
        "defaultIcon": defaultIcon,
        "defaultNotificationIcon": defaultNotificationIcon,
        "androidIcon": androidIcon,
        "iosIcon": iosIcon,
        "webIcon": webIcon,
        "macOsIcon": macOsIcon,
        "windowsIcons": windowsIcons,
        "androidNotificationIcon": androidNotificationIcon,
        "iosNotificationIcon": iosNotificationIcon,
        "webNotificationIcon": webNotificationIcon,
        "macOsNotificationIcon": macOsNotificationIcon,
        "windowsNotificationIcon": windowsNotificationIcon,
      };
}
