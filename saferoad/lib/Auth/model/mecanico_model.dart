import 'package:cloud_firestore/cloud_firestore.dart';

class Position {
  final String geohash;
  final GeoPoint geopoint;

  const Position({
    required this.geohash,
    required this.geopoint,
  });
}

class MecanicoModel {
  final String name;
  final String lastname;
  final String mail;
  final String local;
  final String address;
  final String password;
  final String identification;
  final String gender;
  final String phoneNumber;
  final String birthday;
  final String profilePic;
  final String voucher;
  final double calification;
  final String uid;
  final String token;
  final bool isAviable;
  final Position position;

  const MecanicoModel({
    required this.name,
    required this.lastname,
    required this.mail,
    required this.local,
    required this.address,
    required this.password,
    required this.identification,
    required this.gender,
    required this.phoneNumber,
    required this.birthday,
    required this.uid,
    required this.profilePic,
    required this.voucher,
    required this.calification,
    required this.token,
    required this.isAviable,
    required this.position,
  });

  MecanicoModel copyWith({
    String? name,
    String? lastname,
    String? mail,
    String? local,
    String? address,
    String? password,
    String? identification,
    String? gender,
    String? phoneNumber,
    String? birthday,
    String? profilePic,
    String? voucher,
    double? calification,
    String? uid,
    String? token,
    bool? isAviable,
    Position? position,
    
  }) {
    return MecanicoModel(
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      mail: mail ?? this.mail,
      local: local ?? this.local,
      address: address ?? this.address,
      password: password ?? this.password,
      identification: identification ?? this.identification,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthday: birthday ?? this.birthday,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      voucher: voucher ?? this.voucher,
      calification: calification ?? this.calification,
      token: token ?? this.token,
      isAviable: isAviable ?? this.isAviable,
      position: position ?? this.position,
    );
  }

  factory MecanicoModel.complete({
    required String name,
    required String lastname,
    required String mail,
    required String local,
    required String address,
    required String password,
    required String identification,
    required String gender,
    required String phoneNumber,
    required String birthday,
    required String uid,
    required String profilePic,
    required String voucher,
    required double calification,
    required String token,
    required bool isAviable,
    required Position position,
  }) {
    return MecanicoModel(
        name: name,
        lastname: lastname,
        mail: mail,
        local: local,
        address: address,
        password: password,
        identification: identification,
        gender: gender,
        phoneNumber: phoneNumber,
        birthday: birthday,
        uid: uid,
        profilePic: profilePic,
        voucher: voucher,
        calification: calification,
        token: token,
        isAviable: isAviable,
        position: position);
  } //Obteniendo datos del servidor
  factory MecanicoModel.fromMap(Map<String, dynamic> map) {
    return MecanicoModel(
      name: map['name'],
      lastname: map['lastname'],
      mail: map['mail'],
      local: map['local'],
      address: map['address'],
      password: map['password'],
      identification: map['identification'],
      gender: map['gender'],
      phoneNumber: map['phoneNumber'],
      birthday: map['birthday'],
      uid: map['uid'],
      profilePic: map['profilePic'],
      voucher: map['voucher'],
      calification: map['calification'],
      token: map['token'],
      isAviable: map['isAviable'],
      position: Position(
        geohash: map['position']['geohash']?.toString()??'',
        geopoint: map['position']['geopoint'] as GeoPoint,
      ),
    );
  } //Enviando datos al servidor
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastname': lastname,
      'mail': mail,
      'local': local,
      'address': address,
      'password': password,
      'identification': identification,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'birthday': birthday,
      'uid': uid,
      'fotoPerfil': profilePic,
      'voucher': voucher,
      'calification': calification,
      'token': token,
      'isAviable': isAviable,
      'position': {
        'geohash': position.geohash,
        'geopoint': position.geopoint,
      },
    };
  }
}
