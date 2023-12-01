import 'package:flutter/material.dart';
import 'Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class follow_up_data {
  final String physician;
  final String facility;
  final String date;
  final bool isDone;

  follow_up_data(
      {required this.physician,
      required this.facility,
      required this.date,
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
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Create a TextEditingController
  TextEditingController physicianController = TextEditingController();
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

  void submit(String msg) {
    print(msg);
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
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 25,
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
                                    text: 'sa\n',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: periwinkleColor,
                                        fontWeight: FontWeight
                                            .w100), // Font size for the first part
                                  ),
                                  TextSpan(
                                    text:
                                        '${followUpData['facility'] ?? 'N/A '}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.0,
                                        color: periwinkleColor),
                                  ),
                                  const TextSpan(
                                    text: ' sa ',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: periwinkleColor,
                                        fontWeight: FontWeight
                                            .w100), // Font size for the first part
                                  ),
                                  const TextSpan(
                                    text: 'umaabot nga \n',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: periwinkleColor,
                                        fontWeight: FontWeight
                                            .w100), // Font size for the first part
                                  ),
                                  TextSpan(
                                    text:
                                        ' ${followUpData['date'] ?? 'N/A'}\n2023, alas-otso sa buntag',
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
                        )
                      ],
                    )
                  : Container(), // If isDone is false, display an empty container
            ),
            const SizedBox(height: 10.0),
            const Text(
              'ADD FOLLOW-UP',
              style: TextStyle(
                  fontSize: 22.0,
                  color: periwinkleColor,
                  fontWeight:
                      FontWeight.bold), // Adjust the font size as needed
            ),
            const Text(
              'PHYSICIAN:',
              style: TextStyle(
                  fontSize: 16.0,
                  color: periwinkleColor), // Adjust the font size as needed
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
                    color: periwinkleColor, // Set the border color
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
                  color: periwinkleColor), // Adjust the font size as needed
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
                    color: periwinkleColor, // Set the border color
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
                  color: periwinkleColor), // Adjust the font size as needed
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: periwinkleColor), // Add border styling
                borderRadius:
                    BorderRadius.circular(8.0), // Optional: Add border radius
              ),
              padding: EdgeInsets.all(10),
              child: InkWell(
                onTap: () => _selectDate(context),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 10),
                    Text(
                      '${selectedDate.toLocal()}'
                          .split(' ')[0], // Display selected date
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => submit('Hello'),
                child: const Text("Submit"),
                style: ElevatedButton.styleFrom(
                  fixedSize:
                      Size(200, 50), // Adjust the width and height as needed
                  backgroundColor: periwinkleColor, // Set the background color
                  foregroundColor: Colors.white, // Set the text color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Set the border radius
                    side: BorderSide(
                        color: Colors.blue, width: 0), // Set the border color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
