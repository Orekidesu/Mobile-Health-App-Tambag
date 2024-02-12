import 'package:flutter/material.dart';

class MyIconButtonWithDropdown extends StatelessWidget {
  const MyIconButtonWithDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.arrow_drop_down),
      onSelected: (String value) {
        // Handle menu item selection
        print('Selected: $value');
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'Option 1',
            child: Row(
              children: [
                Icon(Icons.star),
                SizedBox(width: 8),
                Text('Option 1'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'Option 2',
            child: Row(
              children: [
                Icon(Icons.star),
                SizedBox(width: 8),
                Text('Option 2'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'Option 3',
            child: Row(
              children: [
                Icon(Icons.star),
                SizedBox(width: 8),
                Text('Option 3'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'Option 4',
            child: Row(
              children: [
                Icon(Icons.star),
                SizedBox(width: 8),
                Text('Option 4'),
              ],
            ),
          ),
        ];
      },
    );
  }
}