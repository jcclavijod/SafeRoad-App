class UserModel {
  String name;
  String cedula;
  String local;
  String email;
  String bio;
  String profilePic;
  String createdAt;
  String phoneNumber;
  String uid;
  //bool estado;

  UserModel({
    this.name = '',
    this.cedula = '',
    this.local = '',
    this.email = '',
    this.bio = '',
    this.profilePic = '',
    this.createdAt = '',
    this.phoneNumber = '',
    this.uid = '',
    //this.estado = false
  });

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
    };
  }
}
