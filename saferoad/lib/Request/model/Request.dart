import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final Timestamp createdAt;
  final String mecanicoId;
  final String requestDetails;
  final String status;
  final String userId;
  //final String cost;
  final GeoPoint userLocation;

  Request({
    required this.createdAt,
    required this.mecanicoId,
    required this.requestDetails,
    required this.status,
    required this.userId,
    required this.userLocation,
    //required this.cost,
  });

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      createdAt:
          Timestamp.fromMillisecondsSinceEpoch(int.parse(map['createdAt'])),
      mecanicoId: map['mecanicoId']?.toString() ?? '',
      requestDetails: map['requestDetails']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      userLocation: map['userLocation'] as GeoPoint,
      //cost: map['cost'] ?? '',
    );
  }

  // Enviando los datos al servidor DB
  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt,
      "mecanicoId": mecanicoId,
      "requestDetails": requestDetails,
      "status": status,
      "userId": userId,
      "userLocation": userLocation,
      //"cost": cost,
    };
  }
}
