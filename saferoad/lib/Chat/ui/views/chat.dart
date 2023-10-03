import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Auth/model/usuario_model.dart';

import '../../bloc/messageReceiverBlc/msReceiverBloc.dart';
import '../../bloc/messageSenderBlc/msSenderBloc.dart';
import '../../provider/messageProvider.dart';
import '../../repository/messageRepository.dart';
import 'chatMessage.dart';
import 'chatSender.dart';


class ConversationMainView extends StatelessWidget {
  final UserModel? loginUser;
  final UserModel? receiver;
  final String conversationId;

  const ConversationMainView({
    Key? key,
    required this.loginUser,
    required this.receiver,
    required this.conversationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const heightOfContainer = 50;
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              heightOfContainer -
              20,
          child: BlocProvider(
            create: (context) => MessageReceiverBloc(
              messageRepository: MessageRepository(
                messageFirebaseProvider: MessageProvider(
                  firestore: FirebaseFirestore.instance,
                ),
              ),
            )..add(MessageRequested(conversationId: conversationId)),
            child: ConversationMessageView(
              receiver: receiver,
              loginUser: loginUser,
            ),
          ),
        ),
        Container(
          height: heightOfContainer.toDouble(),
          padding: const EdgeInsets.all(5),
          child: Center(
            child: BlocProvider(
              create: (context) => MessageSenderBloc(
                MessageRepository(
                  messageFirebaseProvider: MessageProvider(
                    firestore: FirebaseFirestore.instance,
                  ),
                ),
              ),
              child: ConversationSenderView(
                conversationId: conversationId,
                senderUID: loginUser!.uid,
                receiverUID: receiver!.uid,
              ),
            ),
          ),
        )
      ],
    );
  }
}