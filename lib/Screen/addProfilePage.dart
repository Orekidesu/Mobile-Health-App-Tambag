// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Custom_Widgets/Add_Medication_Dialog_Profile.dart';
import '../Custom_Widgets/CustomActionButton.dart';
import '../Custom_Widgets/Custom_Appbar.dart';
import '../Custom_Widgets/Custom_TextField.dart';
import '../Custom_Widgets/Custom_dropdown.dart';
import '../Screen/Dashboard.dart';
import '../constants/light_constants.dart';
import '../functions/custom_functions.dart';
import 'dart:math';

class AddProfilePage extends StatefulWidget {
  final String selectedBrgy;
  const AddProfilePage({super.key, required this.selectedBrgy});

  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController physicianController = TextEditingController();
  List<Map<String, dynamic>> medicationList = [];
  String highestIdValue = '';
  bool isAddingProfile = false;

  @override
  void initState() {
    super.initState();
  }

  final CollectionReference patientsCollection =
      FirebaseFirestore.instance.collection('patients');
  final CollectionReference followUpCollection =
      FirebaseFirestore.instance.collection('follow_up_history');

  Future<void> addProfileToFirebase() async {
    try {
      if (!isValidPhilippinePhoneNumber(contactNumberController.text)) {
        showErrorNotification(
            "Please enter a valid phone number starting with '09'");
        return;
      }

      if (_validateInput()) {
        setState(() {
          isAddingProfile = true;
        });

        // All fields are non-empty, proceed with adding to Firebase
        String id = generateRandomNumber().toString();
        DocumentReference profileReference =
            await patientsCollection.add(getProfileData(id));

        await followUpCollection.add(newFolowup(id));

        // Add medication data to the subcollection
        CollectionReference medicationCollection =
            profileReference.collection('medications');
        for (Map<String, dynamic> medicationDetails in medicationList) {
          await medicationCollection.add(medicationDetails);
        }

        // Update the medication inventory only when the patient addition is confirmed
        for (Map<String, dynamic> medicationDetails in medicationList) {
          await updateMedicationInventory(medicationDetails);
        }

        showSuccessNotification('Successfully added');

        setState(() {
          isAddingProfile = false;
        });
        // Navigate to the Dashboard after successful addition
        goToPage(context, const Dashboard());
      } else {
        // Show an error notification if there are empty fields
        showErrorNotification('Please fill in all fields.');
      }
    } catch (e) {
      showErrorNotification('Error adding profile to Firebase: $e');
      setState(() {
        isAddingProfile = false;
      });
    }
  }

  Future<void> updateMedicationInventory(
      Map<String, dynamic> medicationDetails) async {
    try {
      String medName = medicationDetails['med_name'];
      int requestedQuantity = medicationDetails['med_quan'];

      // Get the available quantity from the medication inventory
      QuerySnapshot<Map<String, dynamic>> inventorySnapshot =
          await FirebaseFirestore.instance
              .collection('medication_inventory')
              .where('med_name', isEqualTo: medName)
              .limit(1)
              .get();

      if (inventorySnapshot.docs.isNotEmpty) {
        int availableQuantity =
            inventorySnapshot.docs.first.data()['med_quan'] as int;
        DocumentReference docRef = inventorySnapshot.docs.first.reference;

        // Check if the requested quantity is greater than the available quantity
        await docRef
            .update({'med_quan': availableQuantity - requestedQuantity});
      } else {
        // Handle the case where the medication is not found in the inventory
        showErrorNotification('Medication not found in the inventory.');
        return;
      }
    } catch (e) {
      // Handle any potential exceptions or errors
      showErrorNotification('Error updating medication inventory: $e');
      // You can choose to rethrow the error or handle it gracefully based on your use case
      // throw e;
    }
  }

  int generateRandomNumber() {
    Random random = Random();
    return random.nextInt(900000) + 100000;
  }

  bool isValidPhilippinePhoneNumber(String phoneNumber) {
    // Remove any non-digit characters from the phone number
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Check if the cleaned number has the correct length and starts with a valid prefix
    if (cleanedNumber.length == 11 && (cleanedNumber.startsWith('09'))) {
      return true;
    } else {
      return false;
    }
  }

  Map<String, dynamic> getProfileData(String id) {
    return {
      'name': nameController.text,
      'age': ageController.text,
      'address': widget.selectedBrgy,
      'contact_number': contactNumberController.text,
      'physician': physicianController.text,
      'id': id,
      'addedDate':
          DateTime.now().toString(), // or use the appropriate date format
    };
  }

  Map<String, dynamic> newFolowup(String id) {
    return {
      'isDone': true,
      'id': id,
    };
  }

  List<String> Brgy = ['Guadalupe', 'Patag', 'Gabas'];

  bool _validateInput() {
    // Check if any of the text fields are empty
    return nameController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        widget.selectedBrgy.isNotEmpty &&
        contactNumberController.text.isNotEmpty &&
        physicianController.text.isNotEmpty &&
        medicationList.isNotEmpty;
  }

  void _showMyDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(width: 2, color: periwinkleColor),
          ),
          scrollable: true,
          backgroundColor: backgroundColor,
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     IconButton(
              //       onPressed: () {
              //         Navigator.of(context).pop();
              //       },
              //       icon: const Icon(
              //         Icons.close,
              //         color: Colors.white,
              //       ),
              //       style: ButtonStyle(
              //         backgroundColor:
              //             MaterialStateProperty.all(periwinkleColor),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 10),
              AddMedicationProfile(
                medicationList: medicationList,
                addMedicationCallback:
                    (Map<String, dynamic> medicationDetails) {
                  // Callback function to update medicationList in File 2
                  setState(() {
                    medicationList.add(medicationDetails);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height, // Adjust as needed
          color: backgroundColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Custom_Appbar(
                titleFontSize: 21,
                hasBrgy: true,
                Baranggay: "Add Profile",
                Apptitle: "Patient",
                hasbackIcon: true,
                hasRightIcon: false,
                iconColor: Colors.white,
                DistinationBack: isAddingProfile
                    ? null
                    : () => goToPage(context, const Dashboard()),
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextField(
                              controller: nameController,
                              labelText: 'Name:',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                              controller: ageController,
                              labelText: 'Age:',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Baranggay:',
                                  style: TextStyle(
                                    color: periwinkleColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign
                                      .left, // Set the text alignment to left
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: CustomDropdown(
                                      isEnabled: false,
                                      items: Brgy,
                                      value: widget.selectedBrgy,
                                      onChanged: (String newValue) {},
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Medication:',
                                  style: TextStyle(
                                    color: periwinkleColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color:
                                          periwinkleColor, // Set the border color
                                      width: 2.0, // Set the border width
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        12.0), // Set the border radius
                                  ),
                                  child: SizedBox(
                                    height:
                                        150.0, // Set a specific height for the container
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: ListView.builder(
                                        itemCount: medicationList.length,
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic>
                                              medicationDetails =
                                              medicationList[index];
                                          return ListTile(
                                            title: Text(
                                              medicationDetails['med_name'] ??
                                                  '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: periwinkleColor,
                                              ),
                                            ),
                                            subtitle: Text(
                                              '${medicationDetails['dosage'] ?? ''}',
                                              style: const TextStyle(
                                                fontSize:
                                                    13, // Adjust the font size as needed
                                                color: periwinkleColor,
                                              ),
                                            ),
                                            // You can customize the ListTile further if needed
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showMyDialog(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                    color: periwinkleColor, // Change to your desired color
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white, // Set the color of the icon)
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                              controller: contactNumberController,
                              labelText: 'Contact Number:',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                              controller: physicianController,
                              labelText: 'Physician:',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomActionButton(
                    custom_width: 320,
                    onPressed: () {
                      addProfileToFirebase();
                    },
                    buttonText: isAddingProfile ? 'Adding...' : 'Add',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
