import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:saferoad/Auth/provider/auth_provider.dart';
import 'package:saferoad/Auth/ui/views/UserInformation.dart';
import 'package:saferoad/Auth/ui/views/homes_screen.dart';
import 'package:saferoad/Auth/ui/widgets/custom_button.dart';
import 'package:saferoad/Auth/ui/widgets/utils.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
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
            : Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.arrow_back),
                          )),
                      Container(
                        width: 350,
                        height: 200,
                        padding: const EdgeInsets.all(20.09),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade50,
                        ),
                        child: Image.asset("assets/1.png"),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Verificar",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Ingresa el codigo enviado a tu telefono",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Pinput(
                        length: 6,
                        showCursor: true,
                        defaultPinTheme: PinTheme(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        onCompleted: (value) {
                          setState(() {
                            otpCode = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: CustomButton(
                          text: "Verificar",
                          onPressed: () {
                            if (otpCode != null) {
                              verifyOTP(context, otpCode!);
                            } else {
                              showSnackBar(
                                  context, "Ingresa el codigo de 6 digitos");
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "No recibiste un codigo?",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Reenviar ahora",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  //Verificación OTP
  void verifyOTP(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOTP(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSucces: () {
        //Checkear que el usuario exista en la BD
        ap.getDataFromFirestore().then(
              (value) => ap.saveUserDataToSP().then(
                    (value) => ap.setSignIn().then(
                          (value) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                              (route) => false),
                        ),
                  ),
            );
        ap.checkExistingUser().then(
          (value) async {
            if (value == true) {
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const userInformation()),
                  (route) => false);
            }
          },
        );
      },
    );
  }
}
