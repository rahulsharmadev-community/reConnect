import 'dart:convert';
import 'package:equatable/equatable.dart';

import '../../enums/_enums.dart';

import 'package:uuid/uuid.dart';

class Attachment extends Equatable {
  Attachment(
      {String? id,
      required this.filename,
      UploadState? uploadState,
      required this.type,
      required this.assetUrl,
      this.caption})
      : id = id ?? const Uuid().v4(),
        uploadState = uploadState ??
            (assetUrl.isNotEmpty
                ? const UploadState.success()
                : const UploadState.processing(0));

  final String id;
  final String filename;
  final UploadState uploadState;
  final AttachmentType type;
  final List<String> assetUrl;
  final String? caption;

  Attachment copyWith({
    String? id,
    String? filename,
    UploadState? uploadState,
    AttachmentType? type,
    List<String>? assetUrl,
    String? caption,
  }) =>
      Attachment(
        id: id ?? this.id,
        filename: filename ?? this.filename,
        uploadState: uploadState ?? this.uploadState,
        type: type ?? this.type,
        assetUrl: assetUrl ?? this.assetUrl,
        caption: caption ?? this.caption,
      );

  factory Attachment.fromJson(String str) =>
      Attachment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Attachment.fromMap(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        filename: json["filename"],
        uploadState: UploadState(json["upload_state"]),
        type: AttachmentType.values.byName(json["type"]),
        assetUrl: List<String>.from(json["asset_url"].map((x) => x)),
        caption: json["caption"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "filename": filename,
        "upload_state": uploadState.name,
        "type": type.name,
        "asset_url": List<dynamic>.from(assetUrl.map((x) => x)),
        if (caption != null) "caption": caption,
      };

  @override
  List<Object?> get props =>
      [id, filename, uploadState, type, assetUrl, caption];
}
