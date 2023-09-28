// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:saferoad/Home/ui/views/userpage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../widgets/utils.dart';

class RegisterM extends StatefulWidget {
  final VoidCallback showlogingPage;
  const RegisterM({super.key, required this.showlogingPage});
  @override
  State<RegisterM> createState() => _RegisterMState();
}

class _RegisterMState extends State<RegisterM> {
  String? _uid;
  String get uid => _uid!;
  late TextEditingController _selectedGenderController;
  final _emailConroller = TextEditingController();
  final _passwordConroller = TextEditingController();
  final _confirm_pw_Conroller = TextEditingController();
  final _firstNameConroller = TextEditingController();
  final _LastNameConroller = TextEditingController();
  final _cedulaConroller = TextEditingController();
  File? profilePic;
  final _phoneConroller = TextEditingController();
  final _GeneroConroller = TextEditingController();
  final _ubicacionConroller = TextEditingController();
  final _LocalConroller = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void dispose() {
    _emailConroller.dispose();
    _passwordConroller.dispose();
    _confirm_pw_Conroller.dispose();
    _phoneConroller.dispose();
    _LocalConroller.dispose();
    _GeneroConroller.dispose();
    _ubicacionConroller.dispose();
    super.dispose();
  }

  void _pickImage() async {
    profilePic = await pickImage(context);
    setState(() {});
  }

  void initState() {
    super.initState();
    _selectedGenderController = TextEditingController(text: 'Hombre');
  }

  void checkConfirmPW() {
    if (_passwordConroller.text.trim() == _confirm_pw_Conroller.text.trim() &&
        _firstNameConroller.text.isNotEmpty &&
        _LastNameConroller.text.isNotEmpty &&
        _cedulaConroller.text.isNotEmpty &&
        _emailConroller.text.isNotEmpty &&
        _phoneConroller.text.isNotEmpty &&
        _LocalConroller.text.isNotEmpty &&
        _GeneroConroller.text.isEmpty &&
        _ubicacionConroller.text.isEmpty) {
      sinUp();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Por favor confirma tu contraseña!'),
          );
        },
      );
    }
  }

  Future<void> sinUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailConroller.text.trim(),
          password: _passwordConroller.text.trim());

      if (profilePic != null) {
        await storeFileToStorage("profilePic/$_uid", profilePic!)
            .then((value) async {
          await addUserDetails(
            _firstNameConroller.text.trim(),
            _LastNameConroller.text.trim(),
            _cedulaConroller.text.trim(),
            _emailConroller.text.trim(),
            _GeneroConroller.text.trim(),
            _ubicacionConroller.text.trim(),
            _uid = _firebaseAuth.currentUser!.uid.toString(),
            value,
            _phoneConroller.text.trim(),
            _LocalConroller.text.trim(),
          );
        });
      } else {
        await addUserDetails(
          _firstNameConroller.text.trim(),
          _LastNameConroller.text.trim(),
          _cedulaConroller.text.trim(),
          _emailConroller.text.trim(),
          _GeneroConroller.text.trim(),
          _ubicacionConroller.text.trim(),
          uid,
          null,
          _phoneConroller.text.trim(),
          _LocalConroller.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('${e.message}'),
          );
        },
      );
    }
    CircularProgressIndicator;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const UserPage()),
    );
  }

  Future addUserDetails(
      String firstName,
      String lastName,
      String cedula,
      String genero,
      String ubicacion,
      String email,
      String uid,
      String? profilePicUrl,
      phoneNumber,
      local) async {
    String? token = await _firebaseMessaging.getToken();
    await FirebaseFirestore.instance.collection('mecanicos').doc(uid).set({
      'first name': firstName,
      'last name': lastName,
      'cedula': cedula,
      'email': email,
      'genero': genero,
      'ubicacion': ubicacion,
      'profilePic': profilePicUrl,
      'uid': uid,
      'phoneNumber': phoneNumber,
      'local': local,
      'token': token,
    });
  }

  Future<String> storeFileToStorage(String path, File file) async {
    final storageRef = FirebaseStorage.instance.ref().child(path);
    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back),
                  )),
              InkWell(
                onTap: () => _pickImage(),
                child: profilePic == null
                    ? const CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 50,
                        child: Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.white,
                        ))
                    : CircleAvatar(
                        backgroundImage: FileImage(profilePic!),
                        radius: 50,
                      ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameConroller,
                            decoration: InputDecoration(
                              hintText: 'Nombre',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _LastNameConroller,
                            decoration: InputDecoration(
                              hintText: 'Apellido',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _cedulaConroller,
                  decoration: InputDecoration(
                      hintText: 'Cedula',
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.grey[200],
                      filled: true),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DropdownButtonFormField(
                  value: _selectedGenderController.text,
                  items: const [
                    DropdownMenuItem(
                      value: 'Hombre',
                      child: Text('Masculino'),
                    ),
                    DropdownMenuItem(
                      value: 'mujer',
                      child: Text('Femenino'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedGenderController.text = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailConroller,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneConroller,
                            decoration: InputDecoration(
                              hintText: 'Telefono',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _LocalConroller,
                  decoration: InputDecoration(
                      hintText: 'Local',
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.grey[200],
                      filled: true),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _ubicacionConroller,
                  decoration: InputDecoration(
                      hintText: 'Ubicacion',
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.grey[200],
                      filled: true),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _passwordConroller,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Contraseña',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _confirm_pw_Conroller,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Confirmar Contraseña',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: () => checkConfirmPW(),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ya tengo cuenta',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: widget.showlogingPage,
                    child: const Text(
                      'Iniciar sesion',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}