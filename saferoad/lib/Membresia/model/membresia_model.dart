// ignore_for_file: camel_case_types
class membresiaModel{
  String? uid;
  String? membresia;
  String? precio;
  String? fechaInicial;
  String? fechaFinal;
  String? estado;

  membresiaModel({ this.uid, this.membresia, this.precio, this.fechaInicial, this.fechaFinal, this.estado});

  membresiaModel.fromMap(Map<String, dynamic> map){
    uid = map['uid'];
    membresia = map['membresia'];
    precio = map['precio'];
    fechaInicial = map['fechaInicial'];
    fechaFinal = map['fechaFinal'];
    estado = map['estado'];
  }

  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'membresia': membresia,
      'precio': precio,
      'fechaInicial': fechaInicial,
      'fechaFinal': fechaFinal,
      'estado': estado,
    };
  }
}