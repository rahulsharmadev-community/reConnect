// ignore_for_file: camel_case_types

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:shared/shared.dart';
import '../utils/chat_input_services.dart';

@immutable
abstract class InputHandlerState {}

class ReplyState extends InputHandlerState {
  final Message message;

  ReplyState(this.message);
}

class IdleState extends InputHandlerState {}

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

// InputHandlerBloc is used to handle user inputs, which are
// typically text field-based, as well as other actions.
class InputHandlerBloc extends Bloc<InputHandlerEvent, InputHandlerState> {
  final InputUtils inputUtils;

  InputHandlerBloc({required this.inputUtils}) : super(IdleState()) {
    // Inital or Idle state
    on<OnIdle>((event, emit) => emit(IdleState()));

    // triggered when a message is sent as a reply message.
    on<OnReplyHandler>((event, emit) {
      inputUtils.inputFocusNode.requestFocus();
      emit(ReplyState(event.message));
    });

    // triggered when normal message send
    on<OnMessageSendHandler>((event, emit) {
      inputUtils.inputController.clear();
      inputUtils.inputFocusNode.unfocus();

      if (inputUtils.chatScrollController.offset != 0) {
        logs('Scroll down at index 0');
        inputUtils.chatScrollController.animateTo(0,
            duration: 1000.milliseconds, curve: Curves.fastLinearToSlowEaseIn);
      }
      emit(IdleState());
    });
  }
  @override
  Future<void> close() {
    inputUtils.dispose();
    return super.close();
  }
}
