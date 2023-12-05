// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import '../Custom_Widgets/Custom_Dialog.dart';
import '../Screen/Login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/light_constants.dart';

void showSuccessNotification() {
  Fluttertoast.showToast(
      msg: 'Signin Success',
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
  Navigator.pushReplacement(
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
        onSignOut: () {
          signout(context);
        },
        message: 'Are you sure to Signout?',
      );
    },
  );
}

  
