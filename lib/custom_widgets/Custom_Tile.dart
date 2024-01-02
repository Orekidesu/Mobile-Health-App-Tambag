import 'package:flutter/material.dart';

class MedicationTile extends StatelessWidget {
  final String text;
  final String medicationName;

  const MedicationTile({
    Key? key,
    required this.medicationName,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        medicationName,
        style: const TextStyle(
          color: Color.fromARGB(255, 103, 103, 186),
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        text,
        style: const TextStyle(
          color: Color.fromARGB(255, 103, 103, 186),
        ),
      ),
    );
  }
}

class MedicationTileCenter extends StatelessWidget {
  final String text;
  final String Name;

  const MedicationTileCenter({
    Key? key,
    required this.Name,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Center(
        child: Text(
          Name,
          style: const TextStyle(
            color: Color.fromARGB(255, 103, 103, 186),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: Text(
        text,
        style: const TextStyle(
          color: Color.fromARGB(255, 103, 103, 186),
        ),
      ),
    );
  }
}
