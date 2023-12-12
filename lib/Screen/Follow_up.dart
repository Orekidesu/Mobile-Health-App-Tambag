// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import '../Custom_Widgets/CustomActionButton.dart';
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
    Key? key,
    required this.patientId, // Corrected the parameter name
  }) : super(key: key);

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
      await patientsCollection.doc(widget.patientId).set({
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
    } catch (e) {
      // Handle errors, e.g., show an error message
      showFailedSnackbar();
    }
  }

  // Function to submit follow-up data to Firestore
  Future<void> MarkAsDone() async {
    try {
      await patientsCollection.doc(widget.patientId).set({
        'isDone': true, // Assuming the follow-up is not done initially
      });

      // Refresh the UI by loading the updated data
      loadFollowUpData();

      // Optional: Show a success message or navigate to another screen
      showSuccessMarkDoneSnackbar();
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
  Future<Map<String, dynamic>> getAllFollowUp() async {
    try {
      final docRef = patientsCollection.doc(widget.patientId);
      final DocumentSnapshot doc = await docRef.get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data;
      } else {
        return {}; // or throw an exception based on your error handling strategy
      }
    } catch (e) {
      return {}; // or throw an exception based on your error handling strategy
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
      final data = await getAllFollowUp();
      setState(() {
        followUpData = data;
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
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: periwinkleColor, // Set the border color to black
                  width: 2.0,
                ),
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the radius as needed
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
                              MarkAsDone();
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
                            const SizedBox(height: 8,),
                            const Text(
                              'Physician:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color:
                                      periwinkleColor), // Adjust the font size as needed
                            ),
                            TextField(
                              controller: physicianController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust the radius as needed
                                  borderSide: const BorderSide(
                                    color:
                                        periwinkleColor, // Set the border color
                                    width: 4,
                                  ),
                                ),
                              ),
                              // Additional properties for the TextField can be added here
                            ),
                            const SizedBox(height: 15,),
                            const Text(
                              'Facility:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color:
                                      periwinkleColor), // Adjust the font size as needed
                            ),
                            TextField(
                              controller: facilityController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust the radius as needed
                                  borderSide: const BorderSide(
                                    color:
                                        periwinkleColor, // Set the border color
                                    width: 4,
                                  ),
                                ),
                              ),
                              // Additional properties for the TextField can be added here
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'Date:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color:
                                      periwinkleColor), // Adjust the font size as needed
                            ),
                            Row(
                              children: [
                                // Month Dropdown
                                Expanded(
                                    flex: 2,
                                    child: CustomDropdown(
                                      items: Month,
                                      value: selectedMonth,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          selectedMonth = newValue;
                                        });
                                      },
                                    )),
                                const SizedBox(width: 10),

                                // Day Dropdown
                                Expanded(
                                  flex: 1,
                                  child: CustomDropdown(
                                    items: List<String>.generate(
                                        31, (index) => (index + 1).toString()),
                                    value: selectedDay,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        selectedDay = newValue;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Year Dropdown
                                Expanded(
                                  flex: 1,
                                  child: CustomDropdown(
                                    items: List<String>.generate(10,
                                        (index) => (2023 - index).toString()),
                                    value: selectedYear,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        selectedYear = newValue;
                                      });
                                    },
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
                                  fontSize: 16.0,
                                  color:
                                      periwinkleColor), // Adjust the font size as needed
                            ),
                            Row(
                              children: [
                                // Hour Dropdown
                                Expanded(
                                  child: CustomDropdown(
                                    items: Time,
                                    value: selectedTime,
                                    onChanged: (String newValue) {
                                      setState(() {
                                        selectedTime = newValue;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: 
                              CustomActionButton(
                            onPressed: () {
                              submitFollowUpData();
                            },
                            buttonText: "Submit",
                          ),
                            ),
                          ],
                        ),
                      )
                    : const Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text("There's a Ongoing Appointment")],
                        ),
                      ))
          ],
        ),
      ),
    );
  }
}
