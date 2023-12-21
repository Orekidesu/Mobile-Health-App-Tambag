// ignore_for_file: depend_on_referenced_packages, unused_element

import 'dart:convert';

import 'package:flutter/material.dart';
import '../Custom_Widgets/Custom_Dialog.dart';
import '../Screen/Login.dart';  
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/light_constants.dart';
import 'package:http/http.dart' as http;

const apiKey = '0EAC57AC-ECAF-6206-24DB-2688BF5EF58F';
const username = 'Kael_fiel';

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


Future<bool> sendSMS(String recipient, String message) async {
  final credentials = base64Encode(utf8.encode('$username:$apiKey'));
  final headers = {
    'Authorization': 'Basic $credentials',
    'Content-Type': 'application/json'
  };

  final url = Uri.parse('https://rest.clicksend.com/v3/sms/send');
  final body = jsonEncode({
    'messages': [
      {
        'body': message,
        'from': '+639380363909',
        'to': recipient
      }
    ]
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData["data"]["messages"][0]["status"] == 'INSUFFICIENT_CREDIT')
      {
        showErrorNotification('Insufficient Credits!\nContact Admin to reload.');
        return false;
      }
      else if (responseData["data"]["messages"][0]["status"] == 'INVALID_RECIPIENT')
      {
        showErrorNotification('Invalid Recipient!');
        return false;
      }
      else{
        return true; // SMS sent successfully
      }
      
    } else {
      return false; // Failed to send SMS
    }

  } catch (e) {
    showErrorNotification('Error sending SMS: $e');
    return false; // Error sending SMS
  }
}


  
