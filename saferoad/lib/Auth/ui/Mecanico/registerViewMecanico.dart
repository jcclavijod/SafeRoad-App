// ignore_for_file: avoid_print, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_init_to_null, unnecessary_null_comparison
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saferoad/Auth/bloc/mecanico/bloc/mecanico_bloc.dart';
import 'package:saferoad/Auth/model/mecanico_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as ma;

class RegisterMechanicView extends StatefulWidget {
  @override
  _RegisterMechanicViewState createState() => _RegisterMechanicViewState();
}

class _RegisterMechanicViewState extends State<RegisterMechanicView> {
  final _formKey = GlobalKey<FormState>();
  final MecanicoBloc _mecanicoBloc = MecanicoBloc();
  final ImagePicker _picker = ImagePicker();
  final geo = GeoFlutterFire();
  final firestore = FirebaseFirestore.instance;
  bool _hasSelectedImage = false;
  bool _hasSelectedVoucher = false;
  XFile? _imageFile;
  XFile? _voucherFile;
  String name = '';
  String lastname = '';
  String mail = '';
  String password = '';
  String identification = '';
  String? gender = 'Masculino';
  String local = '';
  String address = '';
  String phoneNumber = '';
  DateTime? birthday;
  String uid = '';
  bool isAvailable = true;
  double calification = 0;
  GeoPoint? position;
  String token = '';
  GeoPoint? defaultGeoPoint;
  String defaultGeohash = 's0000000000';
  Position? defaultPosition;
  double? locationLatitude;
  double? locationLongitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Mecánico'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Apellido'),
                onChanged: (value) {
                  setState(() {
                    lastname = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Correo'),
                onChanged: (value) {
                  setState(() {
                    mail = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contraseña'),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                obscureText: true,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cédula'),
                onChanged: (value) {
                  setState(() {
                    identification = value;
                  });
                },
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Género'),
                value: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Masculino',
                    child: Text('Masculino'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Femenino',
                    child: Text('Femenino'),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Local'),
                onChanged: (value) {
                  setState(() {
                    local = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Dirección del Local'),
                onChanged: (value) {
                  setState(() {
                    address = value;
                  });
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Número de teléfono'),
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value;
                  });
                },
                keyboardType: TextInputType.phone,
              ),
              InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      birthday = pickedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Cumpleaños',
                  ),
                  child: Text(
                    birthday != null
                        ? "${birthday!.toLocal()}".split(' ')[0]
                        : 'Selecciona una fecha',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _imageFile = image;
                      _hasSelectedImage = true;
                    });
                    print('Imagen Seleccionada');
                  } else {
                    print('No se seleccionó ninguna imagen.');
                  }
                },
                child: const Text('Seleccionar imagen de perfil'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final XFile? voucher =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (voucher != null) {
                    setState(() {
                      _voucherFile = voucher;
                      _hasSelectedVoucher = true;
                    });
                    print('Comprobante Seleccionado');
                  } else {
                    print('No se seleccionó ningún comprobante.');
                  }
                },
                child: const Text('Seleccionar comprobante'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_hasSelectedImage && _hasSelectedVoucher) {
                    if (_formKey.currentState!.validate()) {
                      _getCoordinates(); // Llama a _getCoordinates aquí
                    } else {
                      print('Por favor, completa el formulario correctamente.');
                    }
                  } else {
                    print(
                        'Por favor, selecciona una imagen de perfil y un comprobante.');
                  }
                },
                child: const Text('Registrarse como Mecánico'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getCoordinates() async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations != null && locations.isNotEmpty) {
        Location location = locations.first;
        defaultGeoPoint = GeoPoint(location.latitude, location.longitude);
        defaultGeohash = geo
            .point(latitude: location.latitude, longitude: location.longitude)
            .hash;
        defaultPosition = Position(
          geohash: defaultGeohash,
          geopoint: defaultGeoPoint!,
        );
        _mecanicoBloc.registerMecanico(
          name,
          lastname,
          mail,
          local,
          address,
          password,
          identification,
          gender!,
          phoneNumber,
          birthday.toString(),
          File(_imageFile!.path),
          File(_voucherFile!.path),
          calification,
          defaultPosition!,
          token,
        );
      }
    } on Exception catch (_) {
      print('No se pudo obtener la ubicación');
    }
  }
}
