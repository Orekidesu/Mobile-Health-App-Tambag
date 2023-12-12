// ignore_for_file: library_private_types_in_public_api, file_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/light_constants.dart';
import 'CustomActionButton.dart';
import 'Custom_Dialog.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({Key? key}) : super(key: key);

  @override
  _AddMedicationState createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  final TextEditingController medicationController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  bool newMedication = false;

  List<String> medicationNames = []; // List to store medication names
  String? selectedMedication; // Currently selected medication

  @override
  void initState() {
    super.initState();
    _getMedicationNames(); // Fetch medication names when the widget is initialized
  }

  Future<void> _getMedicationNames() async {
    try {
      // Query the Firestore collection to get all medication names
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('medication_inventory')
              .get();

      // Extract the medication names from the documents
      List<String> names = querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              doc.data()['med_name'] as String)
          .toList();

      // Update the state with the retrieved medication names
      setState(() {
        medicationNames = names;
      });
    } catch (error) {
      print('Error fetching medication names: $error');
    }
  }

  Future<void> updateMedicationInventory(String medName, int additionalMedQuan) async {
  try {
    // Reference to the medication_inventory collection
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('medication_inventory');

    // Query for documents with a specific med_name
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.where('med_name', isEqualTo: medName).get();

    // Iterate through the query results and update each document
    for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
      // Reference to the specific document
      DocumentReference<Map<String, dynamic>> documentReference =
          collectionReference.doc(documentSnapshot.id);

      // Get the existing med_quan value
      int existingMedQuan = documentSnapshot.data()['med_quan'] as int;

      // Calculate the new med_quan value by adding the existing value with the additional value
      int newMedQuan = existingMedQuan + additionalMedQuan;

      // Use the update method to update the med_quan field
      await documentReference.update({
        'med_quan': newMedQuan,
      });
    }

    print('Medication Inventory updated successfully.');
  } catch (error) {
    print('Error updating Medication Inventory: $error');
  }
}


  Future<void> addNewMedication(String medName, int medQuan) async {
    try {
      // Reference to the medication_inventory collection
      CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance.collection('medication_inventory');

      // Use the set method to add a new document with med_name and med_quan
      await collectionReference.add({
        'med_name': medName,
        'med_quan': medQuan,
      });

      print('New Medication added successfully.');
    } catch (error) {
      print('Error adding new Medication: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!newMedication)
          DropdownButton<String?>(
            value: selectedMedication,
            onChanged: (String? value) {
              setState(() {
                selectedMedication = value;
              });
            },
            items: medicationNames.map((String medName) {
              return DropdownMenuItem<String>(
                value: medName,
                child: Text(medName),
              );
            }).toList(),
            hint: const Text('Select Medication'),
          ),
        if (newMedication)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Medication:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: periwinkleColor,
                ), // Adjust the font size as needed
              ),
              TextField(
                controller: medicationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the radius as needed
                    borderSide: const BorderSide(
                      color: periwinkleColor, // Set the border color
                      width: 4,
                    ),
                  ),
                ),
                // Additional properties for the TextField can be added here
              ),
            ],
          ),
        Row(
          children: [
            Checkbox(
              value: newMedication,
              onChanged: (bool? value) {
                setState(() {
                  newMedication = value ?? false;
                });
              },
            ),
            const Text(
              'A new medication?',
              style: TextStyle(
                fontSize: 15,
                color: periwinkleColor,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Quantity:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: periwinkleColor,
          ), // Adjust the font size as needed
        ),
        TextField(
          controller: quantityController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
              borderSide: const BorderSide(
                color: periwinkleColor, // Set the border color
                width: 4,
              ),
            ),
          ),
          // Additional properties for the TextField can be added here
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomActionButton(
              onPressed: () {
                if (newMedication) {
                  addNewMedication(
                    medicationController.text,
                    int.tryParse(quantityController.text) ?? 0,
                  );
                } else {
                  updateMedicationInventory(
                    medicationController.text,
                    int.tryParse(quantityController.text) ?? 0,
                  );
                }
              },
              buttonText: 'Submit',
            ),
          ],
        )
      ],
    );
  }
}
