// ignore_for_file: camel_case_types

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/modules/screens/chat_screen/utils/chat_services.dart';
import 'package:shared/shared.dart';

@immutable
abstract class ChatHandlerState {}

class CHS_Initial extends ChatHandlerState {}

@immutable
abstract class ChatHandlerEvent {}

class CHE_OnReply extends ChatHandlerEvent {
  final Message message;
  CHE_OnReply(this.message);
}

class ChatHandlerBloc extends Bloc<ChatHandlerEvent, ChatHandlerState> {
  final ChatServices chatServices;

  ChatHandlerBloc({required this.chatServices}) : super(CHS_Initial()) {
    logs('ChatHandlerBloc Created');
    on<CHE_OnReply>((event, emit) {
      chatServices.inputFocusNode.requestFocus();
    });
  }
  @override
  Future<void> close() {
    chatServices.dispose();
    return super.close();
  }
}
