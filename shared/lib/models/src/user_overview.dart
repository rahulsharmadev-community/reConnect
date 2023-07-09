import 'package:equatable/equatable.dart';
import 'primary_user.dart';

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

  // static User fromFirestore(
  //         DocumentSnapshot<Map<String, dynamic>> snapshot, options) =>
  //     User.fromMap(snapshot.data() ?? {});

  // static Map<String, dynamic> toFirestore(User user, setOptions) => user.toMap;

  factory User.fromMap(Map<String, dynamic> map) => User(
      userId: map["userId"],
      name: map["name"],
      email: map["email"],
      phoneNumber: map["phoneNumber"],
      about: map["about"],
      lastMessage: map["lastMessage"],
      status: map["status"] == null ? null : Status.fromMap(map["status"]),
      profileImg: map["profileImg"],
      joinAt: map["joinAt"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map["joinAt"]),
      lastActiveAt: map["lastActiveAt"] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map["lastActiveAt"]));

  Map<String, dynamic> get toMap => {
        "userId": userId,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "about": about,
        "lastMessage": lastMessage,
        if (status != null) "status": status?.toMap,
        if (profileImg != null) "profileImg": profileImg,
        if (joinAt != null) "joinAt": joinAt!.millisecondsSinceEpoch,
        if (lastActiveAt != null)
          "lastActiveAt": lastActiveAt!.millisecondsSinceEpoch
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
