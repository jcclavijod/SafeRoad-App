import '../model/conversation.dart';
import '../provider/chatProvider.dart';

class ChatRepository {
  final ChatFirebaseProvider chatFirebaseProvider;
  ChatRepository({
    required this.chatFirebaseProvider,
  });

  Future<List<Conversation>> getChats({required String loginUID}) async {
    final chatMaps = await chatFirebaseProvider.getChats(loginUID: loginUID);
    return chatMaps.map((chatMap) => Conversation.fromMap(chatMap)).toList();
  }
}
