import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/core/APIs/firebase_api/src/firestore_api/chatrooms_api.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:reConnect/modules/screens/chatroom_editor_screen/bloc/input_utils.dart';
import 'package:shared/shared.dart';

part 'input_handler_state.dart';

class InputHandlerCubit extends Cubit<InputHandlerCubitState> {
  final ChatRoomEditorInputUtils utils;
  final PrimaryUserBloc primaryUserBloc;
  final ChatRoomsApi chatRoomsApi;
  final bool isEditing;

  bool get hasReadyForSubmit =>
      utils.nameController.text.isNotEmpty && state.administrators.isEmpty;

  InputHandlerCubit({
    required this.utils,
    required this.primaryUserBloc,
    required this.chatRoomsApi,
    required this.isEditing,
  }) : super(const InputHandlerCubitState());

  Future<void> submit() async {
    try {
      if (hasReadyForSubmit) {
        final room = ChatRoomInfo(
            createdBy: primaryUserBloc.primaryUser!.userId,
            about: utils.descriptionController.text,
            profileImg: utils.profileImg.text,
            name: utils.nameController.text,
            administrators: state.administrators,
            members: state.members,
            moderators: state.moderators,
            visitor: state.visitors);

        await chatRoomsApi.createNewChatRoom(room, false);
        primaryUserBloc.add(PrimaryUserEvent.addingChatRoom(room));
      }
    } catch (e) {
      throw '$e';
    }
  }

  void addTo({required ChatRoomRole role, required String userId}) {
    removeFrom(userId: userId);
    emit(InputHandlerCubitState(
      administrators: [
        ...state.administrators,
        if (role == ChatRoomRole.administrators) userId
      ],
      moderators: [
        ...state.moderators,
        if (role == ChatRoomRole.moderators) userId
      ],
      members: [...state.members, if (role == ChatRoomRole.members) userId],
      visitors: [...state.visitors, if (role == ChatRoomRole.visitor) userId],
    ));
  }

  void removeFrom({required String userId}) {
    var admins = List<String>.from(state.administrators)..remove(userId);
    var moderators = List<String>.from(state.moderators)..remove(userId);
    var members = List<String>.from(state.members)..remove(userId);
    var visitors = List<String>.from(state.visitors)..remove(userId);
    emit(InputHandlerCubitState(
      administrators: admins,
      members: members,
      moderators: moderators,
      visitors: visitors,
    ));
  }

  @override
  Future<void> close() {
    utils.dispose();
    return super.close();
  }
}
