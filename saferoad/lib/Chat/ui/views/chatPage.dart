import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Auth/model/user_model.dart';

import '../../bloc/conversationBlc/conversationBloc.dart';
import '../../provider/conversationProvider.dart';
import '../../repository/conversationRepository.dart';
import 'chat.dart';

class ConversationPage extends StatelessWidget {
  final String? converasationId;
  final UserModel sender;
  final UserModel receiver;

  const ConversationPage({
    Key? key,
    this.converasationId,
    required this.sender,
    required this.receiver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversationBloc(
        conversationRepository: ConversationRepository(
          conversationFirebaseProvider: ConversationFirebaseProvider(
            firestore: FirebaseFirestore.instance,
          ),
        ),
      )..add(
          ConversationDetailRequested(
            loginUser: sender,
            receiver: receiver,
          ),
        ),
      child: ConversationView(
        loginUser: sender,
        receiver: receiver,
      ),
    );
  }
}

class ConversationView extends StatelessWidget {
  final UserModel loginUser;
  final UserModel receiver;

  const ConversationView({
    Key? key,
    required this.loginUser,
    required this.receiver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String estado = "Estado indefinido";
    String estadoConversacion =
        "Estamos cargando tu conversación, por favor intenta de nuevo";
    return Scaffold(
      appBar: AppBar(
        title: Text(receiver.name),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(receiver.profilePic),
          )
        ],
      ),
      body: Center(
        child: BlocBuilder<ConversationBloc, ConversationState>(
          builder: (context, state) {
            if (state is ConversationLoadSuccess) {
              return ConversationMainView(
                loginUser: loginUser,
                receiver: receiver,
                conversationId: state.conversation.id ?? '',
              );
            } else if (state is ConversationCreationSuccess) {
              return ConversationMainView(
                loginUser: loginUser,
                receiver: receiver,
                conversationId: state.conversationId,
              );
            } else if (state is ConversationLoadInprogress ||
                state is ConversationCreationInprogress) {
              return const CircularProgressIndicator();
            } else if (state is ConversationLoadFailure ||
                state is ConversationCreationFailure) {
              return Text(estadoConversacion);
            }
            return Text(estado);
          },
        ),
      ),
    );
  }
}
