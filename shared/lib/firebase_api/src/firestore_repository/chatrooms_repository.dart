import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/_models.dart';
import 'package:shared/shared.dart';

class ChatRoomRepository {
  final String chatRoomId;
  final DocumentReference<Map<String, dynamic>> chatRoomsColl;
  late DocumentSnapshot<Object?> lastDocument;

  bool _hasMessages = true;
  get hasMessages => _hasMessages;
  ChatRoomRepository(this.chatRoomId)
      : chatRoomsColl = FirebaseFirestore.instance
            .collection('CHATROOMS')
            .doc(chatRoomId) {}

  Stream<List<Message>> get listenMessages => chatRoomsColl
          .collection('messages')
          .orderBy('update_at', descending: true)
          .limit(15)
          .snapshots()
          .map(
        (event) {
          if (event.docs.isNotEmpty) lastDocument = event.docs.last;
          return event.docs.map((e) => Message.fromMap(e.data())).toList();
        },
      );

  Future<void> addNewMessage(Message message) async {
    await chatRoomsColl
        .collection('messages')
        .doc(message.messageId)
        .set(message.toMap);
  }

  Future<void> editMessage(Message message) async {
    await chatRoomsColl
        .collection('messages')
        .doc(message.messageId)
        .set(message.toMap);
  }

  Future<void> deleteMessage(String messageId) async {
    await chatRoomsColl.collection('messages').doc(messageId).delete();
  }

  Future<List<Message>?> fetchHistoryMessages(int limit) async {
    var raw = await chatRoomsColl
        .collection('messages')
        .orderBy('update_at', descending: true)
        .startAfterDocument(lastDocument)
        .limit(limit)
        .get();

    if (raw.size < limit) {
      _hasMessages = false;
    }

    lastDocument = raw.docs.last;
    return raw.docs.map((e) => Message.fromMap(e.data())).toList();
  }
}
