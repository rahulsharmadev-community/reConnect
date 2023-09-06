import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/models.dart';
import 'package:shared/shared.dart';
import '../error_handler.dart';

class MessagesApi with FirebaseExceptionHandler {
  final String chatRoomId;
  final CollectionReference<Map<String, dynamic>> chatRoomsColl;
  DocumentSnapshot<Object?>? lastDocument;

  bool _hasMessages = true;

  /// A flag indicating if there are more messages available for pagination.
  bool get hasMessages => _hasMessages;

  MessagesApi(this.chatRoomId)
      : chatRoomsColl = FirebaseFirestore.instance
            .collection('CHATROOMS')
            .doc(chatRoomId)
            .collection('messages');

  /// Returns a [Stream] of the latest 15 messages for the chatroom.
  Stream<Message> get listenMessages => chatRoomsColl
          .orderBy('updateAt', descending: true)
          .limit(1)
          .snapshots()
          .map(
        (event) {
          if (event.docs.isNotEmpty) lastDocument = event.docs.last;
          return Message.fromMap(event.docs.first.data());
        },
      );

  /// Add a new [Message] to the chatroom messages
  Future<void> addNewMessage(Message msg) async {
    await errorHandler<void>(
        () async => await chatRoomsColl.doc(msg.messageId).set(msg.toMap));
  }

  /// Updates an existing [Message] in the chatroom messages
  Future<void> editMessage(Message msg) async {
    await errorHandler<void>(
        () async => await chatRoomsColl.doc(msg.messageId).update(msg.toMap));
  }

  /// Deletes a [Message] from the chatroom messages
  Future<void> deleteMessage(String messageId) async =>
      await errorHandler<void>(chatRoomsColl.doc(messageId).delete);

  /// Fetches the history of previous messages for pagination.
  Future<List<Message>?> fetchHistoryMessages(int limit) async {
    var raw = await errorHandler<QuerySnapshot<Map<String, dynamic>>>(() async {
      return lastDocument != null
          ? await chatRoomsColl
              .orderBy('updateAt', descending: true)
              .startAfterDocument(lastDocument!)
              .limit(limit)
              .get()
          : await chatRoomsColl
              .orderBy('updateAt', descending: true)
              .limit(limit)
              .get();
    });

    if (raw == null || raw.size == 0) {
      _hasMessages = false;
      return null;
    }

    lastDocument = raw.docs.last;
    return raw.docs.map((e) => Message.fromMap(e.data())).toList();
  }
}
