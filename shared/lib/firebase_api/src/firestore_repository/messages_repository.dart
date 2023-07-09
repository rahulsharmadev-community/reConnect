import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/models.dart';
import 'package:shared/shared.dart';

class MessagesRepository {
  final String chatRoomId;
  final CollectionReference<Map<String, dynamic>> chatRoomsColl;
  late DocumentSnapshot<Object?> lastDocument;

  bool _hasMessages = true;
  get hasMessages => _hasMessages;
  MessagesRepository(this.chatRoomId)
      : chatRoomsColl = FirebaseFirestore.instance
            .collection('CHATROOMS')
            .doc(chatRoomId)
            .collection('messages') {}

  /// Stream 15 Messages
  Stream<List<Message>> get listenMessages => chatRoomsColl
          .orderBy('updateAt', descending: true)
          .limit(15)
          .snapshots()
          .map(
        (event) {
          if (event.docs.isNotEmpty) lastDocument = event.docs.last;
          return event.docs.map((e) => Message.fromMap(e.data())).toList();
        },
      );

  Future<void> addNewMessage(Message message) async {
    await chatRoomsColl.doc(message.messageId).set(message.toMap);
  }

  Future<void> editMessage(Message message) async {
    await chatRoomsColl.doc(message.messageId).update(message.toMap);
  }

  Future<void> deleteMessage(String messageId) async {
    await chatRoomsColl
      ..doc(messageId).delete();
  }

  Future<List<Message>?> fetchHistoryMessages(int limit) async {
    var raw = await chatRoomsColl
        .orderBy('updateAt', descending: true)
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
