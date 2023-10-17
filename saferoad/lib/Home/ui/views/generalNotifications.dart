import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:saferoad/Home/Provider/notificationsProvider.dart';
import 'package:saferoad/Home/bloc/manageNotifications/manage_notifications_bloc.dart';
import 'package:saferoad/Map/ui/views/ratingDialog.dart';
import 'package:saferoad/Request/ui/views/ensayo.dart';
import 'package:flutter/material.dart';

class GeneralNotifications extends StatefulWidget {
  const GeneralNotifications({super.key});

  @override
  GeneralNotificationsState createState() => GeneralNotificationsState();
}

class GeneralNotificationsState extends State<GeneralNotifications> {
  final List<Map<String, dynamic>> notificationsQueue = [];
  @override
  void initState() {
    final manageNotiBloc = BlocProvider.of<ManageNotificationsBloc>(context);
    manageNotiBloc.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int cont = 0;
    print("EL PROBLEMA ES DE CONTRUCCION?????????????");

    //return const Center();
    return BlocBuilder<ManageNotificationsBloc, ManageNotificationsState>(
      builder: (context, state) {
        final manageNotiBloc =
            BlocProvider.of<ManageNotificationsBloc>(context);
        return StreamBuilder<Map<String, dynamic>>(
          stream: state.notifications,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final notification = snapshot.data;
              final notificationType = notification!['type'];

              if (notificationType == "finishedRequest") {
                showDialog(
                  context: context,
                  builder: (context) => RatingDialog(
                    requestId: notification["request_id"],
                    receiverUid: notification["mechanicUid"],
                    mechanicLocal: notification["mechanicLocal"],
                    mechanicPic: notification["mechanicPic"],
                  ),
                );
              }
              print("VAMOS A VER CUANTAS VECES LLGA LA GRAN PUTA NOTIFICACION");
              if (notificationType == "request") {
                if (notificationsQueue.isEmpty) {
                  notificationsQueue.add(notification);
                }

                //manageNotiBloc.addNotificationToQueue(notification);
                //print("REQUEST DE LA COLA::::::");
                print(notificationsQueue.length);
                print(notificationsQueue.first["request_id"]);

                manageNotiBloc
                    .subscribeToRequestStatusChanges(notificationsQueue.first);
                print("LAGARTIJA IGUANA LAGARTO");
                print(state.currentNotification["request_id"]);
                if (!state.isRequestDialogOpen) {
                  if (state.requestNotification.id != null) {
                    if (state.requestNotification.status == "pending") {
                      print(
                          "AQUI EN TEORIA SOLO SE DEBERIA MOSTRA UNA VEZ PRINCESA");
                      print(state.requestNotification.status);
                      //manageNotiBloc.add(const UpdateOpenDialog(true));
                      return RequestPopup2(
                        address: notification['address'],
                        request: state.requestNotification,
                        onClose: () {
                          //manageNotiBloc.closeNotificationAndProcessQueue();
                          notificationsQueue.removeAt(0);
                          manageNotiBloc.add(const UpdateOpenDialog(
                              true)); // Mostrar la siguiente notificación en la cola
                        },
                      );

                      /*print(state.requestNotification.status);
                      print(state.requestNotification.id);
                      print("-------------------------------------------");
                      manageNotiBloc.add(const UpdateOpenDialog(true));
                      return RequestPopup2(
                        address: notification['address'],
                        request: state.requestNotification,
                        onClose: () {
                          manageNotiBloc
                              .closeNotificationAndProcessQueue(); // Mostrar la siguiente notificación en la cola
                        },
                      );*/
                    } else {
                      print("QUE PASA PERRAAAAAAAAAAAAAAAAAAAAAAAAAA");
                      //manageNotiBloc.add(const UpdateOpenDialog(true));
                      notificationsQueue.removeAt(0);
                      cont = 0;
                    }
                  }
                } else {
                  print("AQUI NO DEBERIA PASAR NADA BEBE");
                  if (notificationsQueue.first["request_id"] !=
                      notification["request_id"]) {
                    notificationsQueue.add(notification);
                    manageNotiBloc.add(const UpdateOpenDialog(false));
                  }
                }
              }
            }

            return const Center();
          },
        );
      },
    );
  }

  void showRequestPopup(
      BuildContext context, manageNotiBloc, state, notification) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return RequestPopup2(
            address: notification['address'],
            request: state.requestNotification,
            onClose: () {
              manageNotiBloc
                  .closeNotificationAndProcessQueue(); // Mostrar la siguiente notificación en la cola
              Navigator.of(context)
                  .pop(); // Cierra el diálogo cuando se presiona "Cerrar"
            },
          );
        },
      );
    });
  }
}
