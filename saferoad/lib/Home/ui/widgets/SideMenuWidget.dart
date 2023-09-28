import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:saferoad/Auth/model/usuario_model.dart';
import 'package:saferoad/Auth/ui/Cliente/widgets.dart';
import 'package:saferoad/Chat/ui/views/listChats.dart';
import 'package:saferoad/Home/ui/views/perfil.dart';
import 'package:saferoad/Membresia/ui/views/membershipPage.dart';

import '../../../Auth/provider/auth_provider.dart';
import '../../../Request/ui/views/ListRequests.dart';
import '../views/userpage.dart';

class SideMenuWidget extends StatelessWidget {
  const SideMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel? userM = UserModel.complete();
    return FutureBuilder<UserModel>(
      future: FirebaseDataSource().getMyUsers(),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        Widget wid;
        if (snapshot.connectionState == ConnectionState.waiting) {
          // si la función todavía no ha devuelto los datos, puedes mostrar un indicador de progreso
          wid = const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // si la función ha devuelto los datos, puedes asignarlos a la variable usuario
          userM = snapshot.data;

          wid = Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(userM!.name),
                  accountEmail: Text(userM!.mail),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(userM!.profilePic),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.map_outlined),
                  title: const Text('Mapa'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const UserPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Lista de Viajes'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ListRequests()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat_bubble_outline_outlined),
                  title: const Text('Mensajes'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatPage(authenticatedUser: userM),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('Membresia'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MembershipPage()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Configuracion'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Perfil(authenticatedUser: userM)),
                    );
                  },
                ),
                //LogoutButton(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Salir'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          // si la función ha devuelto un error, puedes mostrar un mensaje de error
          wid = const Center(child: Text('Error al cargar el usuario'));
        } else {
          // si la función no ha devuelto datos ni errores, se devuelve un Widget por defecto
          wid = const Center(child: Text('Esperando datos...'));
        }
        return wid;
      },
    );
  }
}
