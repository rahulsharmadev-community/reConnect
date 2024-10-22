import 'package:equatable/equatable.dart';
import 'primary_user.dart';

class User extends Equatable {
  const User({
    required this.userId,
    required this.name,
    required this.fCMid,
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
  final String fCMid;
  final String? email;
  final String? phoneNumber;
  final String? about;
  final String? profileImg;
  final String? lastMessage;
  final Map<String, Status>? status;

  final DateTime? joinAt;
  final DateTime? lastActiveAt;

  User copyWith({
    String? userId,
    String? name,
    String? fCMid,
    String? email,
    String? phoneNumber,
    String? about,
    String? lastMessage,
    Map<String, Status>? status,
    String? profileImg,
    DateTime? joinAt,
    DateTime? lastActiveAt,
  }) =>
      User(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        fCMid: fCMid ?? this.fCMid,
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

  factory User.fromMap(Map<String, dynamic> map) {
    var status =
        List<Status>.from((map["status"] ?? []).map((x) => Status.fromMap(x)));

    return User(
        userId: map["userId"],
        name: map["name"],
        fCMid: map["fCMid"],
        email: map["email"],
        phoneNumber: map["phoneNumber"],
        about: map["about"],
        lastMessage: map["lastMessage"],
        status: Map.fromIterable(status, key: (e) => e.id),
        profileImg: map["profileImg"],
        joinAt: map["joinAt"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map["joinAt"]),
        lastActiveAt: map["lastActiveAt"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(map["lastActiveAt"]));
  }

  Map<String, dynamic> get toMap => {
        "userId": userId,
        "name": name,
        "fCMid": fCMid,
        "email": email,
        "phoneNumber": phoneNumber,
        "about": about,
        "lastMessage": lastMessage,
        "status": status?.values.map((x) => x.toMap).toList(),
        if (profileImg != null) "profileImg": profileImg,
        if (joinAt != null) "joinAt": joinAt!.millisecondsSinceEpoch,
        if (lastActiveAt != null)
          "lastActiveAt": lastActiveAt!.millisecondsSinceEpoch
      };

  @override
  List<Object?> get props => [
        userId,
        name,
        fCMid,
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
