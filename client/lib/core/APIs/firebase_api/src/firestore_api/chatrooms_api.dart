import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:shared/shared.dart';
import '../error_handler.dart';

typedef QuerySnap = QuerySnapshot<Map<String, dynamic>>;
typedef QueryDocSnap = QueryDocumentSnapshot<Map<String, dynamic>>;

class ChatRoomsApi with FirebaseExceptionHandler {
  final CollectionReference<Map<String, dynamic>> chatRoomCall;
  ChatRoomsApi()
      : chatRoomCall = FirebaseFirestore.instance.collection('CHATROOMS');

  /// Behavior:
  /// - If [isOneToOne] is true and chatroom already exists,
  ///   return the latest information of that chatroom.
  ///
  /// - If chatroom does not exist, it will create a new chatroom
  ///   using the provided chatroom and return the same [ChatRoomInfo].
  ///
  /// - If initialMessage is not null, it will send this message in the new/exist chatroom.
  Future<ChatRoomInfo> createNewChatRoom(
    ChatRoomInfo chatroom,
    bool isOneToOne, [
    Message? initalMessage,
  ]) async {
    ChatRoomInfo? result;

    // Check if the chatroom has only two members.
    if (isOneToOne) {
      var resp = await errorHandler<QuerySnap>(() async => await chatRoomCall
          .where('members', whereIn: [
            chatroom.members,
            chatroom.members.reversed,
          ])
          .where('isOneToOne', isEqualTo: true)
          .get());

      // If the response is not null and contains only one chatroom
      // that matches the above criteria,
      if (resp!.size == 1) {
        result = ChatRoomInfo.fromMap(resp.docs.first.data());
      }
    }

    // Create or overwriting any existing ChatRoomInfo data on the document.
    if (result == null) {
      await errorHandler<void>(() async =>
          await chatRoomCall.doc(chatroom.chatRoomId).set(chatroom.toMap));
      result = chatroom;
    }

    if (initalMessage != null) {
      await MessagesApi(result.chatRoomId).addNewMessage(initalMessage);
    }
    return result;
  }

  Future<Map<String, ChatRoomInfo>> fetchChatRoomsByIds(
      List<dynamic> ids) async {
    if (ids.isEmpty) return {};
    final QuerySnap? roomSnap = await errorHandler<QuerySnap>(() async =>
        await chatRoomCall.where(FieldPath.documentId, whereIn: ids).get());

    return {
      for (var e in roomSnap?.docs ?? []) e.id: ChatRoomInfo.fromMap(e.data())
    };
  }
}
