// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import '../Custom_Widgets/CustomActionButton.dart';
import '../Custom_Widgets/Custom_TextField.dart';
import '../functions/custom_functions.dart';
import '../Custom_Widgets/Custom_dropdown.dart';
import 'Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/light_constants.dart';
import '../Custom_Widgets/Custom_Appbar.dart';
import '../Custom_Widgets/Followup_widget.dart';

class FollowUpData {
  final String physician;
  final String facility;
  final String day;
  final String year;
  final String month;
  final bool isDone;

  FollowUpData(
      {required this.physician,
      required this.facility,
      required this.day,
      required this.month,
      required this.year,
      required this.isDone});
}

// ignore: camel_case_types
class Follow_up extends StatefulWidget {
  final String patientId;

  const Follow_up({
    super.key,
    required this.patientId, // Corrected the parameter name
  });

  @override
  State<Follow_up> createState() => _Follow_upState();
}

// ignore: camel_case_types
class _Follow_upState extends State<Follow_up> {
  // Create a TextEditingController
  TextEditingController physicianController = TextEditingController();
  TextEditingController facilityController = TextEditingController();

  String selectedMonth = 'Enero';
  String selectedDay = '1';
  String selectedYear = '2023';
  String selectedTime = 'alas-otso sa buntag';

  // Function to submit follow-up data to Firestore
  Future<void> submitFollowUpData() async {
    try {
      // Check if a document with the provided patientId exists
      final QuerySnapshot querySnapshot = await patientsCollection
          .where("id", isEqualTo: widget.patientId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot doc = querySnapshot.docs.first;

        // Update the existing document with the new data
        await doc.reference.update({
          'physician': physicianController.text,
          'facility': facilityController.text,
          'day': selectedDay,
          'month': selectedMonth,
          'year': selectedYear,
          'time': selectedTime,
          'isDone': false, // Assuming the follow-up is not done initially
        });

        // Refresh the UI by loading the updated data
        loadFollowUpData();

        // Optional: Show a success message or navigate to another screen
        showSuccessSnackbar();
      } else {
        // Handle the case where no document with the given patientId is found
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      showFailedSnackbar();
    }
  }

  // Function to submit follow-up data to Firestore
  Future<void> markAsDone() async {
    try {
      // Check if a document with the provided patientId exists
      final QuerySnapshot querySnapshot = await patientsCollection
          .where("id", isEqualTo: widget.patientId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot doc = querySnapshot.docs.first;

        // Update the existing document to mark it as done
        await doc.reference.update({
          'isDone': true,
        });

        // Refresh the UI by loading the updated data
        loadFollowUpData();

        // Optional: Show a success message or navigate to another screen
        showSuccessMarkDoneSnackbar();
      } else {
        // Handle the case where no document with the given patientId is found
      }
    } catch (e) {
      // Handle errors, e.g., show an error message
      showFailedSnackbar();
    }
  }

  List<String> Month = [
    'Enero',
    'Pebrero',
    'Marso',
    'Abril',
    'Mayo',
    'Hunyo',
    'Hulyo',
    'Agosto',
    'Setyembre',
    'Oktubre',
    'Nobyembre',
    'Disyembre',
  ];

  List<String> Time = [
    'alas-otso sa buntag',
    'alas-dyis sa buntag',
    'alas-unsi sa buntag',
    'alas-dose sa buntag',
    'ala-una sa buntag',
    'alas-dos sa hapon',
    'alas-tres sa hapon',
    'alas-kwatro sa hapon',
    'alas-singko sa hapon',
  ];

  Map<String, dynamic> followUpData = {};

  late CollectionReference patientsCollection;
  //Function to return all patients
  Future<Map<String, dynamic>?> getAllPatientsWithId() async {
    try {
      final QuerySnapshot querySnapshot = await patientsCollection
          .where("id", isEqualTo: widget.patientId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document with the given ID
        final DocumentSnapshot doc = querySnapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;

        // Check if the "id" field matches the patientId
        if (data.containsKey("id") && data["id"] == widget.patientId) {
          return data;
        } else {
          return null; // or handle the case where the ID doesn't match
        }
      } else {
        return null; // or handle the case where there is no document with the given ID
      }
    } catch (e) {
      return null;
    }
  }

  void showFailedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Error submitting follow-up data'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating, // Make the SnackBar taller
        shape: RoundedRectangleBorder(
          // Customize the shape
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  void showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Follow-up data submitted successfully'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating, // Make the SnackBar taller
        shape: RoundedRectangleBorder(
          // Customize the shape
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  void showSuccessMarkDoneSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Successfully Marked Done'),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating, // Make the SnackBar taller
        shape: RoundedRectangleBorder(
          // Customize the shape
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

// Function to load follow-up data
  Future<void> loadFollowUpData() async {
    try {
      final data = await getAllPatientsWithId();
      setState(() {
        followUpData = data!;
      });
    } catch (e) {
      print('Error loading follow-up data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the function when the widget is initialized
    patientsCollection =
        FirebaseFirestore.instance.collection('follow_up_history');
    loadFollowUpData();
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
                Baranggay: "Baranggay Guadalupe",
                Apptitle: "TAMBAG",
                hasbackIcon: true,
                hasRightIcon: false,
                iconColor: Colors.white,
                DistinationBack: () => goToPage(context, const Dashboard()),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                periwinkleColor, // Set the border color to black
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                          color: Colors.white,
                        ),
                        // Check if isDone is true before displaying the content
                        child: followUpData['isDone'] == false
                            ? Column(
                                children: [
                                  FollowUpWidget(followUpData: followUpData),
                                  const SizedBox(height: 20.0),
                                  Center(
                                    child: CustomActionButton(
                                      onPressed: () {
                                        markAsDone();
                                      },
                                      buttonText: "Mark as Done",
                                    ),
                                  ),
                                ],
                              )
                            : const Center(
                                child: Text("No Appointment Available"),
                              ), // If isDone is false, display an empty container
                      ),
                    ),
                    Container(
                        child: followUpData['isDone'] == true
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10.0),
                                    const Text(
                                      'Add a Follow-up',
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          color: periwinkleColor,
                                          fontWeight: FontWeight
                                              .bold), // Adjust the font size as needed
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    CustomTextField(
                                      controller: physicianController,
                                      labelText: 'Physician:',
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CustomTextField(
                                      controller: facilityController,
                                      labelText: 'Facility:',
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      'Date:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color:
                                              periwinkleColor), // Adjust the font size as needed
                                    ),
                                    Row(
                                      children: [
                                        // Month Dropdown
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: CustomDropdown(
                                                items: Month,
                                                value: selectedMonth,
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    selectedMonth = newValue;
                                                  });
                                                },
                                              ),
                                            )),
                                        const SizedBox(width: 10),

                                        // Day Dropdown
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: CustomDropdown(
                                                items: List<String>.generate(
                                                    31,
                                                    (index) =>
                                                        (index + 1).toString()),
                                                value: selectedDay,
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    selectedDay = newValue;
                                                  });
                                                },
                                              ),
                                            )),
                                        const SizedBox(width: 10),
                                        // Year Dropdown
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: CustomDropdown(
                                              items: List<String>.generate(
                                                  10,
                                                  (index) => (2023 - index)
                                                      .toString()),
                                              value: selectedYear,
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  selectedYear = newValue;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      'Time:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color:
                                              periwinkleColor), // Adjust the font size as needed
                                    ),
                                    Row(
                                      children: [
                                        // Hour Dropdown
                                        Expanded(
                                            child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: CustomDropdown(
                                            items: Time,
                                            value: selectedTime,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                selectedTime = newValue;
                                              });
                                            },
                                          ),
                                        )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        CustomActionButton(
                                            onPressed: () {
                                              submitFollowUpData();
                                            },
                                            buttonText: "Submit",
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : const Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("There's a Ongoing Appointment")
                                  ],
                                ),
                              ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
