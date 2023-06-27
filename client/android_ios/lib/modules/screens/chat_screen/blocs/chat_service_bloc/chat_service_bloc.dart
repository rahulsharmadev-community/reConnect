// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';

part 'chat_service_event.dart';
part 'chat_service_state.dart';

class ChatServiceBloc extends Bloc<ChatServiceEvent, ChatServiceState> {
  final String chatRoomId;
  final ChatRoomRepository chatRoomRepository;

  List<Message> get messages =>
      (state is ChatRoomConnected) ? (state as ChatRoomConnected).messages : [];

  ChatServiceBloc(
    this.chatRoomId,
  )   : chatRoomRepository = ChatRoomRepository(chatRoomId),
        super(ChatRoomLoading()) {
    onStartSinking();
    on<AddNewMessage>(onAddNewMessage);
    on<EditMessage>(onEditMessage);
    on<DeleteMessage>(onDeleteMessage);
    on<FetchHistoryMessages>(onFetchHistoryMessage);
  }
  onStartSinking() {
    logs('onStartSinking');
    chatRoomRepository.listenMessages.listen(
      (event) {
        var list = messages;
        if (list.length > 14) list.removeRange(0, 14);
        emit(ChatRoomConnected([
          ...event,
          ...list,
        ]));
      },
    );
  }

  onAddNewMessage(AddNewMessage event, Emitter<ChatServiceState> emit) async {
    await chatRoomRepository.addNewMessage(event.message);
  }

  onEditMessage(EditMessage event, Emitter<ChatServiceState> emit) {}
  onDeleteMessage(DeleteMessage event, Emitter<ChatServiceState> emit) async {
    await chatRoomRepository.deleteMessage(event.messageId);
    var msgs = messages;
    msgs.removeWhere((element) => element.messageId == event.messageId);
    emit(ChatRoomConnected(msgs));
  }

  onFetchHistoryMessage(
      FetchHistoryMessages event, Emitter<ChatServiceState> emit) async {
    if (chatRoomRepository.hasMessages) {
      final list =
          await chatRoomRepository.fetchHistoryMessages(event.batchSize);
      emit(ChatRoomConnected([...messages, ...?list]));
    } else {
      emit(ChatRoomConnected.withAlert(
          messages: [...messages],
          alertMessage: 'No more conversations are available.'));
    }
  }
}
