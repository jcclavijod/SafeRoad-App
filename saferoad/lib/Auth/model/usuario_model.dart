class UserModel {
  final String name;
  final String lastname;
  final String mail;
  final String password;
  final String identification;
  final String gender;
  final String phoneNumber;
  final String birthday;
  final String profilePic;
  final bool isAviable;
  final String uid;
  final String token;

  const UserModel({
    required this.name,
    required this.lastname,
    required this.mail,
    required this.password,
    required this.identification,
    required this.gender,
    required this.phoneNumber,
    required this.birthday,
    required this.profilePic,
    required this.isAviable,
    required this.uid,
    required this.token,
  });

  UserModel copyWith({
    String? name,
    String? lastname,
    String? mail,
    String? password,
    String? identification,
    String? gender,
    String? phoneNumber,
    String? birthday,
    String? uid,
    String? profilePic,
    bool? isAviable,
    String? token,
  }) {
    return UserModel(
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      mail: mail ?? this.mail,
      password: password ?? this.password,
      identification: identification ?? this.identification,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      birthday: birthday ?? this.birthday,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      isAviable: isAviable ?? this.isAviable,
      token: token ?? this.token,
    );
  }

  factory UserModel.complete({
    String name = "",
    String lastname = "",
    String mail = "",
    String password = "",
    String identification = "",
    String gender = "",
    String phoneNumber = "",
    String birthday = "",
    String uid = "",
    String profilePic = "",
    bool isAviable = false,
    String token = "",
  }) {
    return UserModel(
      name: name,
      lastname: lastname,
      mail: mail,
      password: password,
      identification: identification,
      gender: gender,
      phoneNumber: phoneNumber,
      birthday: birthday,
      uid: uid,
      profilePic: profilePic,
      isAviable: isAviable,
      token: token,
    );
  }
  //Obteniendo datos del servidor
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      lastname: map['lastname'],
      mail: map['mail'],
      password: map['password'],
      identification: map['identification'],
      gender: map['gender'],
      phoneNumber: map['phoneNumber'],
      birthday: map['birthday'],
      uid: map['uid'],
      profilePic: map['profilePic'],
      isAviable: map['isAviable'],
      token: map['token'],
    );
  }
  //Enviando datos al servidor
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastname': lastname,
      'mail': mail,
      'password': password,
      'identification': identification,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'birthday': birthday,
      'uid': uid,
      'profilePic': profilePic,
      'isAviable': isAviable,
      'token': token
    };
  }
}
