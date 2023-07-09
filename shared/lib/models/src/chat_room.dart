import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'message.dart';

class ChatRoomInfo extends Equatable {
  final String chatRoomId;
  final String? name;
  final String? about;
  final String? profileImg;
  final List<String> members;
  final List<String> admins;
  final String createdBy;
  final DateTime createdAt;
  final Message? lastMessage;
  bool get isOneToOne => members.length == 2;
  ChatRoomInfo({
    String? chatRoomId,
    this.name,
    this.about,
    this.profileImg,
    this.members = const [],
    this.admins = const [],
    required this.createdBy,
    DateTime? createdAt,
    this.lastMessage,
  })  : chatRoomId = chatRoomId ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  ChatRoomInfo copyWith(
          {String? name,
          String? about,
          String? profileImg,
          List<String>? members,
          List<String>? admins,
          String? createdBy,
          DateTime? createdAt,
          List<Message>? messages,
          Message? lastMessage}) =>
      ChatRoomInfo(
          chatRoomId: createdBy ?? this.chatRoomId,
          name: name ?? this.name,
          about: about ?? this.about,
          profileImg: profileImg ?? this.profileImg,
          members: members ?? this.members,
          admins: admins ?? this.admins,
          createdBy: createdBy ?? this.createdBy,
          createdAt: createdAt ?? this.createdAt,
          lastMessage: lastMessage ?? this.lastMessage);

  factory ChatRoomInfo.fromJson(Map<String, dynamic> json) => ChatRoomInfo(
        chatRoomId: json["chatRoomId"],
        lastMessage: json['lastMessage'] == null
            ? null
            : Message.fromMap(json['lastMessage']),
        name: json["name"],
        about: json["about"],
        profileImg: json["profileImg"],
        members: List<String>.from(json["members"].map((x) => x)),
        admins: List<String>.from(json["admins"].map((x) => x)),
        createdBy: json["createdBy"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"]),
      );

  Map<String, dynamic> get toJson => {
        "chatRoomId": chatRoomId,
        if (name != null) "name": name,
        if (about != null) "about": about,
        if (profileImg != null) "profileImg": profileImg,
        "members": List<dynamic>.from(members.map((x) => x)),
        "admins": List<dynamic>.from(admins.map((x) => x)),
        "createdBy": createdBy,
        "createdAt": createdAt.millisecondsSinceEpoch,
        if (lastMessage != null) "lastMessage": lastMessage!.toMap
      };

  @override
  List<Object?> get props => [
        chatRoomId,
        name,
        about,
        profileImg,
        members,
        admins,
        createdBy,
        createdAt,
        lastMessage?.toMap
      ];
}
