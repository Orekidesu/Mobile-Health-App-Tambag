// custom_toast.dart

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/light_constants.dart';

class CustomToast extends StatelessWidget {
  final String message;

  const CustomToast({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: periwinkleColor,
      textColor: Colors.white,
      fontSize: 16.0,
      webPosition: "center",
      webBgColor: "$periwinkleGradient",
    );

    return const SizedBox.shrink(); // Empty widget, as showToast handles the display
  }
}
