class UserModel {
  String name;
  String cedula;
  String email;
  String bio;
  String profilePic;
  String createdAt;
  String phoneNumber;
  String uid;

  UserModel(
      {required this.name,
      required this.cedula,
      required this.email,
      required this.bio,
      required this.profilePic,
      required this.createdAt,
      required this.phoneNumber,
      required this.uid});

// Obteniendo los datos del servidor
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      cedula: map['cedula'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      profilePic: map['profilePic'] ?? '',
      createdAt: map['createdAt'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

// Enviando los datos al servidor DB
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "cedula": cedula,
      "email": email,
      "bio": bio,
      "profilePic": profilePic,
      "createdAt": createdAt,
      "phoneNumber": phoneNumber,
      "uid": uid,
    };
  }
}
