// ignore_for_file: library_private_types_in_public_api, file_names, camel_case_types, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants/light_constants.dart';
import '../functions/custom_functions.dart';
import 'CustomActionButton.dart';
import '../Screen/Masterlist.dart';

class AddMedication extends StatefulWidget {
  const AddMedication({super.key});

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
      showErrorNotification('Error fetching medication names: $error');
    }
  }

  Future<void> updateMedicationInventory(String medName, int newMedQuan) async {
    try {
      // Reference to the medication_inventory collection
      CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance.collection('medication_inventory');

      // Query for documents with a specific med_name
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collectionReference.where('med_name', isEqualTo: medName).get();

      // Check if there are documents with the specified med_name
      if (querySnapshot.docs.isNotEmpty) {
        // Iterate through the query results and update each document
        for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
            in querySnapshot.docs) {
          // Reference to the specific document
          DocumentReference<Map<String, dynamic>> documentReference =
              collectionReference.doc(documentSnapshot.id);

          // Use the update method to set the med_quan field to the new value
          await documentReference.update({
            'med_quan': newMedQuan,
          });
        }

        showSuccessNotification('Medication Inventory updated successfully.');
        goToPage(context, const Masterlist());
      } else {
        // If there are no documents with the specified med_name, handle accordingly
        showErrorNotification('No medication found with the specified name.');
        goToPage(context, const Masterlist());
      }
    } catch (error) {
      // Show error notification
      showErrorNotification('Error updating Medication Inventory: $error');
      goToPage(context, const Masterlist());
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

      showSuccessNotification('New Medication added successfully.');
      goToPage(context, const Masterlist());
    } catch (error) {
      showErrorNotification('Error adding new Medication: $error');
      goToPage(context, const Masterlist());
    }
  }

  bool _validateInput() {
    if (newMedication) {
      return medicationController.text.isNotEmpty &&
          quantityController.text.isNotEmpty;
    } else {
      return selectedMedication != null && quantityController.text.isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          newMedication ? 'Add Medication' : 'Update Medication',
          style: const TextStyle(
            color: periwinkleColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        if (!newMedication)
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: periwinkleColor, // Set your desired border color
                      width: 2.0, // Set your desired border width
                    ),
                  ),
                  child: DropdownButton<String?>(
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
                ),
              ),
            ],
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
              SizedBox(
                height: 45,
                child: TextField(
                  controller: medicationController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
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
        SizedBox(
          height: 45,
          child: TextField(
            controller: quantityController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the radius as needed
                borderSide: const BorderSide(
                  color: periwinkleColor, // Set the border color
                  width: 4,
                ),
              ),
            ),
            // Additional properties for the TextField can be added here
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomActionButton(
              onPressed: () {
                if (_validateInput()) {
                  if (newMedication) {
                    addNewMedication(
                      medicationController.text,
                      int.tryParse(quantityController.text) ?? 0,
                    );
                  } else {
                    updateMedicationInventory(
                      selectedMedication!,
                      int.tryParse(quantityController.text) ?? 0,
                    );
                  }
                } else {
                  // Show an error message if any field is empty
                  showErrorNotification('Please fill in all fields.');
                }
              },
              buttonText: newMedication ? 'Add' : 'Update',
            ),
          ],
        )
      ],
    );
  }
}
