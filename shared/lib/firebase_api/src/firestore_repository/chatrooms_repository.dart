import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';

class ChatRoomsRepository {
  final CollectionReference<Map<String, dynamic>> chatRoomCall;
  ChatRoomsRepository()
      : chatRoomCall = FirebaseFirestore.instance.collection('CHATROOMS');

  Future<void> createNewChatRoom(ChatRoomInfo chatroom,
      [Message? initalMessage]) async {
    await chatRoomCall.doc(chatroom.chatRoomId).set(chatroom.toJson);
    if (initalMessage != null) {
      await MessagesRepository(chatroom.chatRoomId)
          .addNewMessage(initalMessage);
    }
  }

  Future<List<ChatRoomInfo>> fetchChatRoomsByIds(List<dynamic> ids) async {
    final roomSnap =
        await chatRoomCall.where(FieldPath.documentId, whereIn: ids).get();

    return roomSnap.docs.map((e) => ChatRoomInfo.fromJson(e.data())).toList();
  }
}
