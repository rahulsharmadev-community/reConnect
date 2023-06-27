part of 'chat_service_bloc.dart';

@immutable
abstract class ChatServiceState {}

class ChatRoomLoading extends ChatServiceState {}

class ChatRoomNotFound extends ChatServiceState {}

class ChatRoomConnectionError extends ChatServiceState {
  final String errorMessage;
  ChatRoomConnectionError(this.errorMessage);
}

class ChatRoomConnected extends ChatServiceState {
  final List<Message> messages;
  final String? alertMessage;

  ChatRoomConnected(this.messages) : alertMessage = null;
  ChatRoomConnected.withAlert(
      {required this.messages, required this.alertMessage});
}
