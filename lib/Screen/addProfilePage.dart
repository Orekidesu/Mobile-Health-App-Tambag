// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../Custom_Widgets/Add_Medication_Dialog_Profile.dart';
import '../Custom_Widgets/Custom_Appbar.dart';
import '../Custom_Widgets/Custom_TextField.dart';
import '../Screen/Dashboard.dart';
import '../constants/light_constants.dart';
import '../functions/custom_functions.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({Key? key}) : super(key: key);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(periwinkleColor),
                    ),
                  ),
                ],
              ),
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
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Custom_Appbar(
              titleFontSize: 25,
              hasBrgy: false,
              Baranggay: "Profile",
              Apptitle: "Add Profile",
              hasbackIcon: true,
              hasRightIcon: false,
              iconColor: Colors.white,
              DistinationBack: () => goToPage(context, const Dashboard()),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
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
                  CustomTextField(
                    controller: addressController,
                    labelText: 'Address:',
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: periwinkleColor, // Set the border color
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
                                Map<String, dynamic> medicationDetails =
                                    medicationList[index];
                                return ListTile(
                                  title: Text(
                                    medicationDetails['med_name'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: periwinkleColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Dosage: ${medicationDetails['dosage'] ?? ''} mg usa kada tablets kada ${medicationDetails['frequency'] ?? ''} ka-oras\n${medicationDetails['med_ind'] ?? ''}',
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
                        child: const Text(
                          'Add Medication',
                          style: TextStyle(
                            color: periwinkleColor, // Set the text color
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
