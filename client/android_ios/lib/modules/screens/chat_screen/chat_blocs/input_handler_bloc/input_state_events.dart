part of 'input_handler_bloc.dart';

// Possible state
@immutable
abstract class InputHandlerState {}

class ReplyState extends InputHandlerState {
  final Message message;

  ReplyState(this.message);
}

class IdleState extends InputHandlerState {}

class LoadingNextBatch extends InputHandlerState {}

// Events
@immutable
abstract class InputHandlerEvent {}

class OnIdle extends InputHandlerEvent {}

class OnMessageSendHandler extends InputHandlerEvent {
  final Message message;
  OnMessageSendHandler(this.message);
}

class OnReplyHandler extends InputHandlerEvent {
  final Message message;
  OnReplyHandler(this.message);
}
