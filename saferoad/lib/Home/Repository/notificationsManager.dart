  import 'dart:async';

class NotificationManager {
  final StreamController<Map<String, dynamic>> _notificationStreamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationStreamController.stream;

  void sendNotification(Map<String, dynamic> notificationData) {
    _notificationStreamController.sink.add(notificationData);
  }

  void dispose() {
    _notificationStreamController.close();
  }
}
