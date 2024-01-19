import 'package:flutter/material.dart';
import '../constants/light_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final double labelFontSize;
  final double textFieldHeight;
  final double borderRadius;
  final bool obscureText;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.labelFontSize = 17.0,
    this.textFieldHeight = 5.0,
    this.borderRadius = 15.0,
    this.obscureText = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: periwinkleColor,
            fontSize: labelFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: textFieldHeight,
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(
                color: periwinkleColor,
                width: 4,
              ),
            ),
            contentPadding: const EdgeInsets.all(
              15
            ),
          ),
          // Additional properties for the TextField can be added here
        ),

      ],
    );
  }
}
