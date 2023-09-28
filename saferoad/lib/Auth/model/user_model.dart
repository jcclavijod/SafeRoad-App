class UserModel {
  final String name;
  final String cedula;
  final String local;
  final String genero;
  final String ubicacion;
  final String email;
  final String bio;
  final String profilePic;
  final String createdAt;
  final String phoneNumber;
  final String uid;
  //bool estado;

  const UserModel(
      {required this.name,
      required this.cedula,
      required this.local,
      required this.genero,
      required this.ubicacion,
      required this.email,
      required this.bio,
      required this.profilePic,
      required this.createdAt,
      required this.phoneNumber,
      required this.uid});

  UserModel copyWith({
    String? name,
    String? cedula,
    String? local,
    String? genero,
    String? ubicacion,
    String? email,
    String? bio,
    String? profilePic,
    String? createdAt,
    String? phoneNumber,
    String? uid,
  }) {
    return UserModel(
      name: name ?? this.name,
      cedula: cedula ?? this.cedula,
      local: local ?? this.local,
      genero: genero ?? this.genero,
      ubicacion: ubicacion ?? this.ubicacion,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
      createdAt: createdAt ?? this.createdAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      uid: uid ?? this.uid,
    );
  }

  factory UserModel.complete({
    String name = '',
    String cedula = '',
    String local = '',
    String genero = '',
    String ubicacion = '',
    String email = '',
    String bio = '',
    String profilePic = '',
    String createdAt = '',
    String phoneNumber = '',
    String uid = '',
    // Otros campos aquí...
  }) {
    return UserModel(
      name: name,
      cedula: cedula,
      local: local,
      genero: genero,
      ubicacion: ubicacion,
      email: email,
      bio: bio,
      profilePic: profilePic,
      createdAt: createdAt,
      phoneNumber: phoneNumber,
      uid: uid,
    );
  }

// Obteniendo los datos del servidor
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      cedula: map['cedula'] ?? '',
      local: map['local'] ?? '',
      genero: map['genero'] ?? '',
      ubicacion: map['ubicacion'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      profilePic: map['profilePic'] ?? '',
      createdAt: map['createdAt'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      uid: map['uid'] ?? '',
      //estado: map['estado'] ?? '',
    );
  }

// Enviando los datos al servidor DB
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "cedula": cedula,
      "local": local,
      "genero": genero,
      "ubicacion": ubicacion,
      "email": email,
      "bio": bio,
      "profilePic": profilePic,
      "createdAt": createdAt,
      "phoneNumber": phoneNumber,
      "uid": uid,
    };
  }
}
