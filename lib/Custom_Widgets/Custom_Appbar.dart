// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'package:Tambag_Health_App/functions/custom_functions.dart';
import 'package:flutter/material.dart';
import '../constants/light_constants.dart';
import 'Custom_ButtonRound.dart';
import '../Screen/SmsSender.dart';

class Custom_Appbar extends StatefulWidget {
  final String Baranggay;
  final String Apptitle; 
  final Color? iconColor;
  final IconData? icon;
  final bool hasbackIcon;
  final bool hasRightIcon;
  final bool? hasMessageIcon;
  final VoidCallback? Distination;
  final VoidCallback? DistinationBack;
  final bool hasBrgy;
  final double titleFontSize;

  const Custom_Appbar({
    super.key,
    this.titleFontSize = 20,
    this.hasBrgy = true,
    required this.Apptitle,
    this.Distination,
    this.iconColor,
    this.DistinationBack,
    required this.Baranggay,
    this.icon,
    required this.hasbackIcon,
    required this.hasRightIcon,
    this.hasMessageIcon = false,
  });

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
                style: TextStyle(
                  color: periwinkleColor,
                  fontSize: widget.titleFontSize,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              if (widget.hasBrgy) Text(
                widget.Baranggay,
                style: const TextStyle(
                  color: periwinkleColor,
                  fontSize: 15.0,
                  decoration: TextDecoration.none,  
                ),
              ),
            ],
          ),
        ),
        if (widget.hasMessageIcon!) Custom_Button(hasIcon: true, icon: Icons.message, color: periwinkleColor,iconColor: widget.iconColor,onTap: (()=>goToPage(context, const smsSender()))),
        const SizedBox(width: 10),
        if (widget.hasRightIcon) Custom_Button(hasIcon: true, icon: widget.icon, color: periwinkleColor,iconColor: widget.iconColor,onTap: widget.Distination),
        const SizedBox(width: 10),
      ],
    );
  }
}

