// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class Custom_Button extends StatelessWidget {
  final Color? color;
  final Color? iconColor;
  final IconData? icon;
  final bool hasIcon;
  final String? text;
  final Color? textColor; // Change Color to Color?
  final VoidCallback? onTap;

  const Custom_Button({
    super.key,
    required this.onTap,
    this.color,
    this.iconColor,
    this.icon,
    required this.hasIcon,
    this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: hasIcon
          ? IconButton(
              icon: Icon(icon),
              color: iconColor,
              onPressed: onTap,
            )
          : Text(
              text!,
              style: TextStyle(
                color: textColor ?? Colors.black, // Use provided textColor or default to black
              ),
            ),
    );
  }
}
