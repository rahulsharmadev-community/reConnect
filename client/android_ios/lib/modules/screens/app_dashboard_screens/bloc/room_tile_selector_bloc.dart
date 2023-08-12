import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:reConnect/core/BLOCs/primary_user_bloc/primary_user_bloc.dart';
import 'package:shared/models/models.dart';

part 'room_tile_selector_state.dart';

class ChatRoomTileSelectorCubit extends Cubit<ChatRoomTileState> {
  final PrimaryUserBloc primaryUserBloc;
  ChatRoomTileSelectorCubit(this.primaryUserBloc) : super(ChatRoomTileIdle());

  bool get isSelected => state is ChatRoomTileSelected;

  List<String> get chatroomIds => state is ChatRoomTileSelected
      ? (state as ChatRoomTileSelected).chatroomIds
      : [];

  void selectRooms(Iterable<String> roomId) {
    emit(ChatRoomTileSelected({...chatroomIds, ...roomId}));
  }

  void unSelectRooms(Iterable<String> roomId) {
    var list = Set<String>.from(chatroomIds).difference(Set.from(roomId));
    emit(ChatRoomTileSelected(list));

    if (chatroomIds.isEmpty) {
      emit(ChatRoomTileIdle());
    }
  }

  void removeRooms(List<ChatRoomInfo> rooms) {
    primaryUserBloc.add(PrimaryUserEvent.removingChatRooms(rooms));
    emit(ChatRoomTileIdle());
  }

  void unSelectAll() => emit(ChatRoomTileIdle());
}
