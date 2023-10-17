import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saferoad/Chat/utils/messageKeys.dart';
import '../model/message.dart';


class MessageRepository {
  final FirebaseFirestore firestore;

  MessageRepository({
    required this.firestore,
  });

  Future<void> _addMessage({required Map<String, dynamic> messageMap}) async {
    await firestore.collection(MessageKeys.collection).add(messageMap);
  }

  Future<void> sendMessage({required Message message}) async {
    await _addMessage(messageMap: message.toMap());
  }

  Stream<List<Map<String, dynamic>?>> _getMessages({
    required String conversationId,
  }) {
    final querySnapShotStream = firestore
        .collection(MessageKeys.collection)
        .where(MessageKeys.conversationId, isEqualTo: conversationId)
        .orderBy(MessageKeys.timeStamp, descending: true)
        .snapshots();

    return querySnapShotStream.map(
      (event) => event.docs.map((e) => e.data()).toList(),
    );
  }

  Stream<List<Message?>> getMessages({required String conversationId}) {
    final messageMapStream =
        _getMessages(conversationId: conversationId);

    return messageMapStream.map(
      (event) => event.map(
        (e) {
          return e != null ? Message.fromMap(e) : null;
        },
      ).toList(),
    );
  }
}