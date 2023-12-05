import 'package:flutter/material.dart';
import '../constants/light_constants.dart';

class CustomActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const CustomActionButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 150,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(150, 30),
          backgroundColor: periwinkleColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(color: Colors.blue, width: 0),
          ),
        ),
        child: Text(buttonText.toUpperCase()),
      ),
    );
  }
}