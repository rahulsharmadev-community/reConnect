import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/models.dart';
import 'package:uuid/uuid.dart';

enum ChatRoomRole {
  visitor(
    'Visitor',
    'assets/svgs/pawn.svg',
    Color(0xffeae2b7),
  ),
  members(
    'Member',
    'assets/svgs/bishop.svg',
    Color(0xfffcbf49),
  ),
  moderators(
    'Moderator',
    'assets/svgs/queen.svg',
    Color(0xfff77f00),
  ),
  administrators(
    'Admin',
    'assets/svgs/king.svg',
    Color(0xffd62828),
  );

  final Color color;
  final String name;
  final String svgPath;
  const ChatRoomRole(this.name, this.svgPath, this.color);
}

extension ChatRoomInfoExt on ChatRoomInfo {
  ChatRoomRole roleOf(String id) {
    if (this.administrators.contains(id))
      return ChatRoomRole.administrators;
    else if (this.moderators.contains(id))
      return ChatRoomRole.moderators;
    else if (this.members.contains(id))
      return ChatRoomRole.members;
    else if (this.visitor.contains(id))
      return ChatRoomRole.visitor;
    else
      throw 'Not-Exist';
  }
}

class ChatRoomInfo extends Equatable {
  final String chatRoomId;
  final String? name;
  final String? about;
  final String? profileImg;
  final List<String> visitor, members, administrators, moderators;
  final ChatRoomRoles chatRoomRoles;
  final String createdBy;
  final DateTime createdAt;
  final Message? lastMessage;
  final bool isOneToOne;

  ChatRoomInfo({
    String? chatRoomId,
    this.name,
    this.about,
    this.profileImg,
    this.administrators = const [],
    this.moderators = const [],
    this.members = const [],
    this.visitor = const [],
    required this.createdBy,
    this.chatRoomRoles = const ChatRoomRoles(),
    DateTime? createdAt,
    this.lastMessage,
  })  : chatRoomId = chatRoomId ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        isOneToOne = members.length == 2;

  ChatRoomInfo copyWith(
          {String? name,
          String? about,
          String? profileImg,
          List<String>? visitor,
          List<String>? members,
          List<String>? administrators,
          List<String>? moderators,
          String? createdBy,
          DateTime? createdAt,
          ChatRoomRoles? chatRoomRoles,
          List<Message>? messages,
          Message? lastMessage}) =>
      ChatRoomInfo(
          chatRoomId: createdBy ?? this.chatRoomId,
          name: name ?? this.name,
          about: about ?? this.about,
          profileImg: profileImg ?? this.profileImg,
          visitor: visitor ?? this.visitor,
          members: members ?? this.members,
          chatRoomRoles: chatRoomRoles ?? this.chatRoomRoles,
          moderators: moderators ?? this.moderators,
          administrators: administrators ?? this.administrators,
          createdBy: createdBy ?? this.createdBy,
          createdAt: createdAt ?? this.createdAt,
          lastMessage: lastMessage ?? this.lastMessage);

  factory ChatRoomInfo.fromMap(Map<String, dynamic> map) => ChatRoomInfo(
        chatRoomId: map["chatRoomId"],
        lastMessage: map['lastMessage'] == null
            ? null
            : Message.fromMap(map['lastMessage']),
        name: map["name"],
        about: map["about"],
        profileImg: map["profileImg"],
        chatRoomRoles: map["chatRoomRoles"] == null
            ? const ChatRoomRoles()
            : ChatRoomRoles.fromMap(map["chatRoomRoles"]),
        visitor: List<String>.from((map["visitor"] ?? []).map((x) => x)),
        members: List<String>.from((map["members"] ?? []).map((x) => x)),
        moderators: List<String>.from((map["moderators"] ?? []).map((x) => x)),
        administrators:
            List<String>.from((map["administrators"] ?? []).map((x) => x)),
        createdBy: map["createdBy"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(map["createdAt"]),
      );

  Map<String, dynamic> get toMap => {
        "chatRoomId": chatRoomId,
        if (name != null) "name": name,
        if (about != null) "about": about,
        if (profileImg != null) "profileImg": profileImg,
        "chatRoomRoles": chatRoomRoles.toMap,
        "isOneToOne": isOneToOne,
        "visitor": List<dynamic>.from(visitor.map((x) => x)),
        "members": List<dynamic>.from(members.map((x) => x)),
        "moderators": List<dynamic>.from(moderators.map((x) => x)),
        "administrators": List<dynamic>.from(administrators.map((x) => x)),
        "createdBy": createdBy,
        "createdAt": createdAt.millisecondsSinceEpoch,
        if (lastMessage != null) "lastMessage": lastMessage!.toMap
      };

  @override
  List<Object?> get props => [
        isOneToOne,
        chatRoomId,
        name,
        about,
        profileImg,
        visitor,
        members,
        moderators,
        administrators,
        createdBy,
        createdAt,
        lastMessage?.toMap
      ];
}
