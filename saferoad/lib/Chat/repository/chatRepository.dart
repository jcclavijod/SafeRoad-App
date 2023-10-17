import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saferoad/Chat/utils/conversationKey.dart';

import '../model/conversation.dart';

class ChatRepository {
  final FirebaseFirestore firestore;

  ChatRepository({
    required this.firestore,
  });

  Future<List<Map<String, dynamic>>> _getChats({
    required String loginUID,
  }) async {
    final querySnap = await firestore
        .collection(ConversationKey.collectionName)
        .where(ConversationKey.members, arrayContains: loginUID)
        .get();
    return querySnap.docs.map((e) => e.data()).toList();
  }

  Future<List<Conversation>> getChats({required String loginUID}) async {
    final chatMaps = await _getChats(loginUID: loginUID);
    return chatMaps.map((chatMap) => Conversation.fromMap(chatMap)).toList();
  }
}
