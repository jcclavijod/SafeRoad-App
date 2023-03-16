import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saferoad/Auth/model/user_model.dart';
import 'package:saferoad/Chat/ui/views/listChats.dart';
import 'package:saferoad/Home/ui/views/perfil.dart';
import 'package:saferoad/Map/ui/views/loading.dart';

class SideMenuWidget extends StatelessWidget {
  const SideMenuWidget({
    Key? key,
    required this.userM,
  }) : super(key: key);

  final UserModel userM;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userM.name),
            accountEmail: Text(userM.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(userM.profilePic),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Map'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Loading()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat_bubble),
            title: const Text('Chat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(authenticatedUser: userM),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Perfil()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
