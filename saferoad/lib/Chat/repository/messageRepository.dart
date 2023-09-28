import '../model/message.dart';
import '../provider/messageProvider.dart';

class MessageRepository {
  final MessageProvider messageFirebaseProvider;

  MessageRepository({
    required this.messageFirebaseProvider,
  });

  Future<void> sendMessage({required Message message}) async {
    await messageFirebaseProvider.addMessage(messageMap: message.toMap());
  }

  Stream<List<Message?>> getMessages({required String conversationId}) {
    final messageMapStream =
        messageFirebaseProvider.getMessages(conversationId: conversationId);

    return messageMapStream.map(
      (event) => event.map(
        (e) {
          return e != null ? Message.fromMap(e) : null;
        },
      ).toList(),
    );
  }
}