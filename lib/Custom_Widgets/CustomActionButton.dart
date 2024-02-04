import 'package:flutter/material.dart';
import '../constants/light_constants.dart';

class CustomActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final Color? foreground;
  final Color? background;
  final Color? borderColor;
  final double? borderWidth;
  final FontWeight? fontWeight;
  final double? custom_width;
  final double? custom_height;

  const CustomActionButton({
    super.key,
    this.fontWeight,
    this.borderWidth,
    this.borderColor,
    this.foreground,
    this.background,
    this.custom_width,
    this.custom_height,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: custom_height ?? 50,
      width: custom_width ?? 150,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(150, 30),
          backgroundColor: background ?? periwinkleColor,
          foregroundColor: foreground ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
                color: borderColor ?? periwinkleColor, width: borderWidth ?? 0),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
