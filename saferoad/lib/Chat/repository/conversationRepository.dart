import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saferoad/Chat/utils/conversationKey.dart';

import '../model/conversation.dart';

class ConversationRepository {
  final FirebaseFirestore firestore;

  ConversationRepository({
    required this.firestore,
  });

  Future<Map<String, dynamic>?> _getConversationId({
    required String senderUID,
    required String receiverUID,
  }) async {
    final members = [senderUID, receiverUID];

    final conversationQuerySnap =
        await firestore.collection(ConversationKey.collectionName).where(
      ConversationKey.members,
      whereIn: [
        members,
        members.reversed.toList(),
      ],
    ).get();

    if (conversationQuerySnap.docs.isNotEmpty) {
      return conversationQuerySnap.docs.first.data();
    }
    return null;
  }

  Future<Conversation?> getConversation({
    required String senderUID,
    required String receiverUID,
  }) async {
    final convesationMap = await _getConversationId(
      senderUID: senderUID,
      receiverUID: receiverUID,
    );
    if (convesationMap == null) {
      return null;
    } else {
      return Conversation.fromMap(convesationMap);
    }
  }

  Future<String> _createConversation({
    required Map<String, dynamic> conversation,
  }) async {
    final conversationRef = await firestore
        .collection(ConversationKey.collectionName)
        .add(conversation);

    await conversationRef.update({ConversationKey.id: conversationRef.id});
    return conversationRef.id;
  }

  Future<String> createConversation({
    required Conversation conversation,
  }) async {
    final conversationId = await _createConversation(
      conversation: conversation.toMap(),
    );
    return conversationId;
  }
}
