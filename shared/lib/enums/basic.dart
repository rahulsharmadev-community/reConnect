// ignore_for_file: constant_identifier_names
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum PrivacyType {
  everybody,
  nobody,
  except,
  only;

  static PrivacyType from(String type) =>
      PrivacyType.values.firstWhere((e) => e.name == type);
}

enum UploadQuality {
  ORIGINAL,
  LOW,
  MEDIUM;

  static UploadQuality from(String type) =>
      UploadQuality.values.firstWhere((e) => e.name == type);
}

enum MessageStatus {
  sent(Icons.done, Colors.blue),
  failed(Icons.priority_high, Colors.yellow),
  waiting(Icons.schedule, Colors.grey),

  /// Message is view by receiver
  seen(Icons.done_all, Colors.blue),

  /// Message is being deleted
  deleted(Icons.delete_forever, Colors.red),

  /// Message failed to delete
  failed_delete(Icons.priority_high, Colors.red);

  final IconData icon;
  final Color color;
  const MessageStatus(this.icon, this.color);

  static MessageStatus from(String type) =>
      MessageStatus.values.firstWhere((e) => e.name == type);
}

enum VibrationType {
  DISABLE,
  DEFAULT,
  MEDIUM,
  SHORT,
  LONG;

  static VibrationType from(String type) =>
      VibrationType.values.firstWhere((e) => e.name == type);
}

enum MediaType {
  audio,
  video,
  gif,
  file,
  image;

  static MediaType from(String type) =>
      MediaType.values.firstWhere((e) => e.name == type);
}

enum AttachmentType {
  audio,
  video,
  svg,

  /// JPEG, PNG, GIF, BMP, WebP
  image,
  location,
  contect,
  poll,
  file;

  static AttachmentType from(String type) =>
      AttachmentType.values.firstWhere((e) => e.name == type);
}

enum HttpStatusCode {
  successful(200, 'Successful', 'Successful'),

  badRequest(400, 'Bad Request',
      'The server cannot process with invalid requested parameters'),

  notFound(404, 'Not Found',
      'The endpoint is valid but the resource itself does not exist.'),

  internalServerError(
      500,
      'Internal Server Error',
      'The 500 (Internal Server Error) status code indicates that the server encountered'
          ' an unexpected condition that prevented it from fulfilling the request.');

  final int statusCode;
  final String description, name;
  const HttpStatusCode(this.statusCode, this.name, this.description);
}

class UploadState extends Equatable {
  final String name;
  final double? _value;

  ///   processing, success, failed
  const UploadState(this.name, {double? progress})
      : assert(progress != null && name == 'processing',
            'progress should be null when status is processing'),
        _value = progress;

  const UploadState.success()
      : name = 'success',
        _value = null;

  const UploadState.failed()
      : name = 'failed',
        _value = null;

  const UploadState.processing(double value)
      : name = 'processing',
        _value = value;

  bool get isInProgress => name == 'processing';
  bool get isSuccess => name == 'success';
  bool get isFailed => name == 'failed';

  double? get progress => _value;

  @override
  String toString() => isInProgress ? '$name progress: $_value' : name;

  @override
  List<Object?> get props => [name, _value];
}
