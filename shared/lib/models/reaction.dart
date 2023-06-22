import 'dart:convert';

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

  factory Reaction.fromJson(String str) => Reaction.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Reaction.fromMap(Map<String, dynamic> json) => Reaction(
        id: json["id"],
        messageId: json["message_id"],
        emoji: json["emoji"],
        createdBy: json["created_by"],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "message_id": messageId,
        "emoji": emoji,
        "created_by": createdBy,
        "created_at": createdAt.millisecondsSinceEpoch,
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
