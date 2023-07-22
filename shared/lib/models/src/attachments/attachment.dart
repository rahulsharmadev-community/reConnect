import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:shared/extensions/other/file_format.dart';
import '../../../enums/basic.dart';
import 'package:uuid/uuid.dart';

class Attachment extends Equatable {
  Attachment.forServer(
      {String? id,
      required this.filename,
      required this.type,
      required this.assetUrl,
      this.caption})
      : id = id ?? const Uuid().v4(),
        bytes = null;

  Attachment.fromDevice(
      {String? id,
      required this.filename,
      required this.type,
      required this.bytes,
      this.caption})
      : id = id ?? const Uuid().v4(),
        assetUrl = null;

  Attachment._internal(
      {required this.id,
      required this.filename,
      this.type,
      this.assetUrl,
      this.bytes,
      this.caption});

  final String id;
  final String filename;
  final AttachmentType? type;
  final String? assetUrl;
  final Uint8List? bytes;
  final String? caption;

  Attachment copyWith({
    String? id,
    String? assetUrl,
    String? filename,
    Uint8List? bytes,
    AttachmentType? type,
    String? caption,
  }) =>
      Attachment._internal(
        id: id ?? this.id,
        filename: filename ?? this.filename,
        type: type ?? this.type,
        bytes: bytes ?? this.bytes,
        assetUrl: assetUrl ?? this.assetUrl,
        caption: caption ?? this.caption,
      );

  static Attachment fromServer(Map<String, dynamic> map) {
    return Attachment.forServer(
      id: map["id"],
      filename: map["filename"],
      type: AttachmentType.from(map["type"]),
      assetUrl: map["assetUrl"],
      caption: map["caption"],
    );
  }

  static Attachment? fromKiC(KeyboardInsertedContent kiC) {
    if (!kiC.hasData) return null;
    var temp = sha256.convert(kiC.data!.toList()).toString();
    return Attachment.fromDevice(
      id: temp,
      filename: FilesFormat.get(temp, '/'),
      type: AttachmentType.image,
      bytes: kiC.data,
    );
  }

  /// NOT contain bytes desigin for server
  ///```
  /// "id": id,
  /// "filename": filename,
  /// "type": type?.name,
  /// "assetUrl": assetUrl,
  /// "caption": caption,
  /// ```
  Map<String, dynamic> get toMap => {
        "id": id,
        "filename": filename,
        "type": type?.name,
        "assetUrl": assetUrl,
        if (caption != null) "caption": caption,
      };

  @override
  List<Object?> get props => [id, filename, type, assetUrl, caption];
}
