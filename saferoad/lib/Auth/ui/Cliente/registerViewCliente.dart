// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saferoad/Auth/bloc/cliente/cliente_bloc.dart';
import 'package:saferoad/Auth/ui/Cliente/LoginViewCliente.dart';
import 'package:saferoad/Auth/ui/views/passwordReset.dart';

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
  String token = '';
  bool isAvailable = true;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 16),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(16.0),
                ),
                child: Column(
                  children: const [
                    Icon(
                      Icons.camera_alt,
                      size: 36,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Seleccionar imagen de perfil',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
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
                    return 'Por favor, ingresa tu contraseña.';
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
                    return 'Por favor, ingresa tu número de cédula.';
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
                    labelText: 'Fecha de nacimiento',
                  ),
                  child: Text(
                    birthday != null
                        ? "${birthday!.toLocal()}".split(' ')[0]
                        : 'Selecciona una fecha',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_hasSelectedImage) {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        await _clienteBloc.registerUser(
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
                          token,
                          File(_imageFile!.path),
                        );
                        Navigator.of(context).pushReplacementNamed('/');
                      } catch (e) {
                        print('Error al registrar usuario: $e');
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Por favor, completa el formulario correctamente.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Por favor, selecciona una imagen de perfil.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(16.0),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : const Text('Registrarse'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _navigateToCliente(context),
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

  void _navigateToCliente(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }
}
