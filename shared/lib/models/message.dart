// ignore_for_file: must_be_immutable

import 'dart:convert';
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
  final MessageStatus status;
  final MessageType type;
  final String? text;
  final List<Attachment>? attachments;
  final Message? replay;
  final List<Reaction>? reactions;
  final DateTime createdAt;
  final DateTime updateAt;
  final DateTime? deletedAt;
  final List<String> mentionedUserIds;

  bool get isDeleted => deletedAt != null;

  Message delete() => copyWith(
        text: null,
        attachments: null,
        deletedAt: DateTime.now(),
        updateAt: DateTime.now(),
        type: MessageType.regular,
        status: MessageStatus.deleted,
      );

  Message({
    String? messageId,
    required this.type,
    this.replay,
    DateTime? createdAt,
    DateTime? updateAt,
    this.text,
    this.deletedAt,
    required this.status,
    required this.senderId,
    required this.receiverIds,
    required this.mentionedUserIds,
    this.attachments,
    this.reactions,
  })  : messageId = messageId ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updateAt = updateAt ?? DateTime.now();

  Message.reply(
    this.replay, {
    required this.senderId,
    required this.receiverIds,
    this.text,
    this.attachments,
    this.reactions,
    this.deletedAt,
    this.status = MessageStatus.waiting,
    this.mentionedUserIds = const [],
  })  : messageId = const Uuid().v4(),
        createdAt = DateTime.now(),
        updateAt = DateTime.now(),
        type = MessageType.reply;

  Message reaction(
    Reaction reactions,
  ) =>
      copyWith(reactions: [...(this.reactions ?? []), reactions]);

  Message.attachments(
    List<Attachment> attachments, {
    required this.senderId,
    required this.receiverIds,
    this.text,
    this.reactions,
    this.status = MessageStatus.waiting,
    this.mentionedUserIds = const [],
  })  : messageId = const Uuid().v4(),
        createdAt = DateTime.now(),
        updateAt = DateTime.now(),
        type = MessageType.attachments,
        attachments = attachments,
        deletedAt = null,
        replay = null;

  Message.text(
    this.text, {
    required this.senderId,
    required this.receiverIds,
    this.status = MessageStatus.waiting,
    this.mentionedUserIds = const [],
  })  : messageId = const Uuid().v4(),
        createdAt = DateTime.now(),
        updateAt = DateTime.now(),
        type = MessageType.regular,
        deletedAt = null,
        attachments = null,
        replay = null,
        reactions = null;
  Message copyWith({
    String? message_id,
    String? senderId,
    List<String>? receiverIds,
    MessageStatus? status,
    MessageType? type,
    String? text,
    Message? replay,
    List<Attachment>? attachments,
    List<String>? mentionedUserIds,
    List<Reaction>? reactions,
    DateTime? createdAt,
    DateTime? deletedAt,
    DateTime? updateAt,
  }) =>
      Message(
        messageId: message_id ?? this.messageId,
        senderId: senderId ?? this.senderId,
        receiverIds: receiverIds ?? this.receiverIds,
        status: status ?? this.status,
        type: type ?? this.type,
        text: text ?? text,
        replay: replay ?? replay,
        attachments: attachments ?? attachments,
        mentionedUserIds: mentionedUserIds ?? this.mentionedUserIds,
        reactions: reactions ?? reactions,
        createdAt: createdAt ?? this.createdAt,
        deletedAt: deletedAt ?? this.deletedAt,
        updateAt: updateAt ?? this.updateAt,
      );

  static Message fromFirestore(
          DocumentSnapshot<Map<String, dynamic>> snapshot, options) =>
      Message.fromMap(snapshot.data() ?? {});

  static Map<String, dynamic> toFirestore(Message user, setOptions) =>
      user.toMap;

  factory Message.fromJson(String str) => Message.fromMap(json.decode(str));

  factory Message.fromMap(Map<String, dynamic> map) => Message(
      messageId: map["message_id"],
      senderId: map["sender_id"],
      receiverIds: List<String>.from(map["receiver_ids"] ?? []),
      status: MessageStatus.from(map["status"]),
      type: MessageType.from(map["type"]),
      text: map["text"],
      replay: (map["replay"] != null) ? Message.fromMap(map["replay"]) : null,
      attachments: List<Attachment>.from(
          map["attachments"] ?? [].map((x) => Attachment.fromJson(x))),
      mentionedUserIds:
          List<String>.from(map["mentioned_user_ids"] ?? [].map((x) => x)),
      reactions: List<Reaction>.from(
          map["reactions"] ?? [].map((x) => Reaction.fromJson(x))),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map["created_at"]),
      deletedAt: map["deleted_at"] != null
          ? DateTime.fromMillisecondsSinceEpoch(map["deleted_at"])
          : null,
      updateAt: DateTime.fromMillisecondsSinceEpoch(map["update_at"]));

  Map<String, dynamic> get toMap => {
        "message_id": messageId,
        "sender_id": senderId,
        "receiver_ids": receiverIds,
        "status": status.name,
        "type": type.name,
        if (replay != null) "replay": replay!.toMap,
        if (text != null) "text": text,
        if (attachments != null)
          "attachments": List<dynamic>.from(attachments!.map((x) => x.toMap())),
        "mentioned_user_ids": mentionedUserIds,
        if (reactions != null)
          "reactions": List<dynamic>.from(reactions!.map((x) => x.toMap())),
        "created_at": createdAt.millisecondsSinceEpoch,
        if (deletedAt != null) "deleted_at": deletedAt!.millisecondsSinceEpoch,
        "update_at": updateAt.millisecondsSinceEpoch,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [
        messageId,
        senderId,
        receiverIds,
        status.name,
        type.name,
        replay?.toMap,
        text,
        attachments?.map((e) => e.toMap()).toList(),
        reactions?.map((e) => e.toMap()).toList(),
        createdAt,
        updateAt,
        deletedAt,
        mentionedUserIds,
      ];
}
