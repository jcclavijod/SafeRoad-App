import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String? id;
  final DateTimeObject createdAt;
  final String mechanicId;
  final String requestDetails;
  final String status;
  final String userId;
  final String userAddress;
  final GeoPoint userLocation;
  final GeoPoint mechanicLocation;
  final String service;
  final String selectedCauseId;

  const Request({
    this.id,
    required this.createdAt,
    required this.mechanicId,
    required this.requestDetails,
    required this.status,
    required this.userId,
    required this.userAddress,
    required this.userLocation,
    required this.mechanicLocation,
    required this.service,
    required this.selectedCauseId,
  });

  factory Request.complete({
    DateTimeObject createdAt = const DateTimeObject(date: '', time: ''),
    String mechanicId = '',
    String requestDetails = '',
    String status = '',
    String userId = '',
    String userAddress = '',
    GeoPoint userLocation = const GeoPoint(0, 0),
    GeoPoint mechanicLocation = const GeoPoint(0, 0),
    String service = "",
    String selectedCauseId = "",
    String id = ""
    // Otros campos aquí...
  }) {
    return Request(
        createdAt: createdAt,
        mechanicId: mechanicId,
        status: status,
        userId: userId,
        userLocation: userLocation,
        userAddress: userAddress,
        requestDetails: requestDetails,
        mechanicLocation: mechanicLocation,
        service: service,
        selectedCauseId: selectedCauseId,
        id: id);
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map["id"]?.toString(),
      createdAt: DateTimeObject(
        date: map['createdAt']['date']?.toString() ?? '',
        time: map['createdAt']['time']?.toString() ?? '',
      ),
      mechanicId: map['mechanicId']?.toString() ?? '',
      requestDetails: map['requestDetails']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      userAddress: map['userAddress']?.toString() ?? '',
      userLocation: map['userLocation'] as GeoPoint,
      mechanicLocation: map['mechanicLocation'] != null
          ? map['mechanicLocation'] as GeoPoint
          : const GeoPoint(0, 0),
      service: map['service']?.toString() ?? '',
      selectedCauseId: map['selectedCauseId']?.toString() ?? '',
    );
  }

  // Enviando los datos al servidor DB
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "createdAt": {
        "date": createdAt.date,
        "time": createdAt.time,
      },
      "mechanicId": mechanicId,
      "requestDetails": requestDetails,
      "status": status,
      "userId": userId,
      "userAddress": userAddress,
      "userLocation": userLocation,
    };
  }
}

class DateTimeObject {
  final String date;
  final String time;

  const DateTimeObject({required this.date, required this.time});
}
