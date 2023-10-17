import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saferoad/Chat/model/conversation.dart';
import 'package:saferoad/Chat/repository/chatRepository.dart';
import 'package:saferoad/Chat/utils/conversationKey.dart';
// Reemplaza con la ubicación correcta de tu paquete

void main() {
  group('ChatRepository Tests', () {
    late ChatRepository chatRepository;
    late FakeFirebaseFirestore fakeFirestore;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      chatRepository = ChatRepository(firestore: fakeFirestore);
    });

    test('getChats should return a list of Conversation', () async {
      const loginUID = 'loginUserId';
      final userModel = {
        "name": "name",
        "lastname": "lastname",
        "mail": "mail",
        "password": "password",
        "identification": "identification",
        "gender": "gender",
        "phoneNumber": "phoneNumber",
        "birthday": "birthday",
        "uid": "uid",
        "profilePic": "profilePic",
        "isAviable": true,
        "token": "token",
      };
      final chatMaps = [
        {
          'id': 'chatId1',
          'members': [loginUID, 'otherUserId1'],
          'creator': userModel,
          'receiver': userModel,
        },
        {
          'id': 'chatId2',
          'members': [loginUID, 'otherUserId2'],
          'creator': userModel,
          'receiver': userModel,
        },
      ];

      for (var chatMap in chatMaps) {
        await fakeFirestore
            .collection(ConversationKey.collectionName)
            .doc(chatMap["id"] as String)
            .set(chatMap);
      }
      final result = await chatRepository.getChats(loginUID: loginUID);

      expect(result, isA<List<Conversation>>());
      expect(result.length, chatMaps.length);

      for (var i = 0; i < result.length; i++) {
        expect(result[i], isA<Conversation>());
        expect(result[i].id, chatMaps[i]['id']);
        expect(result[i].members, chatMaps[i]['members']);
      }
    });

    test('getChats should return an empty list when no conversations are found',
        () async {
      const loginUID = 'loginUserId';
      final result = await chatRepository.getChats(loginUID: loginUID);
      expect(result, isA<List<Conversation>>());
      expect(result.isEmpty, isTrue);
    });
  });
}
