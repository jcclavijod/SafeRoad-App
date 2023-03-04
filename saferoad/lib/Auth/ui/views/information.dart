// ignore_for_file: camel_case_types, file_names, duplicate_ignore

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saferoad/Auth/provider/provider.dart';
import 'package:saferoad/Auth/ui/views/homes_screen.dart';
import 'package:saferoad/Auth/ui/widgets/custom_button.dart';
import 'package:saferoad/Auth/ui/widgets/utils.dart';
import 'package:saferoad/Auth/model/Models.dart';

class userInformations extends StatefulWidget {
  const userInformations({super.key});

  @override
  State<userInformations> createState() => _userInformationsState();
}

class _userInformationsState extends State<userInformations> {
  File? image;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final localController = TextEditingController();
  final cedulaControler = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    localController.dispose();
    cedulaControler.dispose();
    bioController.dispose();
  }

  //PARA SELECCIONAR UNA IMAGEN
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
                child: Center(
                  child: Center(
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.arrow_back),
                            )),
                        InkWell(
                          onTap: () => selectImage(),
                          child: image == null
                              ? const CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 50,
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 50,
                                    color: Colors.white,
                                  ))
                              : CircleAvatar(
                                  backgroundImage: FileImage(image!),
                                  radius: 50,
                                ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          margin: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              //Campo del nombre
                              textFeld(
                                hintText: "Tu nombre",
                                icon: Icons.account_circle,
                                inputType: TextInputType.name,
                                maxLines: 1,
                                controller: nameController,
                              ),
                              //Campo del telefono
                              textFeld(
                                hintText: "Tu telefono",
                                icon: Icons.phone,
                                inputType: TextInputType.number,
                                maxLines: 1,
                                controller: nameController,
                              ),
                              //Campo del local
                              textFeld(
                                hintText: "Nombre del local",
                                icon: Icons.construction,
                                inputType: TextInputType.name,
                                maxLines: 1,
                                controller: localController,
                              ),
                              //Campo de la cedula
                              textFeld(
                                hintText: "Cedula",
                                icon: Icons.perm_identity,
                                inputType: TextInputType.number,
                                maxLines: 1,
                                controller: cedulaControler,
                              ),
                              //Campo de la descripción
                              textFeld(
                                hintText: "Descripción",
                                icon: Icons.edit,
                                inputType: TextInputType.name,
                                maxLines: 2,
                                controller: bioController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: CustomButton(
                              text: "Continuar",
                              onPressed: () => storeData(),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.blue,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
            prefixIcon: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
              ),
              child: Icon(
                icon,
                size: 20,
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            hintText: hintText,
            alignLabelWithHint: true,
            border: InputBorder.none,
            fillColor: Colors.blue.shade50,
            filled: true),
      ),
    );
  }

  // ENVIAR DATOS A LA BASE DE DATOS
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModels userModel = UserModels(
      name: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      cedula: cedulaControler.text.trim(),
      local: localController.text.trim(),
      bio: bioController.text.trim(),
      email: "",
      profilePic: "",
      createdAt: "",
      uid: "",
    );
    if (image != null) {
      ap.saveUserDataToFirebases(
        context: context,
        userModels: userModel,
        profilePic: image!,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
    } else {
      showSnackBar(context, "Por favor sube una foto de perfil");
    }
  }
}
