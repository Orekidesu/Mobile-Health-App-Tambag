import 'package:flutter/material.dart';
import 'Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  // Constants Color
  static const Color backgroundColor = Color.fromRGBO(245, 248, 255, 1.0);
  static const Color periwinkleColor = Color.fromARGB(255, 103, 103, 186);
  static const Color rose = Color.fromRGBO(230, 192, 201, 1.0);
  static const Color lightyellow = Color.fromRGBO(255, 229, 167, 1.0);
  static const Color lightblue = Color.fromRGBO(167, 215, 246, 1.0);
  static const LinearGradient periwinkleGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 103, 103, 186),
      Color.fromARGB(255, 103, 103, 186)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    gradient: periwinkleGradient,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      // Navigate to the login page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const Dashboard(), // Replace with your login page widget
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TAMBAG',
                        style: TextStyle(
                          color: periwinkleColor,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Baranggay Guadalupe',
                        style: TextStyle(
                          color: periwinkleColor,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.info,
                              size: 40.0,
                              color: periwinkleColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      const TextSpan(
                                        text: 'Mo follow-up kang ',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: periwinkleColor,
                                            fontWeight: FontWeight
                                                .w100), // Font size for the first part
                                      ),
                                      TextSpan(
                                        text:
                                            '${followUpData['physician'] ?? 'N/A'} ',
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            color: periwinkleColor,
                                            fontWeight: FontWeight
                                                .bold), // Font size for the first part
                                      ),
                                      const TextSpan(
                                        text: 'sa',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: periwinkleColor,
                                            fontWeight: FontWeight
                                                .w100), // Font size for the first part
                                      ),
                                      TextSpan(
                                        text:
                                            ' ${followUpData['facility'] ?? 'N/A '} ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color: periwinkleColor),
                                      ),
                                      const TextSpan(
                                        text: 'sa ',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: periwinkleColor,
                                            fontWeight: FontWeight
                                                .w100), // Font size for the first part
                                      ),
                                      const TextSpan(
                                        text: 'umaabot nga ',
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: periwinkleColor,
                                            fontWeight: FontWeight
                                                .w100), // Font size for the first part
                                      ),
                                      TextSpan(
                                        text:
                                            'ika-${followUpData['day'] ?? 'N/A'} sa ${followUpData['month'] ?? 'N/A'} ${followUpData['year'] ?? 'N/A'}, alas-otso sa buntag',
                                        style: const TextStyle(
                                            fontSize: 15.0,
                                            color: periwinkleColor,
                                            fontWeight: FontWeight
                                                .bold), // Font size for the first part
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => MarkAsDone(),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(150,
                                  30), // Adjust the width and height as needed
                              backgroundColor:
                                  periwinkleColor, // Set the background color
                              foregroundColor:
                                  Colors.white, // Set the text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Set the border radius
                                side: const BorderSide(
                                    color: Colors.blue,
                                    width: 0), // Set the border color
                              ),
                            ),
                            child: const Text("Mark as Done"),
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
                              'ADD FOLLOW-UP',
                              style: TextStyle(
                                  fontSize: 22.0,
                                  color: periwinkleColor,
                                  fontWeight: FontWeight
                                      .bold), // Adjust the font size as needed
                            ),
                            const Text(
                              'PHYSICIAN:',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color:
                                      periwinkleColor), // Adjust the font size as needed
                            ),
                            const SizedBox(
                              height: 10,
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
                            const Text(
                              'FACILITY:',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color:
                                      periwinkleColor), // Adjust the font size as needed
                            ),
                            const SizedBox(
                              height: 10,
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
                            const Text(
                              'DATE:',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color:
                                      periwinkleColor), // Adjust the font size as needed
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                // Month Dropdown
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: DropdownButton<String>(
                                      value: selectedMonth,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedMonth = newValue!;
                                        });
                                      },
                                      items: [
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
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                          style: TextStyle(fontSize: 14.0)), // Adjust the font size as needed
                                        );
                                      }).toList(),
                                      underline: Container(),
                                      icon: const Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                      
                                // Day Dropdown
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: DropdownButton<String>(
                                      value: selectedDay,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedDay = newValue!;
                                        });
                                      },
                                      items: List<String>.generate(31,
                                              (index) => (index + 1).toString())
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,style: TextStyle(fontSize: 14.0)),
                                        );
                                      }).toList(),
                                      underline: Container(),
                                      icon: const Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                      
                                // Year Dropdown
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: DropdownButton<String>(
                                      value: selectedYear,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedYear = newValue!;
                                        });
                                      },
                                      items: List<String>.generate(
                                              10,
                                              (index) =>
                                                  (2023 - index).toString())
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,style: TextStyle(fontSize: 14.0)),
                                        );
                                      }).toList(),
                                      underline: Container(),
                                      icon: const Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Time:',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color:
                                      periwinkleColor), // Adjust the font size as needed
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                // Hour Dropdown
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: DropdownButton<String>(
                                      value: selectedTime,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedTime = newValue!;
                                        });
                                      },
                                      items: [
                                        'alas-otso sa buntag',
                                        'alas-dyis sa buntag',
                                        'alas-unsi sa buntag',
                                        'alas-dose sa buntag',
                                        'ala-una sa buntag',
                                        'alas-dos sa hapon',
                                        'alas-tres sa hapon',
                                        'alas-kwatro sa hapon',
                                        'alas-singko sa hapon',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,style: TextStyle(fontSize: 14.0)),
                                        );
                                      }).toList(),
                                      underline: Container(),
                                      icon: const Icon(Icons.arrow_drop_down),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: ElevatedButton(
                                onPressed: () => submitFollowUpData(),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(200,
                                      50), // Adjust the width and height as needed
                                  backgroundColor:
                                      periwinkleColor, // Set the background color
                                  foregroundColor:
                                      Colors.white, // Set the text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Set the border radius
                                    side: const BorderSide(
                                        color: Colors.blue,
                                        width: 0), // Set the border color
                                  ),
                                ),
                                child: const Text("Submit"),
                              ),
                            ),
                          ],
                        ),
                    )
                    : const Expanded(
                      child:  Row(
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
