import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:saferoad/Home/Provider/notificationsProvider.dart';
import 'package:saferoad/Home/Repository/notifications.dart';
import 'package:saferoad/Home/bloc/manageNotifications/manage_notifications_bloc.dart';
import 'package:saferoad/Map/ui/views/ratingDialog.dart';
import 'package:saferoad/Request/Repository/requestRepository.dart';
import 'package:saferoad/Request/model/Request.dart';
import 'package:saferoad/Request/ui/views/ensayo.dart';
import 'package:saferoad/helpers/notificationHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GeneralNotifications extends StatefulWidget {
  @override
  _GeneralNotificationsState createState() => _GeneralNotificationsState();
}

class _GeneralNotificationsState extends State<GeneralNotifications> {
  bool isRequestDialogOpen = false;
  List<Map<String, dynamic>> notificationsQueue = [];
  Map<String, dynamic>? currentNotification;

  @override
  void didChangeDependencies() {
    final requests = Provider.of<RequestProvider>(context).requests;
    final manageNotiBloc = BlocProvider.of<ManageNotificationsBloc>(context);
    manageNotiBloc.init(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final manageNotiBloc = BlocProvider.of<ManageNotificationsBloc>(context);
    return BlocBuilder<ManageNotificationsBloc, ManageNotificationsState>(
        builder: (context, state) {
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
            if (!state.isCurrentNotification) {
              manageNotiBloc.addCurrentNotification(notification);
            }

            if (notificationType == "request") {
              manageNotiBloc.addNotificationRequest(notification['request_id']);
              if (!state.isRequestDialogOpen) {
                //if (state.currentNotification.isNotEmpty) {
                if (state.requestNotification.id != null) {
                  //manageNotiBloc.add(const UpdateOpenDialog(true));
                  if (state.requestNotification.status == "pending") {
                    print("-----------------------------------------");
                    print("request que se esta pasando al pop up");
                    print(state.requestNotification.id);
                    print(state.requestNotification.status);
                    print("-----------------------------------------");
                    //manageNotiBloc.add(const UpdateOpenDialog(true));
                    return RequestPopup2(
                      address: notification['address'],
                      request: state.requestNotification,
                      onClose: () {
                        manageNotiBloc
                            .closeNotification(); // Cierra el diálogo cuando se presiona "Cerrar"
                      },
                    );
                  } else {
                    manageNotiBloc.add(const UpdateOpenDialog(false));
                  }
                }
                //} else {}
              }
              /*
              if (!state.isRequestDialogOpen) {
                final requestId = notification['request_id'];

                //if (request.id != "") {
                manageNotiBloc.addNotificationRequest(requestId);
                if (state.requestNotification.status == "pending") {
                  isRequestDialogOpen = true;
                  return RequestPopup2(
                    address: notification['address'],
                    request: state.requestNotification,
                    onClose: () {
                      isRequestDialogOpen = false;
                      if (notificationsQueue.isNotEmpty) {
                        final nextNotification = notificationsQueue.removeAt(0);
                        // Muestra la siguiente notificación en la cola
                        setState(() {
                          notificationsQueue.insert(0, nextNotification);
                        });
                      }
                    },
                  );
                } else {
                  isRequestDialogOpen = false;
                }
                //}
              } else {
                // Si ya hay un diálogo abierto, agrega la notificación a la cola
                print("SE AGREGA LA NOTIFICACIÓN");
                notificationsQueue.add(notification);
              }*/
            }
          }

          return const Center(); // Reemplaza con tu interfaz de usuario
        },
      );
    });
  }

  void _showRequestPopup(BuildContext context, manageNotiBloc,
      ManageNotificationsState state, Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RequestPopup2(
          address: notification['address'],
          request: state.requestNotification,
          onClose: () {
            manageNotiBloc.closeNotification();
            Navigator.of(context)
                .pop(); // Cierra el diálogo cuando se presiona "Cerrar"
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // Asegúrate de llamar a dispose para liberar recursos cuando el widget se desmonte.
    super.dispose();
  }
}
