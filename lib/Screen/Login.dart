// ignore: file_names
// ignore_for_file: depend_on_referenced_packages, file_names, duplicate_ignore

import 'package:flutter/material.dart';
import '../functions/custom_functions.dart';
import 'Dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/light_constants.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


    void showErrorNotification(String? errorMessage) {
      Fluttertoast.showToast(
        msg: 'Error: ${errorMessage ?? "Unknown error"}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: periwinkleColor,
        textColor: Colors.white,
        fontSize: 16.0,
        webPosition: "center",
        webBgColor: "$periwinkleGradient",
      );
    }

    // Modify the submitDatabase method
  Future<void> submitDatabase(BuildContext context,String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Show success notification and auto-close
      showSuccessNotification();
      // ignore: use_build_context_synchronously
      goToPageNoReturn(context,const Dashboard());
        } on FirebaseAuthException catch (e) {
          // Handle specific FirebaseAuth exceptions
          showErrorNotification(e.message);
        } catch (e) {
          showErrorNotification(e as String?);
        }
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/tambag.png'),
                width: 250.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                'TAMBAG',
                style: TextStyle(
                  color: periwinkleColor,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 220.0,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      color: periwinkleColorLight,
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                    ),
                    children: [
                      TextSpan(text: 'Telehealth And\n'),
                      TextSpan(text: 'Medication-Barangay\n'),
                      TextSpan(text: 'Assistance for Geriatic'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 260,
                child: TextField(
                  controller: emailController,
                  obscureText: false,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(229, 255, 255, 255),
                    ),
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: periwinkleColor,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 30.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 260,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(229, 255, 255, 255),
                    ),
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: periwinkleColor,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 30.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                      submitDatabase(context, emailController.text, passwordController.text);
                    } else {
                      showErrorNotification("Email and password cannot be empty");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: backgroundColor, // Use primary for background color
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: periwinkleColor // Use Colors.blue as an example color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
