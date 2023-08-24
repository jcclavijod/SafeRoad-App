import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Auth/model/user_model.dart';
import '../../../Chat/ui/widgets/buttonChat.dart';
import '../../bloc/usersInRoad/users_in_road_bloc.dart';
import '../views/ratingDialog.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({
    Key? key,
    required this.receiver,
    required this.authenticatedUser,
    required this.userType,
  }) : super(key: key);

  final UserModel? authenticatedUser;
  final UserModel? receiver;
  final String? userType;
  @override
  BottomSheetContentState createState() => BottomSheetContentState();
}

class BottomSheetContentState extends State<BottomSheetContent> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final usersInRoadBloc = BlocProvider.of<UsersInRoadBloc>(context);
    return DraggableScrollableSheet(
      maxChildSize: 0.9,
      initialChildSize: 0.35,
      minChildSize: 0.35,
      builder: (context, scrollController) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(220, 230, 240, 0.9),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(isExpanded ? 0.0 : 40.0),
            ),
            boxShadow: [
              BoxShadow(
                color: isExpanded
                    ? Colors.transparent
                    : Colors.black.withOpacity(0.2),
                blurRadius: 6.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.3,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(top: 8.0),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildWidgetContainer(
                        const Icon(Icons.message),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Taller ${widget.authenticatedUser?.local ?? 'Local'}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16.0),
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(widget
                                            .authenticatedUser!.profilePic),
                                        radius:
                                            35, // Ajusta el tamaño de la imagen aquí
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 23.0),
                            Container(
                              height: 2,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            const SizedBox(height: 23.0),
                            const Text(
                              "Chat de contacto",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ChatBody(
                              receiver: widget.receiver,
                              authenticatedUser: widget.authenticatedUser,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildWidgetContainer(
                        const Icon(
                          Icons.phone,
                          color: Colors.green,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                SizedBox(width: 8.0),
                                Text(
                                  'Número de contacto',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            ElevatedButton(
                              onPressed: () {
                                final receiverPhoneNumber =
                                    widget.receiver!.phoneNumber;
                                usersInRoadBloc.openPhoneApp(
                                    receiverPhoneNumber); // Abre la aplicación de teléfono
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(
                                    0xFFF5F5F5), // Color de fondo alusivo a llamada
                                elevation:
                                    2.0, // Elevación para un aspecto ligeramente levantado
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Bordes redondeados
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 12.0), // Espacios internos
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    // Espacio entre el ícono y el texto
                                    Text(
                                      'Contactar',
                                      style: TextStyle(
                                        color: Colors.blue, // Color del texto
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildWidgetContainer(
                        const Icon(Icons.flag),
                        Column(
                          children: [
                            const Text(
                              'Finalizar recorrido',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      RatingDialog(userType: widget.userType),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green, // Color de fondo
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Borde redondeado
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10), // Espaciado interno
                                elevation: 2.0, // Elevación de sombra
                              ),
                              child: const Text(
                                'Finalizar Recorrido',
                                style: TextStyle(
                                  color: Colors.white, // Color del texto
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildWidgetContainer(
                        const Icon(Icons.close),
                        Column(
                          children: [
                            const Text(
                              'Cancelar servicio',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Dismissible(
                              key: const Key('cancel'),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(-4, 0),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: const Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 32.0,
                                    ),
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // Acción para cancelar el servicio
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors.red),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    child: const Text('Cancelar servicio'),
                                  ),
                                ],
                              ),
                              onDismissed: (direction) {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWidgetContainer(Widget leading, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 4.0,
            spreadRadius: 3.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
