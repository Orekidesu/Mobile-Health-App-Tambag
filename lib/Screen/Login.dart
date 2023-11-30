import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const Color periwinkleColor = Color.fromARGB(255, 103, 103, 186);
  static const Color periwinkleColorLight = Color.fromARGB(255, 139, 139, 177);
  static const Color backgroundColor = Color.fromRGBO(245, 248, 255, 1.0);
  static const LinearGradient periwinkleGradient = LinearGradient(
    colors: [Color.fromARGB(255, 103, 103, 186), Color.fromARGB(255, 103, 103, 186)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('admin').doc(uid).get();
      return userDoc.data() ?? {};
    } catch (e) {
      // Handle any errors that might occur while fetching the user info
      return {};
    }
  }

 // Modify the submitDatabase method
  Future<void> submitDatabase(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      // Successfully logged in, get additional user information
      // ignore: unnecessary_cast
      Map<String, dynamic> userInfo = await getUserInfo(user!.uid as String);

      // You can now access first_name, middle_name, last_name from userInfo map
      String firstName = userInfo['first_name'] ?? '';
      String middleName = userInfo['middle_name'] ?? '';
      String lastName = userInfo['last_name'] ?? '';

      // Show success notification and auto-close
      showSuccessNotification(firstName, middleName, lastName);
        } on FirebaseAuthException catch (e) {
          // Handle specific FirebaseAuth exceptions
          showErrorNotification(e.message);
        } catch (e) {
          showErrorNotification(e as String?);
        }
      }

    void showSuccessNotification(String firstName, String middleName, String lastName) {
      Fluttertoast.showToast(
        msg: 'Login Successful\nWelcome to Tambag App!\n$firstName $middleName $lastName',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: periwinkleColor,
        textColor: Colors.white,
        fontSize: 16.0,
        webPosition: "center",
        webBgColor: "$periwinkleGradient"
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    }

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
                width: 150.0,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    String email = emailController.text;
                    String password = passwordController.text;

                    if (email.isNotEmpty && password.isNotEmpty) {
                      submitDatabase(email, password);
                    } else {
                      showErrorNotification("Email and password cannot be empty");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: periwinkleColor,
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
