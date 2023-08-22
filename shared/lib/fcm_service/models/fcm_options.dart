class FCMsOptions {
  /// Label associated with the message's analytics data.
  final String? analyticsLabel;

  static FCMsOptions? fromMapOrNull(Map<String, dynamic>? map) =>
      map == null ? null : FCMsOptions(analyticsLabel: map['analytics_label']);

  Map<String, dynamic> get toMap => {'analytics_label': analyticsLabel};

  const FCMsOptions({this.analyticsLabel});
}
