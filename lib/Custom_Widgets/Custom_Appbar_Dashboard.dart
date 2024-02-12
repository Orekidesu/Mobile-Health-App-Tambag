// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_typing_uninitialized_variables, file_names
import 'package:flutter/material.dart';
import '../Screen/SmsSender.dart';
import '../constants/light_constants.dart';
import '../functions/custom_functions.dart';
import 'Custom_ButtonRound.dart';

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
  final VoidCallback? MessagePage;
  final bool hasBrgy;
  final double titleFontSize;
  final String selectedBrgy;

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
    this.MessagePage,
    this.selectedBrgy = '',
  });

  @override
  State<Custom_Appbar> createState() => _Custom_AppbarState();
}

class _Custom_AppbarState extends State<Custom_Appbar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.hasbackIcon)
          Custom_Button(
              hasIcon: true,
              icon: Icons.arrow_back,
              color: periwinkleColor,
              iconColor: widget.iconColor,
              onTap: widget.DistinationBack),
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
              if (widget.hasBrgy)
                Text(
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
        Builder(
          builder: (BuildContext context) {
            return PopupMenuButton<String>(
              onSelected: (value) {
                // You can add specific actions for each item here
                if (value == 'Announcement') {
                  print(widget.selectedBrgy);
                  goToPage(context, smsSender(selectedBrgy: widget.selectedBrgy));
                } else if (value == 'Reminder') {
                  // Handle Patient Reminder click
                  // Add your code here
                } else if (value == 'Signout') {
                  showSignOutDialog(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Announcement',
                    child: Text('Announcement', style: TextStyle(color: periwinkleColor, fontWeight: FontWeight.w400)),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Reminder',
                    child: Text('Reminder',style: TextStyle(color: periwinkleColor, fontWeight: FontWeight.w400)),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Signout',
                    child: Text('Signout',style: TextStyle(color: periwinkleColor, fontWeight: FontWeight.w400)),
                  ),
                ];
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: periwinkleColor, // Set your desired background color
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.all(8.0), // Adjust padding as needed
                  child:
                      Icon(Icons.menu, color: Colors.white), // Set icon color
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
