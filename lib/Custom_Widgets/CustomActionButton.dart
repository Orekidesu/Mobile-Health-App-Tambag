import 'package:flutter/material.dart';
import '../constants/light_constants.dart';

class CustomActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color? foreground;
  final Color? background;
  final Color? borderColor;
  final double? borderWidth;
  final FontWeight? fontWeight;

  const CustomActionButton({
    Key? key,
    this.fontWeight,
    this.borderWidth,
    this.borderColor,
    this.foreground,
    this.background,
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
          backgroundColor: background ??periwinkleColor,
          foregroundColor: foreground ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: borderColor??periwinkleColor, width: borderWidth??0),
          ),
        ),
        child: Text(buttonText,
        style: TextStyle(
      fontWeight: fontWeight??FontWeight.normal,
    ),),
      ),
    );
  }
}