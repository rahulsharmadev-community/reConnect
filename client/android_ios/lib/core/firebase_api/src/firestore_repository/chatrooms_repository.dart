import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reConnect/core/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';

class ChatRoomsRepository with FirebaseExceptionHandler {
  final CollectionReference<Map<String, dynamic>> chatRoomCall;
  ChatRoomsRepository()
      : chatRoomCall = FirebaseFirestore.instance.collection('CHATROOMS');

  Future<void> createNewChatRoom(ChatRoomInfo chatroom,
      [Message? initalMessage]) async {
    await errorHandler<void>(() async =>
        await chatRoomCall.doc(chatroom.chatRoomId).set(chatroom.toJson));

    if (initalMessage != null) {
      await MessagesRepository(chatroom.chatRoomId)
          .addNewMessage(initalMessage);
    }
  }

  Future<List<Map<String, dynamic>>> fetchRawChatRoomsByIds(
      List<dynamic> ids) async {
    if (ids.isEmpty) return [];
    final QuerySnapshot<Map<String, dynamic>>? roomSnap =
        await errorHandler<dynamic>(() async =>
            await chatRoomCall.where(FieldPath.documentId, whereIn: ids).get());
    return roomSnap!.docs.map((e) => e.data()).toList();
  }
}
