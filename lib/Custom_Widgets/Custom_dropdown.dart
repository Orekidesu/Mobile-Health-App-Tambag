import 'package:flutter/material.dart';
import 'package:mobile_health_app_tambag/constants/light_constants.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String value;
  final Function(String) onChanged;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: periwinkleColor,
          width: 2.0, // Set the desired border thickness
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(10),
      child: DropdownButton<String>(
        value: widget.value,
        onChanged: (String? newValue) {
          if (newValue != null) {
            widget.onChanged(newValue);
          }
        },
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
        icon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}
