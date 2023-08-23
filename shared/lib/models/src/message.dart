// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'attachments/attachment.dart';
import 'reaction.dart';
import 'package:uuid/uuid.dart';
import '/enums/basic.dart';

class Message extends Equatable {
  final String messageId;
  final String senderId;

  final List<String> receiverIds;
  final MessageStatus? status;
  final String? text;
  final List<Attachment> attachments;
  final Message? reply;
  final List<Reaction> reactions;
  final DateTime createdAt;
  final DateTime updateAt;
  final DateTime? deletedAt;
  final List<String> mentionedUserIds;

  bool get isDeleted => deletedAt != null;
  bool get hasReply => reply != null;
  bool get hasReceiverIds => receiverIds.isNotEmpty;
  bool get hasMentionedUserIds => mentionedUserIds.isNotEmpty;

  bool get hasAttachment => attachments.isNotEmpty;
  bool get hasMultiAttachment => hasAttachment && attachments.length > 1;

  /// reset everything except senderId
  Message reset() => Message(senderId: senderId);

  Message delete() => copyWith(
        text: null,
        attachments: null,
        deletedAt: DateTime.now(),
        updateAt: DateTime.now(),
        status: MessageStatus.deleted,
      );

  Message({
    String? messageId,
    DateTime? createdAt,
    DateTime? updateAt,
    required this.senderId,
    this.reply,
    this.text,
    this.deletedAt,
    this.status = MessageStatus.waiting,
    this.receiverIds = const [],
    this.mentionedUserIds = const [],
    this.attachments = const [],
    this.reactions = const [],
  })  : messageId = messageId ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updateAt = updateAt ?? DateTime.now();

  Message copyWith({
    String? messageId,
    String? senderId,
    List<String>? receiverIds,
    MessageStatus? status,
    String? text,
    Message? reply,
    List<Attachment>? attachments,
    List<String>? mentionedUserIds,
    List<Reaction>? reactions,
    DateTime? createdAt,
    DateTime? deletedAt,
    DateTime? updateAt,
  }) =>
      Message(
        messageId: messageId ?? this.messageId,
        senderId: senderId ?? this.senderId,
        receiverIds: receiverIds ?? this.receiverIds,
        status: status ?? this.status,
        text: text ?? this.text,
        reply: reply ?? this.reply,
        attachments: attachments ?? this.attachments,
        mentionedUserIds: mentionedUserIds ?? this.mentionedUserIds,
        reactions: reactions ?? this.reactions,
        createdAt: createdAt ?? this.createdAt,
        deletedAt: deletedAt ?? this.deletedAt,
        updateAt: updateAt ?? this.updateAt,
      );

  static Message fromFirestore(
          DocumentSnapshot<Map<String, dynamic>> snapshot, options) =>
      Message.fromMap(snapshot.data() ?? {});

  static Map<String, dynamic> toFirestore(Message user, setOptions) =>
      user.toMap;

  factory Message.fromMap(Map<String, dynamic> map) => Message(
      messageId: map["messageId"],
      senderId: map["senderId"],
      receiverIds: List.from(map["receiverIds"] ?? []),
      status: MessageStatus.from(map["status"]),
      text: map["text"],
      reply: (map["replay"] != null) ? Message.fromMap(map["replay"]) : null,
      attachments: List<Attachment>.from(
          (map["attachments"] ?? []).map((x) => Attachment.fromServer(x))),
      mentionedUserIds:
          List<String>.from((map["mentionedUserIds"] ?? []).map((x) => x)),
      reactions: List<Reaction>.from(
          (map["reactions"] ?? []).map((x) => Reaction.fromMap(x))),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map["createdAt"]),
      deletedAt: map["deletedAt"] != null
          ? DateTime.fromMillisecondsSinceEpoch(map["deletedAt"])
          : null,
      updateAt: DateTime.fromMillisecondsSinceEpoch(map["updateAt"]));

  Map<String, dynamic> get toMap => {
        "messageId": messageId,
        "senderId": senderId,
        "receiverIds": receiverIds,
        "status": status?.name,
        if (reply != null) "replay": reply!.toMap,
        if (text != null) "text": text,
        "attachments": List<dynamic>.from(attachments.map((x) => x.toMap)),
        "mentionedUserIds": mentionedUserIds,
        "reactions": List<dynamic>.from(reactions.map((x) => x.toMap)),
        "createdAt": createdAt.millisecondsSinceEpoch,
        if (deletedAt != null) "deletedAt": deletedAt!.millisecondsSinceEpoch,
        "updateAt": updateAt.millisecondsSinceEpoch,
      };

  Map<String, dynamic> get toFCM => {
        "messageId": messageId,
        "senderId": senderId,
        if (status != null) "status": status!.name,
        if (receiverIds.isNotEmpty) "receiverIds": receiverIds,
        if (text != null) "text": text!,
        if (attachments.isNotEmpty)
          "attachments": attachments.map((x) => x.assetUrl).toList(),
        if (mentionedUserIds.isNotEmpty) "mentionedUserIds": mentionedUserIds,
        "createdAt": createdAt.millisecondsSinceEpoch,
        if (deletedAt != null) "deletedAt": deletedAt!.millisecondsSinceEpoch,
        "updateAt": updateAt.millisecondsSinceEpoch,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [
        messageId,
        senderId,
        receiverIds,
        status?.name,
        reply?.toMap,
        text,
        attachments.map((e) => e.toMap).toList(),
        reactions.map((e) => e.toMap).toList(),
        createdAt,
        updateAt,
        deletedAt,
        mentionedUserIds,
      ];
}
