// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
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

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  String tipo = "";
  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Future<void> initializeData() async {
    tipo = await FirebaseDataSource().getUserType();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userM = UserModel.complete();
    return FutureBuilder<UserModel>(
      future: FirebaseDataSource().getMyUsers(),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        Widget wid;

        if (snapshot.connectionState == ConnectionState.waiting && tipo == "") {
          wid = const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          print("TIPO HIJO DE LA GRAN PUTA");
          print(tipo);
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
                      MaterialPageRoute(builder: (context) => ListRequests(type:tipo)),
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
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (!snapshot.data!.exists) {
                        return ListTile(
                          leading: const Icon(Icons.credit_card),
                          title: const Text('Membresia'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MembershipPage(),
                              ),
                            );
                          },
                        );
                      }
                    }
                    return Container(); // Retorna un contenedor vacío si el usuario es un mecánico
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
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Salir'),
                  onTap: () async {
                    CollectionReference users =
                        FirebaseFirestore.instance.collection('users');
                    CollectionReference mechanics =
                        FirebaseFirestore.instance.collection('mecanicos');
                    DocumentReference currentUser =
                        users.doc(FirebaseAuth.instance.currentUser!.uid);
                    DocumentSnapshot userSnapshot = await currentUser.get();
                    if (userSnapshot.exists) {
                      currentUser.update({'isAviable': false});
                    } else {
                      DocumentReference currentMechanic =
                          mechanics.doc(FirebaseAuth.instance.currentUser!.uid);
                      currentMechanic.update({'isAviable': false});
                      print(currentMechanic.update({'isAviable': false}));
                    }
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                      (route) => false,
                    );
                  },
                )
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
