// ignore_for_file: library_private_types_in_public_api, file_names, camel_case_types

import 'package:flutter/material.dart';

import '../constants/light_constants.dart';
import 'CustomActionButton.dart';
import 'Custom_Dialog.dart';

class addMedication extends StatefulWidget {
  const addMedication({super.key});

  @override
  _addMedicationState createState() => _addMedicationState();
}

class _addMedicationState extends State<addMedication> {
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  void showTestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          buttonText: 'Submit',
          onSignOut: () {},
          message: 'Do you want to Submit?',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medication:',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: periwinkleColor), // Adjust the font size as needed
        ),
        TextField(
          controller: medicationController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Adjust the radius as needed
              borderSide: const BorderSide(
                color: periwinkleColor, // Set the border color
                width: 4,
              ),
            ),
          ),
          // Additional properties for the TextField can be added here
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Quantity:',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: periwinkleColor), // Adjust the font size as needed
        ),
        TextField(
          controller: quantityController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Adjust the radius as needed
              borderSide: const BorderSide(
                color: periwinkleColor, // Set the border color
                width: 4,
              ),
            ),
          ),
          // Additional properties for the TextField can be added here
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomActionButton(
              onPressed: () => showTestDialog(context),
              buttonText: 'Submit',
            ),
          ],
        )
      ],
    );
  }
}
