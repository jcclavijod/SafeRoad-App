import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:saferoad/Auth/model/usuario_model.dart';
import 'package:saferoad/Chat/model/conversation.dart';
import 'package:saferoad/Chat/repository/conversationRepository.dart';
import 'package:saferoad/Chat/utils/conversationKey.dart';


class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late ConversationRepository conversationRepository;
  late FakeFirebaseFirestore fakeFirestore;
  //late MockFirebaseFirestore mockFirestore;
  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    //mockFirestore = MockFirebaseFirestore();
    conversationRepository = ConversationRepository(firestore: fakeFirestore);
  });

  test('getConversation should return a Conversation when it exists', () async {
    const String senderUID = 'senderUserId';
    const String receiverUID = 'receiverUserId';
    const conversationId = 'conversationId';
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

    final conversationData = {
      'id': conversationId,
      'members': [senderUID, receiverUID],
      'creator': userModel,
      'receiver': userModel,
    };

    await fakeFirestore
        .collection(ConversationKey.collectionName)
        .doc(conversationId)
        .set(conversationData);

    final conversationQuerySnap =
        await fakeFirestore.collection(ConversationKey.collectionName).where(
      ConversationKey.collectionName,
      whereIn: [
        [senderUID, receiverUID],
        [senderUID, receiverUID].reversed.toList(),
      ],
    ).get();

    print(conversationQuerySnap.docs.isEmpty);
    print("___________________________");

    final result = await conversationRepository.getConversation(
      senderUID: senderUID,
      receiverUID: receiverUID,
    );

    expect(result, isA<Conversation>());
    expect(result?.id, conversationId);
    expect(result?.members, [senderUID, receiverUID]);
  });

  test('getConversation should return null when it does not exist', () async {
    const senderUID = 'senderUserId';
    const receiverUID = 'receiverUserId';

    // No se establece una conversación en Firestore

    final result = await conversationRepository.getConversation(
      senderUID: senderUID,
      receiverUID: receiverUID,
    );

    expect(result, isNull);
  });

  test('createConversation should return a conversation id', () async {
    final conversation = Conversation(
      id: 'chatId1',
      members: const ['senderUID', 'receiverUID'],
      creator: UserModel.complete(),
      receiver: UserModel.complete(),
    );

    final conversationId = await conversationRepository.createConversation(
      conversation: conversation,
    );

    expect(conversationId, isNotNull);
    expect(conversationId, isNotEmpty);
  });
}
