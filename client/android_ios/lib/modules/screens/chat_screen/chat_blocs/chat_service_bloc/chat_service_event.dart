part of 'chat_service_bloc.dart';

@immutable
abstract class ChatServiceEvent {
  static StartSinking startSinking() => StartSinking();
  static SendNewMessage sendNewMessage(Message msg) =>
      SendNewMessage(msg);
  static EditMessage editMessage(Message msg) => EditMessage(msg);
  static DeleteMessage deleteMessage(String messageId) =>
      DeleteMessage(messageId);
  static FetchHistoryMessages fetchHistoryMessages([int? batchSize]) =>
      FetchHistoryMessages(batchSize);
}

class StartSinking extends ChatServiceEvent {
  StartSinking();
}

class SendNewMessage extends ChatServiceEvent {
  final Message msg;
  SendNewMessage(this.msg);
}

class EditMessage extends ChatServiceEvent {
  final Message msg;
  EditMessage(this.msg);
}

class DeleteMessage extends ChatServiceEvent {
  final String messageId;
  DeleteMessage(this.messageId);
}

class FetchHistoryMessages extends ChatServiceEvent {
  final int batchSize;
  FetchHistoryMessages(int? batchSize) : batchSize = batchSize ?? 15;
}
