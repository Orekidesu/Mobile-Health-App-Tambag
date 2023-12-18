// Import necessary libraries
// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants/light_constants.dart';
import '../functions/custom_functions.dart';
import 'CustomActionButton.dart';

// Add callback typedef
typedef AddMedicationCallback = void Function(
    Map<String, dynamic> medicationDetails);

class AddMedicationProfile extends StatefulWidget {
  final List<Map<String, dynamic>> medicationList;
  final AddMedicationCallback addMedicationCallback;

  const AddMedicationProfile({
    super.key,
    required this.medicationList,
    required this.addMedicationCallback,
  });

  @override
  _AddMedicationProfileState createState() => _AddMedicationProfileState();
}

class _AddMedicationProfileState extends State<AddMedicationProfile> {
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  String? selectedMedName;
  late String selectedMedInd = '';

  List<MapEntry<String, String>> medicationDataList = [];

  @override
  void initState() {
    super.initState();
    _getMedicationData();
  }

  Future<void> _getMedicationData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('medication_inventory')
              .get();

      List<MapEntry<String, String>> medicationData = querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        return MapEntry(
          doc.data()['med_name'] as String,
          doc.data()['med_ind'] as String,
        );
      }).toList();

      setState(() {
        medicationDataList = medicationData;
      });
    } catch (error) {
      showErrorNotification('Error fetching medication data: $error');
    }
  }

  String getMedInd(String medName) {
    for (var entry in medicationDataList) {
      if (entry.key == medName) {
        return entry.value;
      }
    }
    return '';
  }

  Future<void> addNewMedication(
    String medName,
    String medInd,
    String dosage,
    String frequency,
  ) async {
    try {
      Map<String, dynamic> medicationDetails = {
        'med_name': medName,
        'med_ind': medInd,
        'med_quan': int.parse(dosage),
        'dosage':'$dosage mg usa kada tablets kada $frequency ka-oras\n$medInd',
      };

      // Call the callback function to update medicationList in File 2
      widget.addMedicationCallback(medicationDetails);

      showSuccessNotification('Medication added successfully.');

      frequencyController.clear();
      dosageController.clear();
    } catch (error) {
      showErrorNotification('Error adding new Medication: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medication:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: periwinkleColor,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: 
              Container(
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
                child: 
                DropdownButton<String>(
                  value: selectedMedName,
                  onChanged: (String? value) {
                    setState(() {
                      selectedMedName = value ?? '';
                      selectedMedInd = getMedInd(value ?? '');
                    });
                  },
                  items:
                      medicationDataList.map((MapEntry<String, String> entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.key),
                    );
                  }).toList(),
                  hint: const Text('Select Medication'),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Dosage and Frequency:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: periwinkleColor,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 45,
                child: TextField(
                  controller: dosageController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: periwinkleColor,
                        width: 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: SizedBox(
                height: 45,
                child: TextField(
                  controller: frequencyController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: periwinkleColor,
                        width: 4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          'Indication:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: periwinkleColor,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: 100,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(
                    color: periwinkleColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(selectedMedInd),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomActionButton(
              onPressed: () {
                if (selectedMedName != null) {
                  addNewMedication(
                    selectedMedName!,
                    selectedMedInd,
                    dosageController.text,
                    frequencyController.text,
                  );
                } else {
                  // Handle the case where selectedMedName is null, e.g., show an error message.
                }
                Navigator.pop(context);
              },
              buttonText: 'Add',
            ),
          ],
        )
      ],
    );
  }
}
