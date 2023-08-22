/// Basic notification template to use across all platforms.
class FCMsNotification {
  ///The notification's title.
  final String? title;

  ///The notification's body text.
  final String? body;

  /// Contains the URL of an image that is going to be downloaded on the device and displayed in a notification.
  /// JPEG, PNG, BMP have full support across platforms. Animated GIF and video only work on iOS.
  /// WebP and HEIF have varying levels of support across platforms and platform versions.
  /// Android has 1MB image size limit.
  ///
  ///  Quota usage and implications/costs for hosting image on Firebase Storage: https://firebase.google.com/pricing
  final String? image;

  static FCMsNotification? fromMapOrNull(Map<String, dynamic>? map) => map == null
      ? null
      : FCMsNotification(
          title: map['title'],
          body: map['body'],
          image: map['image'],
        );

  Map<String, dynamic> get toMap => {
        'title': title,
        'body': body,
        'image': image,
      };

  const FCMsNotification({this.title, this.body, this.image});
}
