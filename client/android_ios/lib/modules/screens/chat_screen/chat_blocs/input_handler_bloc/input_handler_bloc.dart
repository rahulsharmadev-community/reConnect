// ignore_for_file: camel_case_types

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:reConnect/modules/screens/chat_screen/utils/chat_input_services.dart';
import 'package:shared/shared.dart';

import '../chat_service_bloc/chat_service_bloc.dart';
part 'input_state_events.dart';

// InputHandlerBloc is used to handle user inputs, which are
// typically text field-based, as well as other actions.
class InputHandlerBloc extends Bloc<InputHandlerEvent, InputHandlerState> {
  final InputUtils inputUtils;
  final ChatServiceBloc chatServiceBloc;

  InputHandlerBloc({required this.inputUtils, required this.chatServiceBloc})
      : super(IdleState()) {
    inputUtils.chatScrollController.addListener(_trackingController);

    // Inital or Idle state
    on<OnIdle>((event, emit) => emit(IdleState()));

    // triggered when a message is sent as a reply message.
    on<OnReplyHandler>((event, emit) {
      inputUtils.inputFocusNode.requestFocus();
      emit(ReplyState(event.message));
    });

    // triggered when normal message send
    on<OnMessageSendHandler>((event, emit) {
      chatServiceBloc.add(SendNewMessage(event.message));

      inputUtils.inputController.clear();
      inputUtils.inputFocusNode.unfocus();

      if (inputUtils.chatScrollController.hasClients &&
          inputUtils.chatScrollController.offset != 0) {
        logs('Scroll down at index 0');
        inputUtils.chatScrollController.animateTo(0,
            duration: 1000.milliseconds, curve: Curves.fastLinearToSlowEaseIn);
      }
      emit(IdleState());
    });
  }

  void _trackingController() {
    var position = inputUtils.chatScrollController.position;
    if (position.pixels == position.maxScrollExtent) {
      _loadNextBatch();
    }
  }

  void _loadNextBatch() {
    logs('load Next Batch..');
    chatServiceBloc.add(FetchHistoryMessages());
  }

  @override
  Future<void> close() {
    inputUtils.dispose();
    chatServiceBloc.close();
    return super.close();
  }
}
