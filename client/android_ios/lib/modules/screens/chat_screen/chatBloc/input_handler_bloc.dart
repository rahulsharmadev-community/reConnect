// ignore_for_file: camel_case_types

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:shared/shared.dart';
import '../chatdata.dart';
import '../utils/chat_services.dart';

@immutable
abstract class InputHandlerState {}

class IHS_OnReply extends InputHandlerState {
  final Message message;

  IHS_OnReply(this.message);
}

class IHS_Initial extends InputHandlerState {}

@immutable
abstract class InputHandlerEvent {}

class IHE_Idle extends InputHandlerEvent {}

class IHE_OnMessageSend extends InputHandlerEvent {
  final Message message;
  IHE_OnMessageSend(this.message);
}

class IHE_OnReply extends InputHandlerEvent {
  final Message message;

  IHE_OnReply(this.message);
}

class InputHandlerBloc extends Bloc<InputHandlerEvent, InputHandlerState> {
  final ChatServices chatServices;

  InputHandlerBloc({required this.chatServices}) : super(IHS_Initial()) {
    on<IHE_Idle>((event, emit) => emit(IHS_Initial()));
    on<IHE_OnReply>((event, emit) => emit(IHS_OnReply(event.message)));
    on<IHE_OnMessageSend>((event, emit) {
      // screen not rebuild or update. because chats is static list
      chats.insert(0, event.message);
      chatServices.inputController.clear();
      chatServices.inputFocusNode.unfocus();

      if (chatServices.chatScrollController.offset != 0) {
        logs('Scroll down at index 0');
        chatServices.chatScrollController.animateTo(0,
            duration: 1000.milliseconds, curve: Curves.fastLinearToSlowEaseIn);
      }
      emit(IHS_Initial());
    });
  }
  @override
  Future<void> close() {
    chatServices.dispose();
    return super.close();
  }
}
