import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../Screen/Login.dart';
import '../Screen/Dashboard.dart'; // Import Dashboard
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Health App Tambag',
      theme: ThemeData(
        // Set the default font family for the entire app
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Arial'),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Display loading indicator while checking authentication state.
          } else {
            if (snapshot.hasData) {
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
