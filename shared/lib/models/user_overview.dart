import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:shared/models/user.dart';

class User extends Equatable {
  const User({
    required this.userId,
    required this.name,
    this.email,
    this.phoneNumber,
    this.about,
    this.status,
    this.profileImg,
    this.joinAt,
    this.lastActiveAt,
    this.lastMessage,
  });

  final String userId;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String? about;
  final String? profileImg;
  final String? lastMessage;
  final Status? status;

  final DateTime? joinAt;
  final DateTime? lastActiveAt;

  User copyWith({
    String? userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? about,
    String? lastMessage,
    Status? status,
    String? profileImg,
    DateTime? joinAt,
    DateTime? lastActiveAt,
  }) =>
      User(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        about: about ?? this.about,
        lastMessage: lastMessage ?? this.lastMessage,
        status: status ?? this.status,
        profileImg: profileImg ?? this.profileImg,
        joinAt: joinAt ?? this.joinAt,
        lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      );

  static User fromFirestore(
          DocumentSnapshot<Map<String, dynamic>> snapshot, options) =>
      User.fromMap(snapshot.data() ?? {});

  static Map<String, dynamic> toFirestore(User user, setOptions) => user.toMap;

  factory User.fromMap(Map<String, dynamic> map) => User(
      userId: map["user_id"],
      name: map["name"],
      email: map["email"],
      phoneNumber: map["phone_number"],
      about: map["about"],
      lastMessage: map["last_message"],
      status: map["status"] == null ? null : Status.fromMap(map["status"]),
      profileImg: map["profile_img"],
      joinAt: map["join_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map["join_at"]),
      lastActiveAt: map["last_active_at"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map["last_active_at"]));

  Map<String, dynamic> get toMap => {
        "user_id": userId,
        "name": name,
        "email": email,
        "phone_number": phoneNumber,
        "about": about,
        "last_message": lastMessage,
        if (status != null) "status": status?.toMap,
        if (profileImg != null) "profile_img": profileImg,
        if (joinAt != null) "join_at": joinAt!.millisecondsSinceEpoch,
        if (lastActiveAt != null)
          "last_active_at": lastActiveAt!.millisecondsSinceEpoch
      };

  @override
  List<Object?> get props => [
        userId,
        name,
        email,
        phoneNumber,
        about,
        profileImg,
        status,
        lastMessage,
        joinAt,
        lastActiveAt,
      ];
}
