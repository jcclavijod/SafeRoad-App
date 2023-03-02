import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:saferoad/Auth/Repository/emailPassword_controller.dart';
import 'package:saferoad/Auth/ui/views/password_view.dart';
import 'package:saferoad/auth/bloc/app_bloc.dart';

class EmailView extends StatelessWidget {
  const EmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, bottom: 25, top: 50),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ingresa tu correo',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Ingresa tu correo para crear una cuenta',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(
                      Icons.alternate_email,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      height: 50,
                      width: 250,
                      child: BlocBuilder<AppBloc, AppState>(
                        builder: (context, state) {
                          return TextField(
                            controller: emailController,
                            onSubmitted: (value) {
                              // ignore: invalid_use_of_visible_for_testing_member
                              context.read<AppBloc>().emit(
                                  const AppStateLoggedOut(
                                      isLoading: false, succesful: false));
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const PasswordView(),
                                      type: PageTransitionType.fade,
                                      duration:
                                          const Duration(milliseconds: 250)));
                            },
                            autofocus: true,
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)),
                                hintText: 'Correo',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade500),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400))),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, right: 25),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: const PasswordView(),
                                type: PageTransitionType.fade,
                                duration: const Duration(milliseconds: 250)));
                      },
                      color: Colors.blue,
                      child: const Icon(Icons.navigate_next),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
