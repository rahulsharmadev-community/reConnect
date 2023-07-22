import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reConnect/core/APIs/firebase_api/firebase_api.dart';
import 'package:shared/models/models.dart';
import 'package:shared/shared.dart';

class MessagesRepository with FirebaseExceptionHandler {
  final String chatRoomId;
  final CollectionReference<Map<String, dynamic>> chatRoomsColl;
  late DocumentSnapshot<Object?> lastDocument;

  bool _hasMessages = true;
  bool get hasMessages => _hasMessages;
  MessagesRepository(this.chatRoomId)
      : chatRoomsColl = FirebaseFirestore.instance
            .collection('CHATROOMS')
            .doc(chatRoomId)
            .collection('messages');

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

  Future<void> addNewMessage(Message msg) async {
    await errorHandler<void>(() async =>
        await chatRoomsColl.doc(msg.messageId).set(msg.toMap));
  }

  Future<void> editMessage(Message msg) async {
    await errorHandler<void>(() async =>
        await chatRoomsColl.doc(msg.messageId).update(msg.toMap));
  }

  Future<void> deleteMessage(String messageId) async {
    await errorHandler<void>(
        () async => await chatRoomsColl.doc(messageId).delete());
  }

  Future<List<Message>?> fetchHistoryMessages(int limit) async {
    var raw = await errorHandler<QuerySnapshot<Map<String, dynamic>>>(
        () async => await chatRoomsColl
            .orderBy('updateAt', descending: true)
            .startAfterDocument(lastDocument)
            .limit(limit)
            .get());

    if (raw == null || raw.size == 0) {
      _hasMessages = false;
      return null;
    }

    lastDocument = raw.docs.last;
    return raw.docs.map((e) => Message.fromMap(e.data())).toList();
  }
}
