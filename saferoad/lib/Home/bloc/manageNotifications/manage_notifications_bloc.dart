import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:saferoad/Home/Provider/notificationsProvider.dart';
import 'package:saferoad/Home/Repository/notifications.dart';
import 'package:saferoad/Request/model/Request.dart';

part 'manage_notifications_event.dart';
part 'manage_notifications_state.dart';

class ManageNotificationsBloc
    extends Bloc<ManageNotificationsEvent, ManageNotificationsState> {
  ManageNotificationsBloc() : super(const ManageNotificationsState()) {
    on<AddNotificationsListener>((event, emit) =>
        emit(state.copyWith(notifications: event.notifications)));

    on<AddProviderRequests>(
        (event, emit) => emit(state.copyWith(requests: event.requests)));

    on<AddQueue>((event, emit) =>
        emit(state.copyWith(notificationsQueue: event.notificationsQueue)));

    on<UpdateCurrentNotification>((event, emit) =>
        emit(state.copyWith(currentNotification: event.currentNotification)));

    on<UpdateOpenDialog>((event, emit) =>
        emit(state.copyWith(isRequestDialogOpen: event.isRequestDialogOpen)));

    on<UpdateIsCurrentNotification>((event, emit) => emit(
        state.copyWith(isCurrentNotification: event.isCurrentNotification)));

    on<AddNotificationRequest>((event, emit) =>
        emit(state.copyWith(requestNotification: event.requestNotification)));
  }

  void init(BuildContext context) {
    final requests = Provider.of<RequestProvider>(context).requests;
    add(AddNotificationsListener(
        Notifications.notificationManager.notificationStream));
    add(AddProviderRequests(requests));
  }

/*
  void handleNotification(Map<String, dynamic> notification) {
      if (!state.isRequestDialogOpen) {
        final requestId = notification['request_id'];
        // Puedes acceder a los datos de la solicitud aquí y realizar las acciones necesarias.
        // Por ejemplo, verificar si la solicitud está pendiente.
        final requestStatus = getRequestStatus(
            requestId); // Implementa esta función según tu lógica.

        if (requestStatus == "pending") {
          isRequestDialogOpen = true;
          currentNotification = notification;
          _notificationStreamController.sink.add(notification);
        }
      } else {
        notificationsQueue.add(notification);
      }
    
  }
  */

  void closeNotification() {
    add(const UpdateOpenDialog(false));
    

    if (state.notificationsQueue.isNotEmpty) {
      final nextNotification = state.notificationsQueue.removeAt(0);
      //handleNotification(nextNotification);
    }
    add(const UpdateCurrentNotification({}));
  }

  void addCurrentNotification(Map<String, dynamic> notification) {
    add(UpdateCurrentNotification(notification));
    add(const UpdateIsCurrentNotification(true));
  }

  void addNotificationRequest(String requestId) {
    final request = state.requests.firstWhere(
      (request) => request.id == requestId,
      orElse: () => Request.complete(),
    );
    add(AddNotificationRequest(request));
  }
/*
  void addNotificationQueue(Map<String, dynamic> notification) {
    state.notificationsQueue.sink.add(notification);
  }
*/
}
