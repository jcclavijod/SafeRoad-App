part of 'manage_notifications_bloc.dart';

class ManageNotificationsState extends Equatable {
  final bool isRequestDialogOpen;
  final bool isCurrentNotification;
  final List<Map<String, dynamic>> notificationsQueue;
  final Map<String, dynamic> currentNotification;
  final Stream<Map<String, dynamic>> notifications;
  final List<Request> requests;
  final Request requestNotification;

  const ManageNotificationsState(
      {this.isRequestDialogOpen = false,
      this.isCurrentNotification = false,
      this.notificationsQueue = const [],
      this.currentNotification = const <String, dynamic>{},
      this.notifications = const Stream<Map<String, dynamic>>.empty(),
      this.requests = const [],
      this.requestNotification = const Request(
          createdAt: DateTimeObject(date: '', time: ''),
          mechanicId: "",
          requestDetails: "",
          status: "",
          userId: "",
          userAddress: "",
          userLocation: GeoPoint(0, 0),
          mechanicLocation: GeoPoint(0, 0),
          service: "",
          selectedCauseId: "")});

  ManageNotificationsState copyWith(
          {bool? isRequestDialogOpen,
          bool? isCurrentNotification,
          List<Map<String, dynamic>>? notificationsQueue,
          Map<String, dynamic>? currentNotification,
          Stream<Map<String, dynamic>>? notifications,
          List<Request>? requests,
          Request? requestNotification}) =>
      ManageNotificationsState(
          isRequestDialogOpen: isRequestDialogOpen ?? this.isRequestDialogOpen,
          isCurrentNotification:
              isCurrentNotification ?? this.isCurrentNotification,
          notificationsQueue: notificationsQueue ?? this.notificationsQueue,
          currentNotification: currentNotification ?? this.currentNotification,
          notifications: notifications ?? this.notifications,
          requests: requests ?? this.requests,
          requestNotification: requestNotification ?? this.requestNotification);

  @override
  List<Object> get props => [
        isRequestDialogOpen,
        isCurrentNotification,
        notificationsQueue,
        currentNotification,
        notifications,
        requests,
        requestNotification
      ];
}
