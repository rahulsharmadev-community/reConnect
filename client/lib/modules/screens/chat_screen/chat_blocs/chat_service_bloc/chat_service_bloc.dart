// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/core/APIs/github_api/github_repository_api.dart';
import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:reConnect/core/services/notifications_service.dart';
import 'package:shared/shared.dart';
part 'chat_service_event.dart';
part 'chat_service_state.dart';

extension ChatServiceBlocExtension on ChatServiceBloc {
  ChatRoomConnected _addNewMsgs(List<Message> msgs) {
    return ChatRoomConnected({
      ...{for (var e in msgs) e.messageId: e},
      ..._messages
    });
  }

  ChatRoomConnected _addPreviousMsgsAtEnd(List<Message> msgs) {
    return ChatRoomConnected({
      ..._messages,
      ...{for (var e in msgs) e.messageId: e},
    });
  }

  ChatRoomConnected _editExistMsg(Message msg) {
    var temp = _messages;
    temp[msg.messageId] = msg;
    return ChatRoomConnected(temp);
  }

  ChatRoomConnected _deleteExistMsg(String msgId) {
    var temp = _messages..remove(msgId);
    return ChatRoomConnected(temp);
  }
}

class ChatServiceBloc extends HydratedBloc<ChatServiceEvent, ChatServiceState> {
  final String chatroomId;
  final PrimaryUser primaryUser;
  final MessagesApi messageApi;
  final GitHubRepositorysApi gitHubRepositorysApi;

  List<Message> get messages => _messages.values.toList();

  Map<String, Message> get _messages {
    return (state is ChatRoomConnected)
        ? (state as ChatRoomConnected)._messages
        : {};
  }

  ChatServiceBloc(
      {required this.chatroomId,
      required this.gitHubRepositorysApi,
      required this.primaryUser})
      : messageApi = MessagesApi(chatroomId),
        super(ChatRoomLoading()) {
    if (_messages.isEmpty) {
      messageApi.fetchHistoryMessages(30).then((value) {
        if (value != null && value.isNotEmpty) {
          emit(_addPreviousMsgsAtEnd(value));
        } else {
          emit(ChatRoomNotFound());
        }
      });
    }

    onStartSinking();
    on<SendNewMessage>(onAddNewMessage);
    on<EditMessage>(onEditMessage);
    on<DeleteMessage>(onDeleteMessage);
    on<FetchHistoryMessages>(onFetchHistoryMessage);
  }

  void onStartSinking() {
    messageApi.listenMessages.listen(
      (msg) {
        if (!isClosed &&
            primaryUser.userId != msg.senderId &&
            state is ChatRoomConnected) {
          super.emit(_addNewMsgs([msg]));
        }
      },
    );
  }

  onAddNewMessage(SendNewMessage event, Emitter<ChatServiceState> emit) async {
    emit(_addNewMsgs([event.msg.copyWith(status: MessageStatus.waiting)]));
    List<Attachment> attachments = [];
    if (event.msg.attachments.isNotEmpty) {
      for (var attach in event.msg.attachments) {
        var filePath =
            '${attach.ext}/${attach.id}.${attach.ext.replaceAll('.', '')}';
        final api = attach.isFromKiC
            ? gitHubRepositorysApi.gBoard
            : gitHubRepositorysApi.pVault;

        final url = await api.uploadBytes(
          filePath,
          attach.bytes!,
        );
        attachments.add(attach.copyWith(assetUrl: url));
      }
    }
    var tempMsg = event.msg.copyWith(
      attachments: attachments,
      status: MessageStatus.sent,
    );
    await messageApi.addNewMessage(tempMsg);
    emit(_editExistMsg(tempMsg));
    var receiverIds =
        List<String>.from(primaryUser.chatRooms[chatroomId]!.members)
          ..remove(primaryUser.userId);

    NotificationService.instance.sendMessagingNotification(
        token: receiverIds.length == 1 ? receiverIds.first : null,
        topic: receiverIds.length > 1 ? chatroomId : null,
        senderName: primaryUser.name,
        msg: event.msg,
        chatRoomId: chatroomId,
        chatRoomName: primaryUser.chatRooms[chatroomId]!.name);
  }

  onEditMessage(EditMessage event, Emitter<ChatServiceState> emit) {}

  onDeleteMessage(DeleteMessage event, Emitter<ChatServiceState> emit) async {
    await messageApi.deleteMessage(event.messageId);
    emit(_deleteExistMsg(event.messageId));
  }

  onFetchHistoryMessage(
      FetchHistoryMessages event, Emitter<ChatServiceState> emit) async {
    if (messageApi.hasMessages) {
      final list = await messageApi.fetchHistoryMessages(event.batchSize);
      if (list != null && list.isNotEmpty) emit(_addPreviousMsgsAtEnd(list));
    } else {
      emit(ChatRoomConnected.withAlert(_messages,
          alertMessage: 'No more conversations are available.'));
    }
  }

  @override
  ChatServiceState? fromJson(Map<String, dynamic> json) {
    return ChatServiceState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ChatServiceState state) => state.toJson();
}
