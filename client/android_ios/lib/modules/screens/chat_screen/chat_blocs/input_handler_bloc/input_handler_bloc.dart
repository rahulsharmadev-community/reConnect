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
  Message _msg;
  Message get msg => _msg;

  InputHandlerBloc(
      {required this.inputUtils,
      required this.chatServiceBloc,
      required Message initalMsg})
      : _msg = initalMsg,
        super(InputHandlerState.idle()) {
    inputUtils.chatScrollController.addListener(_trackingScrollController);

    // Inital or Idle state
    on<OnIdle>((event, emit) => emit(InputHandlerState.idle()));

    // triggered when a message is sent as a reply message.
    on<OnReplyHandler>((replyHandler, emit) {
      _msg = _msg.copyWith(reply: replyHandler.msg);
      inputUtils.inputFocusNode.requestFocus();

      replyHandler.isRemoveRequest
          ? emit(state.copyWith(replyMsg: null))
          : emit(state.copyWith(replyMsg: replyHandler.msg));
    });

    // triggered when tap on Keyboard Inserted Content.
    on<OnKiCHandler>((kiCHandler, emit) {
      var oldAtts = _msg.attachments;
      var att = Attachment.fromKiC(kiCHandler.kiC)!;
      if (kiCHandler.isRemoveRequest) oldAtts.remove(att);
      _msg = _msg.copyWith(attachments: [
        ...oldAtts,
        if (!kiCHandler.isRemoveRequest) att,
      ]);
      inputUtils.inputFocusNode.requestFocus();

      kiCHandler.isRemoveRequest
          ? emit(state.copyWith(kiC: null))
          : emit(state.copyWith(kiC: kiCHandler.kiC));
    });

    // triggered when normal message send
    on<OnMessageSendHandler>((event, emit) {
      /// Add text from inputController
      _msg = _msg.copyWith(text: inputUtils.inputController.text);

      chatServiceBloc.add(ChatServiceEvent.sendNewMessage(_msg));

      inputUtils.inputController.clear();
      inputUtils.inputFocusNode.unfocus();

      if (inputUtils.chatScrollController.hasClients &&
          inputUtils.chatScrollController.offset != 0) {
        inputUtils.chatScrollController.animateTo(0,
            duration: 1000.milliseconds, curve: Curves.fastLinearToSlowEaseIn);
      }
      _msg = _msg.reset();
      emit(InputHandlerState.idle());
    });
  }

  void _trackingScrollController() {
    var position = inputUtils.chatScrollController.position;
    if (position.pixels == position.maxScrollExtent) {
      _loadNextBatch();
    }
  }

  void _loadNextBatch() {
    chatServiceBloc.add(ChatServiceEvent.fetchHistoryMessages());
  }

  @override
  Future<void> close() {
    inputUtils.dispose();
    chatServiceBloc.close();
    return super.close();
  }
}
