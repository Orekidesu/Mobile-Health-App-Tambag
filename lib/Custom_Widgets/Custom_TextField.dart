// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import '../constants/light_constants.dart';

class CustomTextField extends StatefulWidget {
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
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            color: periwinkleColor,
            fontSize: widget.labelFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: widget.textFieldHeight,
        ),
        TextField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: const BorderSide(
                color: periwinkleColor,
                width: 4,
              ),
            ),
            contentPadding: const EdgeInsets.all(15),
          ),
          // Additional properties for the TextField can be added here
        ),
      ],
    );
  }
}
