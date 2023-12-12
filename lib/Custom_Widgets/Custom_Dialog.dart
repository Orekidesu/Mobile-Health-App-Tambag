import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDialog extends StatelessWidget {
  final VoidCallback onSignOut;
  final String message;
  final bool? showtitle; 
  final String buttonText;

  const CustomDialog({super.key, 
    required this.buttonText,
    required this.onSignOut,
    required this.message,
    this.showtitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: showtitle ?? false ? const Text('Message') : null,
      content: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.bold, // Set the content text to bold
          fontSize: 17,
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          textStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 255)
          ),
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        CupertinoDialogAction(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 0, 0),
          ),
          child: Text(buttonText),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            onSignOut();
          },
        ),
      ],
    );
  }
}
