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

  void init() {
    RequestListen request = RequestListen();
    final requests = request.requests;
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

  void addCurrentNotification(Map<String, dynamic> notification) {
    add(UpdateCurrentNotification(notification));
    add(const UpdateIsCurrentNotification(true));
  }

  // Define una variable para mantener un registro de las solicitudes notificadas.
  Set<String> notifiedRequests = Set();
  Set<String> notifiedRequests2 = Set();

  void subscribeToRequestStatusChanges(Map<String, dynamic> notification) {
    String requestId = notification["request_id"];
    //add(UpdateCurrentNotification(notification));
    FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final request =
            Request.fromMap(snapshot.data() as Map<String, dynamic>);
        if (request.status == "pending" &&
            !notifiedRequests.contains(requestId)) {
          // Notificar solo si la solicitud está en "pending" y no se ha notificado antes.
          notifiedRequests.add(requestId); // Registra la notificación.
          add(AddNotificationRequest(request));
        } else if (request.status == "rejected" &&
            !notifiedRequests2.contains(requestId)) {
          notifiedRequests2.add(requestId);
          add(AddNotificationRequest(request));
        }
      }
    });
  }

  void addNotificationRequest(String requestId) {
    final request = state.requests.firstWhere(
      (request) => request.id == requestId,
      orElse: () => Request.complete(),
    );
    print("MOSTRAR LA REQUEST QUE SE VA A AÑADIR A LA COLA");
    print(request.id);
    add(AddNotificationRequest(request));
  }

  void addNotificationToQueue(Map<String, dynamic> notification) {
    print("MALDITA PERRA HIJA DE LA GRAN PUTA");
    final updatedQueue =
        List<Map<String, dynamic>>.from(state.notificationsQueue)
          ..add(notification);
    //add(AddNotificationRequest(Request.complete()));
    //print("hola bebe, se que contigo no sirve la magia");
    //final newState = state.copyWith(notificationsQueue: updatedQueue);
    //emit(newState);
    //add(AddQueue(updatedQueue));
    /*
    
    
   
    */
  }

  void closeNotificationAndProcessQueue() {
    add(const UpdateOpenDialog(false)); // Cierra la notificación actual

    if (state.notificationsQueue.isNotEmpty) {
      final nextNotification = state.notificationsQueue.removeAt(0);
      addNotificationRequest(nextNotification[
          'request_id']); // Muestra la siguiente notificación en la cola
    }
    add(const UpdateCurrentNotification({})); // Limpia la notificación actual
  }
}
