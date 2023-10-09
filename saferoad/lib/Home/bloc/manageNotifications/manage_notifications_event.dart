part of 'manage_notifications_bloc.dart';

class ManageNotificationsEvent extends Equatable {
  const ManageNotificationsEvent();

  @override
  List<Object> get props => [];
}

class UpdateOpenDialog extends ManageNotificationsEvent {
  final bool isRequestDialogOpen;
  const UpdateOpenDialog(this.isRequestDialogOpen);
}

class UpdateIsCurrentNotification extends ManageNotificationsEvent {
  final bool isCurrentNotification;
  const UpdateIsCurrentNotification(this.isCurrentNotification);
}

class UpdateCurrentNotification extends ManageNotificationsEvent {
  final Map<String, dynamic> currentNotification;
  const UpdateCurrentNotification(this.currentNotification);
}

class AddQueue extends ManageNotificationsEvent {
  final List<Map<String, dynamic>> notificationsQueue;
  const AddQueue(this.notificationsQueue);
}

class AddNotificationsListener extends ManageNotificationsEvent {
  final Stream<Map<String, dynamic>> notifications;
  const AddNotificationsListener(this.notifications);
}

class AddProviderRequests extends ManageNotificationsEvent {
  final List<Request> requests;
  const AddProviderRequests(this.requests);
}

class AddNotificationRequest extends ManageNotificationsEvent {
  final Request requestNotification;
  const AddNotificationRequest(this.requestNotification);
}
