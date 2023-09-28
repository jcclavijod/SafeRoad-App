import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saferoad/Auth/bloc/cliente/cliente_bloc.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final ClienteBloc _clienteBloc = ClienteBloc();
  final ImagePicker _picker = ImagePicker();
  bool _hasSelectedImage = false;
  XFile? _imageFile;
  String name = '';
  String lastname = '';
  String mail = '';
  String password = '';
  String identification = '';
  String? gender = 'Masculino';
  String phoneNumber = '';
  DateTime? birthday;
  String uid = '';
  bool isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apellido'),
                onChanged: (value) {
                  setState(() {
                    lastname = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo'),
                onChanged: (value) {
                  setState(() {
                    mail = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                obscureText: true,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cédula'),
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
                decoration: InputDecoration(labelText: 'Número de teléfono'),
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
                  decoration: InputDecoration(
                    labelText: 'Cumpleaños',
                  ),
                  child: Text(
                    birthday != null
                        ? "${birthday!.toLocal()}".split(' ')[0]
                        : 'Selecciona una fecha',
                    style: TextStyle(fontSize: 16),
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
                child: Text('Seleccionar imagen de perfil'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_hasSelectedImage) {
                    if (_formKey.currentState!.validate()) {
                      _clienteBloc.registerUser(
                        name,
                        lastname,
                        mail,
                        password,
                        identification,
                        gender!,
                        phoneNumber,
                        birthday.toString(),
                        uid,
                        isAvailable,
                        File(_imageFile!.path),
                      );
                    } else {
                      print('Por favor, completa el formulario correctamente.');
                    }
                  } else {
                    print('Por favor, selecciona una imagen de perfil.');
                  }
                },
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
