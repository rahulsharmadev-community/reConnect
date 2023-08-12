
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Reaction extends Equatable {
  Reaction({
    String? id,
    required this.messageId,
    required this.emoji,
    required this.createdBy,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String messageId;
  final String emoji;

  /// user_id who will create a reaction.
  final String createdBy;

  /// Reserved field indicating when the reaction was created.
  final DateTime createdAt;

  Reaction copyWith({
    String? id,
    String? messageId,
    String? emoji,
    String? createdBy,
    DateTime? createdAt,
  }) =>
      Reaction(
        id: id ?? this.id,
        messageId: messageId ?? this.messageId,
        emoji: emoji ?? this.emoji,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Reaction.fromMap(Map<String, dynamic> json) => Reaction(
        id: json["id"],
        messageId: json["messageId"],
        emoji: json["emoji"],
        createdBy: json["createdBy"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"]),
      );

  Map<String, dynamic> get toMap => {
        "id": id,
        "messageId": messageId,
        "emoji": emoji,
        "createdBy": createdBy,
        "createdAt": createdAt.millisecondsSinceEpoch,
      };

  @override
  List<Object?> get props => [
        id,
        messageId,
        emoji,
        createdBy,
        createdAt,
      ];
}
