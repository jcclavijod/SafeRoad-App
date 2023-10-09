// ignore_for_file: avoid_print, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_init_to_null, unnecessary_null_comparison, use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saferoad/Auth/bloc/mecanico/bloc/mecanico_bloc.dart';
import 'package:saferoad/Auth/model/mecanico_model.dart';
import 'package:saferoad/Auth/ui/Mecanico/LoginViewMecanico.dart';

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
  bool _isLoading = false;
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
              if (_hasSelectedImage)
                Center(
                  child: Image.file(
                    File(_imageFile!.path),
                    height: 150,
                    width: 150,
                  ),
                ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu nombre.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Apellido'),
                onChanged: (value) {
                  setState(() {
                    lastname = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu apellido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Correo'),
                onChanged: (value) {
                  setState(() {
                    mail = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu correo.';
                  }
                  return null;
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa una contraseña.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cédula'),
                onChanged: (value) {
                  setState(() {
                    identification = value;
                  });
                },
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu cédula.';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecciona tu género.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Local'),
                onChanged: (value) {
                  setState(() {
                    local = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el nombre de tu local.';
                  }
                  return null;
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa la dirección de tu local.';
                  }
                  return null;
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa tu número de teléfono.';
                  }
                  return null;
                },
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
                  print('_isLoading: $_isLoading');
                  if (_hasSelectedImage && _hasSelectedVoucher) {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        await _getCoordinates();
                      } catch (e) {
                        print('Error al obtener coordenadas: $e');
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    } else {
                      // Mostrar una alerta si el formulario no se completa correctamente
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Por favor, completa el formulario correctamente.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    // Mostrar una alerta si no se han seleccionado ambas imágenes
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Por favor, selecciona una imagen de perfil y un comprobante.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : const Text('Registrarse como Mecánico'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _navigateToMecanico(context),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text(
                  '¿Ya tienes cuenta? Inicia sesión!',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMecanico(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginMecanico()),
    );
  }

  Future<void> _getCoordinates() async {
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
        Navigator.of(context).pushReplacementNamed('/');
      }
    } on Exception catch (_) {
      print('No se pudo obtener la ubicación');
    }
  }
}
