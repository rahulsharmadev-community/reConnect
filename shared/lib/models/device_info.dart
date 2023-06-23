class DeviceInfo {
  DeviceInfo({
    required this.model,
    required this.androidId,
    required this.sdkInt,
    required this.device,
    required this.buildId,
    required this.hardware,
    required this.isPhysicalDevice,
    required this.physicalPixels,
    required this.logicalPixels,
  });

  final String androidId;

  /// Android operating system version values derived from `android.os.Build.VERSION`.
  final int sdkInt;

  /// The name of the industrial design.
  /// https://developer.android.com/reference/android/os/Build#DEVICE
  final String device;

  /// A build ID string meant for buildIding to the user.
  /// https://developer.android.com/reference/android/os/Build#buildId
  final String buildId;

  /// The name of the hardware (from the kernel command line or /proc).
  /// https://developer.android.com/reference/android/os/Build#HARDWARE
  final String hardware;

  /// The end-user-visible name for the end product.
  /// https://developer.android.com/reference/android/os/Build#MODEL
  final String model;

  /// `false` if the application is running in an emulator, `true` otherwise.
  final bool isPhysicalDevice;

  /// FORMATE\
  /// {"width":"1080", "height":"2400"}
  final Map<String, dynamic> physicalPixels;

  /// FORMATE\
  /// Flutter MediaQuery\
  /// {"width":"400", "height":"800"}
  final Map<String, dynamic> logicalPixels;

  /// Deserializes from the message received from [_kChannel].
  static DeviceInfo fromMap(Map<String, dynamic> map) {
    return DeviceInfo(
        androidId: map['androidId'],
        device: map['device'],
        buildId: map['buildId'],
        hardware: map['hardware'],
        model: map['model'],
        isPhysicalDevice: map['isPhysicalDevice'],
        sdkInt: map['sdkInt'],
        logicalPixels: map['logicalPixels'],
        physicalPixels: map['physicalPixels']);
  }

  get toJson => {
        'androidId': androidId,
        'device': device,
        'buildId': buildId,
        'hardware': hardware,
        'model': model,
        'isPhysicalDevice': isPhysicalDevice,
        'sdkInt': sdkInt,
        'logicalPixels': logicalPixels,
        'physicalPixels': physicalPixels
      };
}
