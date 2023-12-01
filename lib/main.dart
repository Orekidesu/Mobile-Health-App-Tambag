import 'dart:html';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:mobile_health_app_tambag/Screen/Login.dart';
import 'package:mobile_health_app_tambag/Screen/Dashboard.dart'; // Import Dashboard
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Health App Tambag',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Display loading indicator while checking authentication state.
          } else {
            if (snapshot.hasData) {
              // User is logged in, navigate to Dashboard.
              // return Patient_Profile();
              return const Dashboard();
            } else {
              // User is not logged in, navigate to Login.
              return const Login();
            }
          }
        },
      ),
    );
  }
}
