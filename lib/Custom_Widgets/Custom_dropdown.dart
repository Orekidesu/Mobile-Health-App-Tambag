import 'package:flutter/material.dart';
import '../constants/light_constants.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String value;
  final Function(String) onChanged;
  final bool isEnabled; // Add this property

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.isEnabled = true, // Default is enabled
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      width: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: periwinkleColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.all(10),
      child: DropdownButton<String>(
        value: widget.value,
        onChanged: widget.isEnabled
            ? (String? newValue) {
                if (newValue != null) {
                  widget.onChanged(newValue);
                }
              }
            : null, // Set onChanged to null if disabled
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14.0),
            ),
          );
        }).toList(),
        underline: Container(),
        icon: widget.isEnabled
            ? const Icon(Icons.arrow_drop_down)
            : null, // Set icon to null if disabled
        isExpanded: true,
      ),
    );
  }
}
