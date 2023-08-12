import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:shared/shared.dart';

/// The [ChatroomServiceCubit] manages chatroom-related operations.
/// It handles the `handleChatroomTap` method, responsible for fetching and creating new chatrooms.
/// When creating a new chatroom, it adds the chatroom ID to the members' accounts.
class ChatroomServiceCubit extends Cubit<BlocData<ChatRoomInfo>> {
  final ChatRoomsApi _chatRoomsApi;
  final UserApi _userApi;
  final PrimaryUserBloc _primaryUserBloc;

  ChatroomServiceCubit({
    required PrimaryUserBloc primaryUserBloc,
    required ChatRoomsApi chatRoomsApi,
    required UserApi userApi,
  })  : _primaryUserBloc = primaryUserBloc,
        _chatRoomsApi = chatRoomsApi,
        _userApi = userApi,
        super(const BlocData.idle());

  Future<void> handleChatroomTap(dynamic user, PrimaryUser primaryUser) async {
    if (user is ChatRoomInfo) {
      // If `user` is not of type `User`, emit the result and return.
      emit(BlocData.finished(user));
      return;
    }

    emit(const BlocData.processing());
    ChatRoomInfo createdChatroom = await _chatRoomsApi.createNewChatRoom(
        ChatRoomInfo(
          name: user.name,
          about: user.about,
          profileImg: user.profileImg,
          createdBy: primaryUser.userId,
          members: [primaryUser.userId, user.userId],
        ),
        true);

    _primaryUserBloc.add(PrimaryUserEvent.addingChatRoom(createdChatroom));

    await _userApi.addNewChatRoom_ContactIds(
      [createdChatroom.chatRoomId],
      [createdChatroom.createdBy],
    );
    emit(BlocData.finished(createdChatroom));
  }
}
