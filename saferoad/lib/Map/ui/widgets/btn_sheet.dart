import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saferoad/Auth/model/usuario_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Chat/ui/widgets/buttonChat.dart';
import '../../../Home/ui/views/userpage.dart';
import '../../../Request/model/Request.dart';
import '../../../ServiceRegister/ui/views/myBilling.dart';
import '../../bloc/usersInRoad/users_in_road_bloc.dart';
import '../views/ratingDialog.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({
    Key? key,
    required this.receiver,
    required this.authenticatedUser,
    required this.userType,
    required this.request,
  }) : super(key: key);

  final UserModel? authenticatedUser;
  final UserModel? receiver;
  final String? userType;
  final Request? request;

  @override
  BottomSheetContentState createState() => BottomSheetContentState();
}

class BottomSheetContentState extends State<BottomSheetContent> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final usersInRoadBloc = BlocProvider.of<UsersInRoadBloc>(context);

    if (widget.receiver?.profilePic == null) {
      return const CircularProgressIndicator.adaptive(
        backgroundColor: Colors.blue,
      );
    } else {
      if (usersInRoadBloc.state.userType == "mecanico") {
        return buildCommonAnimatedContainer(isExpanded, true);
      } else {
        return buildCommonAnimatedContainer(isExpanded, false);
      }
    }
  }

  DraggableScrollableSheet buildCommonAnimatedContainer(
      bool isExpanded, bool showWidget) {
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
                      child: UserProfileSection(
                        receiver: widget.receiver!,
                        authenticatedUser: widget.authenticatedUser!,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ContactButtonSection(
                        receiverPhoneNumber: widget.receiver!.phoneNumber,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    if (showWidget)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: FinishButtonSection(
                            requestId: widget.request!.id,
                            receiver: widget.authenticatedUser,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CancelButtonSection(
                        request: widget.request,
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
}

class UserProfileSection extends StatelessWidget {
  const UserProfileSection({
    Key? key,
    required this.authenticatedUser,
    required this.receiver,
  }) : super(key: key);

  final UserModel authenticatedUser;
  final UserModel receiver;

  @override
  Widget build(BuildContext context) {
    return _buildWidgetContainer(
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
                        "Taller ${authenticatedUser.name}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(authenticatedUser.profilePic),
                      radius: 35,
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
            receiver: receiver,
            authenticatedUser: authenticatedUser,
          ),
        ],
      ),
    );
  }
}

class ContactButtonSection extends StatelessWidget {
  const ContactButtonSection({
    Key? key,
    required this.receiverPhoneNumber,
  }) : super(key: key);

  final String receiverPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return _buildWidgetContainer(
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
              final usersInRoadBloc = BlocProvider.of<UsersInRoadBloc>(context);
              usersInRoadBloc.openPhoneApp(receiverPhoneNumber);
            },
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFFF5F5F5),
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Contactar',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FinishButtonSection extends StatelessWidget {
  const FinishButtonSection({
    Key? key,
    required this.requestId,
    required this.receiver,
  }) : super(key: key);

  final String? requestId;

  final UserModel? receiver;

  @override
  Widget build(BuildContext context) {
    return _buildWidgetContainer(
      const Icon(Icons.flag),
      Column(
        children: [
          const Text(
            'Realizar cuenta de pago',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              /*
              final usersInRoadBloc = BlocProvider.of<UsersInRoadBloc>(context);
              usersInRoadBloc.finishRequest(
                  requestId, receiver!.name, receiver!.profilePic);

              Navigator.of(context).pushNamedAndRemoveUntil(
                '/',
                (route) => false,
              );*/

              final usersInRoadBloc = BlocProvider.of<UsersInRoadBloc>(context);
              usersInRoadBloc.change(requestId);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyBilling(
                          requestId: requestId!,
                        )),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 2.0,
            ),
            child: const Text(
              'Calcular cuenta de cobro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CancelButtonSection extends StatelessWidget {
  const CancelButtonSection({Key? key, required this.request})
      : super(key: key);
  final Request? request;

  @override
  Widget build(BuildContext context) {
    return _buildWidgetContainer(
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
          ElevatedButton(
            onPressed: () {
              showCancelConfirmationDialog(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // Color de fondo rojo
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // Bordes redondeados
              ),
            ),
            child: const Text(
              'Cancelar servicio',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar cancelación'),
          content:
              const Text('¿Está seguro de que desea cancelar el servicio?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              style: TextButton.styleFrom(
                primary: Colors.grey, // Cambia el color del texto a gris
                backgroundColor: Colors.white, // Fondo blanco
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0), // Ajusta el padding
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(32.0), // Bordes redondeados
                  side:
                      BorderSide(color: Colors.grey, width: 1.0), // Borde gris
                ),
              ),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Realiza la acción de cancelación aquí
                final usersInRoadBloc =
                    BlocProvider.of<UsersInRoadBloc>(context);
                usersInRoadBloc.cancelRequest(request!.id);
                Navigator.of(context).pushReplacementNamed('/');
              },
              style: TextButton.styleFrom(
                primary: Colors.white, // Cambia el color del texto a blanco
                backgroundColor: Colors.red, // Fondo rojo
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0), // Ajusta el padding
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(32.0), // Bordes redondeados
                ),
              ),
              child: const Text('Confirmar'),
            ),
          ],
          elevation: 4, // Sombra
          backgroundColor: Colors.white, // Color de fondo
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                16.0), // Bordes redondeados del AlertDialog
          ),
        );
      },
    );
  }
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        leading,
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
