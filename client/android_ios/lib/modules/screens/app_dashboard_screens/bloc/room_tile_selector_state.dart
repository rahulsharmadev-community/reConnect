part of 'room_tile_selector_bloc.dart';

@immutable
abstract class ChatRoomTileState {}

class ChatRoomTileSelected extends ChatRoomTileState {
  final Set<String> _chatroomIds;
  ChatRoomTileSelected(this._chatroomIds);
  List<String> get chatroomIds => _chatroomIds.toList();
}

class ChatRoomTileIdle extends ChatRoomTileState {}
