// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/core/firebase_bloc/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/core/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
part 'chat_service_event.dart';
part 'chat_service_state.dart';

class ChatServiceBloc extends Bloc<ChatServiceEvent, ChatServiceState> {
  final String chatRoomId;
  final ChatRoomInfo? createChatRoom;
  final PrimaryUserBloc primaryUserBloc;
  final UserRepository userRepository;
  final MessagesRepository messageRoomRepository;
  final ChatRoomsRepository chatRoomsRepository;
  late bool hasMessages;
  List<Message> get messages {
    return (state is ChatRoomConnected)
        ? (state as ChatRoomConnected).messages
        : [];
  }

  ChatServiceBloc({
    this.createChatRoom,
    required this.chatRoomId,
    required this.userRepository,
    required this.primaryUserBloc,
    required this.chatRoomsRepository,
  })  : messageRoomRepository = MessagesRepository(chatRoomId),
        hasMessages = createChatRoom == null,
        super(ChatRoomLoading()) {
    if (hasMessages) onStartSinking();
    emit(ChatRoomNotFound());

    on<SendNewMessage>(onAddNewMessage);
    on<EditMessage>(onEditMessage);
    on<DeleteMessage>(onDeleteMessage);
    on<FetchHistoryMessages>(onFetchHistoryMessage);
  }

  void onStartSinking() {
    var list = messages;
    messageRoomRepository.listenMessages.listen(
      (event) {
        if (list.length > 14) list.removeRange(0, 14);
        emit(ChatRoomConnected([...event, ...list]));
      },
    );
  }

  onAddNewMessage(SendNewMessage event, Emitter<ChatServiceState> emit) async {
    // chat room not exist in database
    if (createChatRoom != null) {
      await chatRoomsRepository.createNewChatRoom(
          createChatRoom!, event.message);

      /// Adding chat room id in primary user account
      primaryUserBloc.add(UpdateChatRooms.byAdding([createChatRoom!]));

      /// Adding chat room id & contact in 2nd user account
      userRepository.addNewChatRoom_ContactIds(
          [createChatRoom!.chatRoomId], [createChatRoom!.createdBy]);

      hasMessages = false;
      onStartSinking();
    }
    await messageRoomRepository.addNewMessage(event.message);
  }

  onEditMessage(EditMessage event, Emitter<ChatServiceState> emit) {}
  onDeleteMessage(DeleteMessage event, Emitter<ChatServiceState> emit) async {
    await messageRoomRepository.deleteMessage(event.messageId);
    var msgs = messages;
    msgs.removeWhere((element) => element.messageId == event.messageId);
    emit(ChatRoomConnected(msgs));
  }

  onFetchHistoryMessage(
      FetchHistoryMessages event, Emitter<ChatServiceState> emit) async {
    if (messageRoomRepository.hasMessages) {
      final list =
          await messageRoomRepository.fetchHistoryMessages(event.batchSize);
      emit(ChatRoomConnected([...messages, ...?list]));
    } else {
      emit(ChatRoomConnected.withAlert(
          messages: [...messages],
          alertMessage: 'No more conversations are available.'));
    }
  }
}
