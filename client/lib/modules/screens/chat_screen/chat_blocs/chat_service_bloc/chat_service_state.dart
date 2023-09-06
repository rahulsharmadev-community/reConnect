part of 'chat_service_bloc.dart';

@immutable
abstract class ChatServiceState {
  static ChatServiceState? fromJson(Map<String, dynamic> json) {
    switch (json['state']) {
      case 'ChatRoomLoading':
        return ChatRoomLoading();
      case 'ChatRoomNotFound':
        return ChatRoomNotFound();
      case 'ChatRoomConnectionError':
        return ChatRoomConnectionError.fromJson(json);
      default:
        return ChatRoomConnected.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}

class ChatRoomLoading extends ChatServiceState {
  @override
  Map<String, dynamic> toJson() => {'state': 'ChatRoomLoading'};
}

class ChatRoomNotFound extends ChatServiceState {
  @override
  Map<String, dynamic> toJson() => {'state': 'ChatRoomNotFound'};
}

class ChatRoomConnectionError extends ChatServiceState {
  final String errorMessage;
  ChatRoomConnectionError(this.errorMessage);

  @override
  Map<String, dynamic> toJson() =>
      {'state': 'ChatRoomConnectionError', 'errorMessage': errorMessage};

  factory ChatRoomConnectionError.fromJson(Map<String, dynamic> json) {
    return ChatRoomConnectionError(json['errorMessage']);
  }
}

class ChatRoomConnected extends ChatServiceState {
  final Map<String, Message> _messages;
  final String? alertMessage;
  List<Message> get messages => _messages.values.toList();

  ChatRoomConnected(this._messages) : alertMessage = null;
  ChatRoomConnected.withAlert(this._messages, {required this.alertMessage});

  @override
  Map<String, dynamic> toJson() => {
        'state': 'ChatRoomConnected',
        'messages': _messages.map((key, value) => MapEntry(key, value.toMap))
      };

  factory ChatRoomConnected.fromJson(Map<String, dynamic> json) {
    return ChatRoomConnected(
      (json['messages'] as Map).map(
        (key, value) => MapEntry(key, Message.fromMap(value)),
      ),
    );
  }
}
