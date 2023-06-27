part of 'chat_service_bloc.dart';

@immutable
abstract class ChatServiceEvent {}

class StartSinking extends ChatServiceEvent {
  StartSinking();
}

class AddNewMessage extends ChatServiceEvent {
  final Message message;
  AddNewMessage(this.message);
}

class EditMessage extends ChatServiceEvent {
  final Message message;
  EditMessage(this.message);
}

class DeleteMessage extends ChatServiceEvent {
  final String messageId;
  DeleteMessage(this.messageId);
}

class FetchHistoryMessages extends ChatServiceEvent {
  final int batchSize;
  FetchHistoryMessages({this.batchSize = 15});
}
