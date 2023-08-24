import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String? id;
  final DateTimeObject createdAt;
  final String mecanicoId;
  final String requestDetails;
  final String status;
  final String userId;
  final GeoPoint userLocation;

  const Request({
    this.id,
    required this.createdAt,
    required this.mecanicoId,
    required this.requestDetails,
    required this.status,
    required this.userId,
    required this.userLocation,
  });

  factory Request.complete({
   DateTimeObject createdAt = const DateTimeObject(date:'',time: ''),
   String mecanicoId = '',
   String requestDetails = '', 
   String status = '',
   String userId = '',
   GeoPoint userLocation = const GeoPoint(0,0),
    // Otros campos aquí...
  }) {
    return Request(
      createdAt: createdAt,
      mecanicoId: mecanicoId,
      status: status,
      userId: userId,
      userLocation: userLocation,
      requestDetails:requestDetails
    );
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      id: map["id"]?.toString(),
      createdAt: DateTimeObject(
        date: map['createdAt']['date']?.toString() ?? '',
        time: map['createdAt']['time']?.toString() ?? '',
      ),
      mecanicoId: map['mecanicoId']?.toString() ?? '',
      requestDetails: map['requestDetails']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      userLocation: map['userLocation'] as GeoPoint,
    );
  }

  // Enviando los datos al servidor DB
  Map<String, dynamic> toMap() {
    return {
      "id":id,
      "createdAt": {
        "date": createdAt.date,
        "time": createdAt.time,
      },
      "mecanicoId": mecanicoId,
      "requestDetails": requestDetails,
      "status": status,
      "userId": userId,
      "userLocation": userLocation,
    };
  }
}

class DateTimeObject {
  final String date;
  final String time;

  const DateTimeObject({required this.date, required this.time});
}
