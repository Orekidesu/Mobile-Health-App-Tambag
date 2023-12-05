import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDialog extends StatelessWidget {
  final VoidCallback onSignOut;
  final String message;
  final bool? showtitle; 

  CustomDialog({
    required this.onSignOut,
    required this.message,
    this.showtitle,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: showtitle ?? false ? const Text('Message') : null,
      content: Text(message),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        CupertinoDialogAction(
          child: const Text('Yes'),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            onSignOut();
          },
        ),
      ],
    );
  }
}
