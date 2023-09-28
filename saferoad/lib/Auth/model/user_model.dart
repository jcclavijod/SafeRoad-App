class UserModel {
  final String name;
  final String cedula;
  final String local;
  final String email;
  final String bio;
  final String profilePic;
  final String createdAt;
  final String phoneNumber;
  final String uid;
  final String token;
  //bool estado;

  const UserModel(
      {required this.name,
      required this.cedula,
      required this.local,
      required this.email,
      required this.bio,
      required this.profilePic,
      required this.createdAt,
      required this.phoneNumber,
      required this.uid,
      required this.token});

  UserModel copyWith({
    String? name,
    String? cedula,
    String? local,
    String? email,
    String? bio,
    String? profilePic,
    String? createdAt,
    String? phoneNumber,
    String? uid,
    String? token,
  }) {
    return UserModel(
      name: name ?? this.name,
      cedula: cedula ?? this.cedula,
      local: local ?? this.local,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
      createdAt: createdAt ?? this.createdAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      uid: uid ?? this.uid,
      token: token ?? this.token,
    );
  }

  factory UserModel.complete({
    String name = '',
    String cedula = '',
    String local = '',
    String email = '',
    String bio = '',
    String profilePic = '',
    String createdAt = '',
    String phoneNumber = '',
    String uid = '',
    String token = '',
    // Otros campos aquí...
  }) {
    return UserModel(
      name: name,
      cedula: cedula,
      local: local,
      email: email,
      bio: bio,
      profilePic: profilePic,
      createdAt: createdAt,
      phoneNumber: phoneNumber,
      uid: uid,
      token: token,
    );
  }

// Obteniendo los datos del servidor
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      cedula: map['cedula'] ?? '',
      local: map['local'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      profilePic: map['profilePic'] ?? '',
      createdAt: map['createdAt'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      uid: map['uid'] ?? '',
      token: map['token'] ?? '',
      //estado: map['estado'] ?? '',
    );
  }

// Enviando los datos al servidor DB
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "cedula": cedula,
      "local": local,
      "email": email,
      "bio": bio,
      "profilePic": profilePic,
      "createdAt": createdAt,
      "phoneNumber": phoneNumber,
      "uid": uid,
      "token": token,
    };
  }
}
