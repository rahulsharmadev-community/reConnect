part of 'input_handler_bloc.dart';

// Possible state
@immutable
class InputHandlerState {
  final Message? replyMsg;
  final KeyboardInsertedContent? kiC;

  bool get hasKiC => kiC != null;
  bool get hasReplyMsg => replyMsg != null;
  const InputHandlerState._(this.replyMsg, this.kiC);

  factory InputHandlerState.idle() => const InputHandlerState._(null, null);

  InputHandlerState copyWith({
    Message? replyMsg,
    KeyboardInsertedContent? kiC,
  }) =>
      InputHandlerState._(
        replyMsg ?? this.replyMsg,
        kiC ?? this.kiC,
      );
}

/// Available Events
/// ```
/// OnIdle
/// OnMessageSendHandler
/// OnKiCHandler
/// OnReplyHandler
/// ```
@immutable
abstract class InputHandlerEvent {
  static OnIdle onIdle() => OnIdle();
}

class OnIdle extends InputHandlerEvent {}

class OnMessageSendHandler extends InputHandlerEvent {
  final List<Attachment>? attachments;
  OnMessageSendHandler([this.attachments]);
}

class OnKiCHandler extends InputHandlerEvent {
  final KeyboardInsertedContent kiC;

  OnKiCHandler.add(this.kiC) : isRemoveRequest = false;
  OnKiCHandler.remove(this.kiC) : isRemoveRequest = true;
  final bool isRemoveRequest;
}

class OnReplyHandler extends InputHandlerEvent {
  final Message? msg;
  OnReplyHandler.add(Message this.msg);
  OnReplyHandler.remove() : msg = null;

  bool get isRemoveRequest => msg == null;
}
