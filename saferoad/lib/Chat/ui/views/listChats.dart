import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Home/ui/widgets/SideMenuWidget.dart';

import '../../../Auth/model/user_model.dart';
import '../../bloc/chatBlc/chat_blc_bloc.dart';
import '../../model/conversation.dart';
import '../../provider/chatProvider.dart';
import '../../repository/chatRepository.dart';
import '../widgets/buttonChat.dart';
import '../widgets/icon_empty.dart';

class ChatPage extends StatelessWidget {
  final UserModel authenticatedUser;
  const ChatPage({
    Key? key,
    required this.authenticatedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    UserModel userM = UserModel();
    //print(authenticatedUser.uid);
    return Scaffold(
      appBar: (AppBar(
        title: Text("Chats"),
      )),
      drawer: SideMenuWidget(userM: userM),
      body: BlocProvider(
        create: (context) => ChatBloc(
          chatRepository: ChatRepository(
            chatFirebaseProvider:
                ChatFirebaseProvider(firestore: FirebaseFirestore.instance),
          ),
        )..add(ChatRequested(loginUID: authenticatedUser.uid)),
        child: _ChatView(
          authenticatedUser: authenticatedUser,
        ),
      ),
    );
  }
}

/*
  @override
  Widget build(BuildContext context) {
    //final chatBlc = BlocProvider.of<ChatBloc>(context);
    //chatBlc.add(ChatRequested(loginUID: authenticatedUser.uid));
    return BlocProvider(
      create: (context) =>
          ChatBloc()..add(ChatRequested(loginUID: authenticatedUser.uid)),
      child: _ChatView(
        authenticatedUser: authenticatedUser,
      ),
    );
  }
}
*/

class _ChatView extends StatelessWidget {
  final UserModel authenticatedUser;
  const _ChatView({
    Key? key,
    required this.authenticatedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoadInprogress) {
            return const CircularProgressIndicator();
          } else if (state is ChatLoadFailure) {
            return const Text('Unalbe to load chats');
          } else if (state is ChatLoadSuccess) {
            return _ChatList(
              authenticatedUser: authenticatedUser,
              chats: state.chats,
            );
          }
          return const Text(
            'Estado indefinido',
          );
        },
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  final List<Conversation> chats;
  const _ChatList({
    Key? key,
    required this.chats,
    required this.authenticatedUser,
  }) : super(key: key);

  final UserModel authenticatedUser;

  @override
  Widget build(BuildContext context) {
    return chats.isEmpty
        ? iconEmpty(context)
        : ListView.builder(
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              final chat = chats.elementAt(index);
              final receiver = chat.creator.uid != authenticatedUser.uid
                  ? chat.creator
                  : chat.receiver;
              return ChatBody(
                receiver: receiver,
                authenticatedUser: authenticatedUser,
              );
            },
          );
  }
}
