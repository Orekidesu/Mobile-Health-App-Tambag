// ignore_for_file: depend_on_referenced_packages, unused_element

import 'dart:convert';

import 'package:flutter/material.dart';
import '../Custom_Widgets/Custom_Dialog.dart';
import '../Screen/Login.dart';  
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/light_constants.dart';
import 'package:http/http.dart' as http;

void showSuccessNotification(String msg) {
  Fluttertoast.showToast(
      msg: msg,
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

void goToPage(BuildContext context, Widget? page) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page!,
    ),
  );
}

void goToPageNoReturn(BuildContext context, Widget? page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => page!,
    ),
  );
}

void signout(BuildContext context) {
  Fluttertoast.showToast(
      msg: 'Signout Success',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: periwinkleColor,
      textColor: Colors.white,
      fontSize: 16.0,
      webPosition: "center",
      webBgColor: "$periwinkleGradient",
    );
  // Navigate to the login page
  goToPageNoReturn(context, const Login());
}

void showSignOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(
        buttonText: 'Log out',
        onSignOut: () {
          signout(context);
        },
        message: 'Log out of your Account?',
      );
    },
  );
}

Future<bool> sendSMS(String message, String number) async {
  const apiKey = 'de3cece6f45d6d678c794c37a3625650';

  var uri = Uri.https('semaphore.co', '/api/v4/messages', {
    'apikey': apiKey,
    'message': message,
    'number': number,
  });

  var response = await http.post(uri);

  if (response.statusCode == 200) {
    showSuccessNotification('Message Sent!');
    return true;
  } else {
    showErrorNotification('Failed to send message. Status code: ${response.statusCode}');
    return false;
  }
}






  
