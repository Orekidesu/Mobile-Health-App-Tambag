import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text1;
  final String text2;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? fontColor;

  static const nav_font_size = 20.0;
  static const Ucase_font_size = 16.0;
  static const Color periwinkleColor = Color.fromARGB(255, 103, 103, 186);

  const CustomTextWidget(
      {super.key,
      required this.text1,
      required this.text2,
      this.fontSize,
      this.fontWeight,
      this.fontColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$text1 ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: periwinkleColor ?? fontColor,
                fontSize: fontSize ?? Ucase_font_size,
              ),
            ),
            TextSpan(
              text: text2,
              style: TextStyle(
                fontWeight: fontWeight ?? FontWeight.normal,
                letterSpacing: 2.0,
                color: periwinkleColor ?? fontColor,
                fontSize: fontSize ?? Ucase_font_size,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
