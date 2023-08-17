class FirebaseApnsConfig {
  final Map<String, String>? headers;
  final Map<String, dynamic>? payload;
  const FirebaseApnsConfig({this.headers, this.payload});

  static FirebaseApnsConfig? fromMap(Map<String, dynamic>? map) => map == null
      ? null
      : FirebaseApnsConfig(
          headers: (map['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ),
          payload: map['payload'],
        );

  Map<String, dynamic> get toMap => {
        'headers': headers,
        'payload': payload,
      };
}
