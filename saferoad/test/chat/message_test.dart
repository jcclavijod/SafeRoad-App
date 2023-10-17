import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saferoad/Chat/model/message.dart';
import 'package:saferoad/Chat/repository/messageRepository.dart';

void main() {
  group('MessageRepository Tests', () {
    late MessageRepository messageRepository;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      messageRepository = MessageRepository(firestore: fakeFirestore);
    });

    test('getMessages should return a stream of messages', () async {
      const conversationId = 'chatId1';
      final fakeMessages = [
        {'text': 'Hello', 'timestamp': DateTime.now()},
        {'text': 'Hi', 'timestamp': DateTime.now()},
      ];
      for (var fakeMessage in fakeMessages) {
        fakeFirestore
            .collection('messages')
            .doc()
            .set({'conversationId': conversationId, ...fakeMessage});
      }
      final messagesStream = messageRepository.getMessages(conversationId: conversationId);
      expect(messagesStream, isA<Stream<List<Message?>>>());

      await expectLater(messagesStream, emits(isA<List<Message?>>()));
    });

    test('getMessages should handle null values', () async {
      const conversationId = 'chatId2';
      fakeFirestore.collection('messages').doc('messageId').set({'conversationId': conversationId, 'text': null, 'timestamp': null});
      final messagesStream = messageRepository.getMessages(conversationId: conversationId);
      expect(messagesStream, isA<Stream<List<Message?>>>());
      await expectLater(messagesStream, emits(isA<List<Message?>>()));
    });
  });
}
