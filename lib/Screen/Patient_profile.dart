import 'package:flutter/material.dart';
import 'package:mobile_health_app_tambag/Screen/Dashboard.dart';

class Patient_Profile extends StatefulWidget {
  const Patient_Profile({super.key});

  @override
  State<Patient_Profile> createState() => _Patient_ProfileState();
}

class _Patient_ProfileState extends State<Patient_Profile> {
  static const Color backgroundColor = Color.fromRGBO(245, 248, 255, 1.0);
  static const Color periwinkleColor = Color.fromARGB(255, 103, 103, 186);
  static const Color rose = Color.fromRGBO(230, 192, 201, 1.0);
  static const Color lightyellow = Color.fromRGBO(255, 229, 167, 1.0);
  static const Color lightblue = Color.fromRGBO(167, 215, 246, 1.0);
  static const LinearGradient periwinkleGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 103, 103, 186),
      Color.fromARGB(255, 103, 103, 186)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: periwinkleColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const Dashboard(), // Replace with your login page widget
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TAMBAG',
                          style: TextStyle(
                            color: periwinkleColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'PROFILE',
                          style: TextStyle(
                            color: periwinkleColor,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
