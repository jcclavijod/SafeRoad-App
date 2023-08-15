import 'package:flutter/material.dart';

import '../../../Auth/model/user_model.dart';

import '../views/chatPage.dart';

class ChatBody extends StatelessWidget {
  final UserModel? receiver;
  final UserModel? authenticatedUser;

  const ChatBody({
    Key? key,
    required this.receiver,
    required this.authenticatedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(receiver!.profilePic),
      ),
      title: Text(receiver!.name),
      subtitle: Text(receiver!.email),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios_rounded),
        onPressed: () {
          Navigator.push<MaterialPageRoute>(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationPage(
                receiver: receiver,
                sender: authenticatedUser,
              ),
            ),
          );
        },
      ),
    );
  }
}
