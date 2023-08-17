class FirebaseFcmOptions {
  final String? analyticsLabel;

  static FirebaseFcmOptions? fromMap(Map<String, dynamic>? map) => map == null
      ? null
      : FirebaseFcmOptions(analyticsLabel: map['analytics_label']);

  Map<String, dynamic> get toMap => {'analytics_label': analyticsLabel};

  const FirebaseFcmOptions({this.analyticsLabel});
}
