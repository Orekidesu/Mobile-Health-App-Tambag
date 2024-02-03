// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Custom_Widgets/Add_Medication_Dialog_Profile.dart';
import '../Custom_Widgets/CustomActionButton.dart';
import '../Custom_Widgets/Custom_Appbar.dart';
import '../Custom_Widgets/Custom_TextField.dart';
import '../Screen/Dashboard.dart';
import '../constants/light_constants.dart';
import '../functions/custom_functions.dart';

class EditProfilePage extends StatefulWidget {
  final String selectedBrgy;
  final String selectedPatient;
  const EditProfilePage(
      {super.key, required this.selectedBrgy, required this.selectedPatient});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
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
    getPatientNameById(widget.selectedPatient);
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    nameController.dispose();
    ageController.dispose();
    contactNumberController.dispose();
    physicianController.dispose();
    super.dispose();
  }

  final CollectionReference followUpCollection =
      FirebaseFirestore.instance.collection('follow_up_history');

  Future<void> updateProfileToFirebase(String patientId) async {
    try {
      if (_validateInput()) {
        setState(() {
          isAddingProfile = true;
        });

        // All fields are non-empty, proceed with updating the patient in Firebase
        CollectionReference patientsCollection =
            FirebaseFirestore.instance.collection('patients');
        QuerySnapshot querySnapshot =
            await patientsCollection.where('id', isEqualTo: patientId).get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
          DocumentReference profileReference = documentSnapshot.reference;

          await profileReference.update(getProfileData(patientId));

          // Clear existing medications and add updated ones to the subcollection
          CollectionReference medicationCollection =
              profileReference.collection('medications');
          await medicationCollection.get().then((snapshot) {
            for (QueryDocumentSnapshot doc in snapshot.docs) {
              doc.reference.delete();
            }
          });

          for (Map<String, dynamic> medicationDetails in medicationList) {
            await medicationCollection.add(medicationDetails);
            await updateMedicationInventory(medicationDetails);
          }

          showSuccessNotification('Successfully updated');

          setState(() {
            isAddingProfile = false;
          });
          // Optionally, you can navigate to another screen after successful update
          goToPage(context, const Dashboard());
        } else {
          showErrorNotification('Patient not found with ID: $patientId');
        }
      } else {
        // Show an error notification if there are empty fields
        showErrorNotification('Please fill in all fields.');
      }
    } catch (e) {
      showErrorNotification('Error updating profile in Firebase: $e');
      setState(() {
        isAddingProfile = false;
      });
    }
  }

  Future<void> updateMedicationInventory(
      Map<String, dynamic> medicationDetails) async {
    String medName = medicationDetails['med_name'];
    int requestedQuantity = medicationDetails['med_quan'];

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

    // Check if the requested quantity is greater thanS the available quantity
    await docRef.update({'med_quan': availableQuantity - requestedQuantity});
  }

  Map<String, dynamic> getProfileData(String id) {
    return {
      'age' : ageController.text,
      'contact_number': contactNumberController.text,
      'physician': physicianController.text,
      'id': id,
    };
  }

  Map<String, dynamic> newFolowup(String id) {
    return {
      'isDone': true,
      'id': id,
    };
  }

  Future<void> getPatientNameById(String patientId) async {
  try {
    CollectionReference patientsCollection = FirebaseFirestore.instance.collection('patients');
    QuerySnapshot querySnapshot = await patientsCollection.where('id', isEqualTo: patientId).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      
      // Assuming the name field is stored in the 'name' field in the document
      String name = data['name'] as String;
      
      nameController.text = name;
    } 
  } catch (e) {
    // Handle any errors that may occur during the process
    showErrorNotification('Error getting patient name: $e');
  }
}


  List<String> Brgy = ['Guadalupe', 'Patag', 'Gabas'];

  bool _validateInput() {
    // Check if any of the text fields are empty
    return 
        ageController.text.isNotEmpty &&
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
                hasBrgy: false,
                Baranggay: "Profile",
                Apptitle: "Update Profile",
                hasbackIcon: true,
                hasRightIcon: false,
                iconColor: Colors.white,
                DistinationBack: isAddingProfile
                    ? null
                    : () => goToPage(context, const Dashboard()),
              ),
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
                              height: 10,
                            ),
                            CustomTextField(
                              labelColor: Colors.grey,
                              readOnly: true,
                              controller: nameController,
                              labelText: 'Name:',
                            ),
                            CustomTextField(
                              controller: ageController,
                              labelText: 'Age:',
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
                                  child: const Text(
                                    'Add Medication',
                                    style: TextStyle(
                                      color:
                                          periwinkleColor, // Set the text color
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomActionButton(
                                  onPressed: () {
                                    updateProfileToFirebase(
                                        widget.selectedPatient);
                                  },
                                  buttonText:
                                      isAddingProfile ? 'Updating...' : 'Update',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
