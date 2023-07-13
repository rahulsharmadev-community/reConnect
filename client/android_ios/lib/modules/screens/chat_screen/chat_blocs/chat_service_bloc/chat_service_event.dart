part of 'chat_service_bloc.dart';

@immutable
abstract class ChatServiceEvent {
  static StartSinking startSinking() => StartSinking();
  static SendNewMessage sendNewMessage(Message message) =>
      SendNewMessage(message);
  static EditMessage editMessage(Message message) => EditMessage(message);
  static DeleteMessage deleteMessage(String messageId) =>
      DeleteMessage(messageId);
  static FetchHistoryMessages fetchHistoryMessages([int? batchSize]) =>
      FetchHistoryMessages(batchSize);
}

class StartSinking extends ChatServiceEvent {
  StartSinking();
}

class SendNewMessage extends ChatServiceEvent {
  final Message message;
  SendNewMessage(this.message);
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
  FetchHistoryMessages(int? batchSize) : batchSize = batchSize ?? 15;
}
