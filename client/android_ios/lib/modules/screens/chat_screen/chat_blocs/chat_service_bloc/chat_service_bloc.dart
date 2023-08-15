// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logs/logs.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/core/APIs/github_api/github_repository_api.dart';
import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
part 'chat_service_event.dart';
part 'chat_service_state.dart';



class ChatServiceBloc extends Bloc<ChatServiceEvent, ChatServiceState> {
  final String chatRoomId;

  final MessagesApi messageApi;
  final GitHubRepositorysApi gitHubRepositorysApi;
  List<Message> get messages {
    return (state is ChatRoomConnected)
        ? (state as ChatRoomConnected).messages
        : [];
  }

  ChatServiceBloc({
    required this.chatRoomId,
    required this.gitHubRepositorysApi,
  })  : messageApi = MessagesApi(chatRoomId),
        super(ChatRoomLoading()) {
    emit(ChatRoomNotFound());
    onStartSinking();
    on<SendNewMessage>(onAddNewMessage);
    on<EditMessage>(onEditMessage);
    on<DeleteMessage>(onDeleteMessage);
    on<FetchHistoryMessages>(onFetchHistoryMessage);
  }

  void onStartSinking() {
    final list = messages;
    messageApi.listenMessages.listen(
      (event) {
        if (list.length > 14) list.removeRange(0, 14);
        if (!isClosed) emit(ChatRoomConnected([...event, ...list]));
      },
    );
  }

  onAddNewMessage(SendNewMessage event, Emitter<ChatServiceState> emit) async {
    List<Attachment> attachments = [];
    if (event.msg.attachments.isNotEmpty) {
      for (var attach in event.msg.attachments) {
        var filePath = '${attach.ext}/${attach.id}${attach.ext}';
        final url = await gitHubRepositorysApi.gBoard.uploadBytes(
          filePath,
          attach.bytes!,
        );
        attachments.add(attach.copyWith(assetUrl: url));
      }
    }
    await messageApi
        .addNewMessage(event.msg.copyWith(attachments: attachments));
  }

  onEditMessage(EditMessage event, Emitter<ChatServiceState> emit) {}

  onDeleteMessage(DeleteMessage event, Emitter<ChatServiceState> emit) async {
    await messageApi.deleteMessage(event.messageId);
    var msgs = messages;
    msgs.removeWhere((element) => element.messageId == event.messageId);
    emit(ChatRoomConnected(msgs));
  }

  onFetchHistoryMessage(
      FetchHistoryMessages event, Emitter<ChatServiceState> emit) async {
    if (messageApi.hasMessages) {
      final list = await messageApi.fetchHistoryMessages(event.batchSize);
      emit(ChatRoomConnected([...messages, ...?list]));
    } else {
      emit(ChatRoomConnected.withAlert(
          messages: [...messages],
          alertMessage: 'No more conversations are available.'));
    }
  }
}
