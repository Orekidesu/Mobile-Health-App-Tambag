// Import necessary libraries
// ignore_for_file: library_private_types_in_public_api, file_names, non_constant_identifier_names, unused_local_variable

import 'package:Tambag_Health_App/custom_widgets/Medication_info.dart';
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
  final TextEditingController quantityController = TextEditingController();

  String? selectedMedName;
  late String selectedMedInd = '';

  List<String> Tukma = [
    'Sa dili pa mukaon',
    'Human ug kaon',
  ];
  String? selectedTukma;

  List<MapEntry<String, String>> medicationDataList = [];
  late Map<String, String> medicationInfo;
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
          .where((doc) => !widget.medicationList.any(
              (addedMed) => addedMed['med_name'] == doc.data()['med_name']))
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
    String quantity,
    String frequency,
    String Tukma,
  ) async {
    try {
      int requestedQuantity = int.parse(quantity);
      if (requestedQuantity > 0) {
        // Get the available quantity from the medication inventory
        QuerySnapshot<Map<String, dynamic>> inventorySnapshot =
            await FirebaseFirestore.instance
                .collection('medication_inventory')
                .where('med_name', isEqualTo: medName)
                .limit(1)
                .get();

        int availableQuantity =
            inventorySnapshot.docs.first.data()['med_quan'] as int;
        DocumentReference docRef = inventorySnapshot.docs.first.reference;

        medicationInfo = MedicationInfoProvider.getMedicationInfo(medName);

        // Check if the requested quantity is greater than the available quantity
        if (requestedQuantity > availableQuantity) {
          showErrorNotification(
              'Requested quantity exceeds available quantity.');
          return;
        } else {
          if (int.parse(frequency) <= int.parse(quantity)) {
            Map<String, dynamic> medicationDetails = {
              'med_name': medName,
              'med_ind': medInd,
              'med_quan': int.parse(quantity),
              'dosage': '$dosage mg, tumaron ka-$frequency kada adlaw ',
              'frequency': int.parse(frequency),
              'reminder': medicationInfo['reminder'],
              'tukma': Tukma,
              // 'contraindication': medicationInfo['contraindication'],
              // 'diet': medicationInfo['diet'],
            };

            widget.addMedicationCallback(medicationDetails);

            showSuccessNotification('Medication added successfully.');

            frequencyController.clear();
            dosageController.clear();
            quantityController.clear();
          } else {
            showErrorNotification('Invalid input for quantity and frequency.');
          }
        }
      } else {
        showErrorNotification(
            'Invalid quantity. Please enter a valid quantity.');
      }
    } catch (error) {
      showErrorNotification('Error adding new Medication: $error');
    }
  }

  bool _validateInput() {
    return selectedMedName != null &&
        dosageController.text.isNotEmpty &&
        frequencyController.text.isNotEmpty &&
        quantityController.text.isNotEmpty &&
        selectedTukma != null;
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
                child: DropdownButton<String>(
                  value: selectedMedName,
                  onChanged: (String? value) {
                    setState(() {
                      selectedMedName = value ?? '';
                      selectedMedInd = getMedInd(value ?? '');
                    });
                  },
                  items: medicationDataList.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.key),
                    );
                  }).toList(),
                  hint: const Text('Select Medication'),
                  isExpanded: true,
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dosage:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: periwinkleColor,
                  ),
                ),
                SizedBox(
                  height: 45,
                  child: TextField(
                    controller: dosageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '(mg)',
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
              ],
            )),
            const SizedBox(width: 8.0),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Frequency:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: periwinkleColor,
                  ),
                ),
                SizedBox(
                  height: 45,
                  child: TextField(
                    controller: frequencyController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '(Per Day)',
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
              ],
            )),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quantity:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: periwinkleColor,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    child: TextField(
                      controller: quantityController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '', //
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: periwinkleColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tukma:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: periwinkleColor,
                    ),
                  ),
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
                    child: DropdownButton<String>(
                      value: selectedTukma,
                      onChanged: (String? value) {
                        setState(() {
                          selectedTukma = value ?? '';
                        });
                      },
                      items:
                          Tukma.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: const Text('Before or After meal'),
                      isExpanded: true,
                    ),
                  ),
                ],
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
                if (_validateInput()) {
                  addNewMedication(
                    selectedMedName!,
                    selectedMedInd,
                    dosageController.text,
                    quantityController.text,
                    frequencyController.text,
                    selectedTukma!,
                  );
                  Navigator.pop(context);
                } else {
                  // Show an error message if any field is empty
                  showErrorNotification('Please fill in all fields.');
                }
              },
              buttonText: 'Add',
            ),
          ],
        )
      ],
    );
  }
}
