// ignore: file_names
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const Color periwinkleColor = Color.fromARGB(255, 103, 103, 186);
  static const Color backgroundColor = Color.fromRGBO(245, 248, 255, 1.0);

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor, // Set the background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/tambag.png'),
                width: 200.0,
                height: 150.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 25),
              const Text(
                'TAMBAG',
                style: TextStyle(
                  color: periwinkleColor,
                  fontSize: 35.0,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.normal,
                  decoration: TextDecoration.none,
                  fontFamily: 'Arial',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 200.0,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      color: periwinkleColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal,
                      decoration: TextDecoration.none,
                      fontFamily: 'Arial',
                    ),
                    children: [
                      TextSpan(text: 'Telehealth And\n'),
                      TextSpan(text: 'Medication-Barrangay\n'),
                      TextSpan(text: 'Assistance for Geriatic'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 220,
                child: TextField(
                  controller: usernameController,
                  obscureText: true,
                  decoration:  InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(229, 255, 255, 255), // Set the label text color
                    ),
                    alignLabelWithHint: true, // Align label with the hint text
                    floatingLabelBehavior: FloatingLabelBehavior.never, // Make the label not float
                    filled: true, // Set to true for a filled background
                    fillColor: periwinkleColor, 
                    contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 68.0), // Adjust padding
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // Set the border radius
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 220, // Set the desired width
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(229, 255, 255, 255), // Set the label text color
                    ),
                    alignLabelWithHint: true, // Align label with the hint text
                    floatingLabelBehavior: FloatingLabelBehavior.never, // Make the label not float
                    filled: true, // Set to true for a filled background
                    fillColor: periwinkleColor, // Set the background color
                    contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 70.0), // Adjust padding
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // Set the border radius
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add your submit button logic here
                  String username = usernameController.text;
                  String password = passwordController.text;
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
