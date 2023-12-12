// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'package:flutter/material.dart';
import '../constants/light_constants.dart';
import 'Custom_ButtonRound.dart';

class Custom_Appbar extends StatefulWidget {
  final String Baranggay;
  final String Apptitle; 
  final Color? iconColor;
  final IconData? icon;
  final bool hasbackIcon;
  final bool hasRightIcon;
  final VoidCallback? Distination;
  final VoidCallback? DistinationBack;

  const Custom_Appbar({
    Key? key,
    required this.Apptitle,
    this.Distination,
    this.iconColor,
    this.DistinationBack,
    required this.Baranggay,
    this.icon,
    required this.hasbackIcon,
    required this.hasRightIcon,
  }) : super(key: key);

  @override
  State<Custom_Appbar> createState() => _Custom_AppbarState();
}

class _Custom_AppbarState extends State<Custom_Appbar> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.hasbackIcon) Custom_Button(hasIcon: true, icon: Icons.arrow_back, color: periwinkleColor,iconColor: widget.iconColor,onTap: widget.DistinationBack),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.Apptitle,
                style: const TextStyle(
                  color: periwinkleColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.Baranggay,
                style: const TextStyle(
                  color: periwinkleColor,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        if (widget.hasRightIcon) Custom_Button(hasIcon: true, icon: widget.icon, color: periwinkleColor,iconColor: widget.iconColor,onTap: widget.Distination),
        const SizedBox(width: 10),
      ],
    );
  }
}

