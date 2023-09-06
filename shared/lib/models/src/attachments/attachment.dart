import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:shared/extensions/other/file_format.dart';
import '../../../enums/basic.dart';
import 'package:uuid/uuid.dart';
import 'package:image_size_getter/image_size_getter.dart' as img;

class Attachment extends Equatable {
  Attachment.forServer(
      {String? id,
      required this.ext,
      required this.type,
      required this.assetUrl,
      this.size,
      this.caption})
      : id = id ?? const Uuid().v4(),
        bytes = null,
        this.isFromKiC = false;

  Attachment.fromDevice(
      {String? id,
      required this.ext,
      required this.type,
      required this.bytes,
      this.size,
      this.caption,
      this.isFromKiC = false})
      : id = id ?? const Uuid().v4(),
        assetUrl = null;

  Attachment._internal({
    required this.id,
    required this.ext,
    this.type,
    this.assetUrl,
    this.size,
    this.bytes,
    this.caption,
  }) : isFromKiC = false;

  final String id;
  final String ext;
  final Size? size;
  final AttachmentType? type;
  final String? assetUrl;
  final Uint8List? bytes;
  final String? caption;

  final bool isFromKiC;

  Attachment copyWith(
          {String? id,
          String? assetUrl,
          String? ext,
          Uint8List? bytes,
          AttachmentType? type,
          String? caption,
          Size? size}) =>
      Attachment._internal(
        id: id ?? this.id,
        ext: ext ?? this.ext,
        type: type ?? this.type,
        bytes: bytes ?? this.bytes,
        size: size ?? this.size,
        assetUrl: assetUrl ?? this.assetUrl,
        caption: caption ?? this.caption,
      );

  static Attachment fromServer(Map<String, dynamic> map) {
    return Attachment.forServer(
      id: map["id"],
      ext: map["ext"],
      type: AttachmentType.from(map["type"]),
      assetUrl: map["assetUrl"],
      size: Size(map['width'] ?? 250, map['height'] ?? 250),
      caption: map["caption"],
    );
  }

  static Attachment? fromKiC(KeyboardInsertedContent kiC) {
    if (!kiC.hasData) return null;
    var size = img.ImageSizeGetter.getSize(img.MemoryInput(kiC.data!));
    var temp = sha256.convert(kiC.data!.toList()).toString() +
        '_${size.width}_${size.width}';
    var file = FilesFormat(kiC.uri);
    return Attachment.fromDevice(
        id: temp,
        ext: file.toString(),
        type: AttachmentType.image,
        bytes: kiC.data,
        size: Size(size.width.toDouble(), size.height.toDouble()),
        isFromKiC: true);
  }

  /// NOT contain bytes desigin for server
  ///```
  /// "id": id,
  /// "ext": ext,
  /// "type": type?.name,
  /// "assetUrl": assetUrl,
  /// "caption": caption,
  /// ```
  Map<String, dynamic> get toMap => {
        "id": id,
        "ext": ext,
        "type": type?.name,
        "assetUrl": assetUrl,
        if (caption != null) "caption": caption,
        if (size != null) 'width': size!.width,
        if (size != null) 'height': size!.height
      };

  @override
  List<Object?> get props => [id, ext, type, assetUrl, caption, size];
}
