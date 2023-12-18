import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Screen/Dashboard.dart';
import '../custom_widgets/text_widget_info.dart';
import '../Custom_Widgets/CustomActionButton.dart';
import '../constants/light_constants.dart';
import '../Custom_Widgets/Custom_Appbar.dart';
import '../functions/custom_functions.dart';

class Tracker extends StatefulWidget {
  final String patientId;
  const Tracker({super.key, required this.patientId});

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  TextEditingController reminderController = TextEditingController();
  TextEditingController contraindicationController = TextEditingController();
  TextEditingController dietController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return 
    SafeArea(child: Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Custom_Appbar(
                Baranggay: "TRACKER",
                Apptitle: "PATIENT",
                hasbackIcon: true,
                hasRightIcon: false,
                iconColor: Colors.white,
                DistinationBack: () => goToPage(context, const Dashboard()),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10.0, 16.0, 0.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(text1: 'NAME:', text2: 'OREKI HOUTAROU'),
                      CustomTextWidget(text1: 'AGE:', text2: '22'),
                      CustomTextWidget(
                          text1: 'ADDRESS:',
                          text2: 'PUROK 5,BARANGAY GUADALUPE, BAYBAY '),
                      CustomTextWidget(
                          text1: 'PHYSICIAN:', text2: 'DR. STRANGE'),
                      CustomTextWidget(
                          text1: 'CONTACT NO:', text2: '09881242331'),
                    ],
                  ),
                ),
              ),

              // LIST MEDICATION //
              Expanded(
                flex: 2,
                child: Container(
                  height: 300,
                  margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: periwinkleColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      constraints: const BoxConstraints.expand(),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(FontAwesomeIcons.pills),
                                    SizedBox(
                                      width: 16.0,
                                    ),
                                    Text(
                                      'LUNES',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 103, 103, 186)),
                                    ),
                                  ],
                                )),
                            Expanded(
                              flex: 8,
                              child: ListView(
                                children: [
                                  MedicationTile(
                                      medicationName: 'AMLODIPINE',
                                      text: '50mg'),
                                  MedicationTile(
                                      medicationName: 'LOSARTAN',
                                      text: '500mg'),
                                  MedicationTile(
                                      medicationName: 'METROPOLOL',
                                      text: '5mg'),
                                  MedicationTile(
                                      medicationName: 'PARACETAMOL',
                                      text: '10mg'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  margin: const EdgeInsets.only(bottom: 25.0),
                  height: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: periwinkleColor,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            const Text(
                              'Reminder:',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color:
                                      backgroundColor), // Adjust the font size as needed
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: reminderController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors
                                    .white, // Set the background color to white
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust the radius as needed
                                  borderSide: const BorderSide(
                                    color:
                                        backgroundColor, // Set the border color
                                    width: 4,
                                  ),
                                ),
                              ),
                              // Additional properties for the TextField can be added here
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Contraindication:',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color:
                                      backgroundColor), // Adjust the font size as needed
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: contraindicationController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors
                                    .white, // Set the background color to white
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Adjust the radius as needed
                                  borderSide: const BorderSide(
                                    color:
                                        backgroundColor, // Set the border color
                                    width: 4,
                                  ),
                                ),
                              ),
                              // Additional properties for the TextField can be added here
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Diet:',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color:
                                      backgroundColor), // Adjust the font size as needed
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: dietController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors
                                    .white, // Set the background color to white
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: backgroundColor,
                                    width: 4,
                                  ),
                                ),
                              ),
                              // Additional properties for the TextField can be added here
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomActionButton(
                    onPressed: () {},
                    buttonText: "PRINT",
                  ),
                ],
              )
            ],
          ),
        ),
      ),), 
    );
  }
}

class MedicationTile extends StatelessWidget {
  final String text;
  final String medicationName;

  MedicationTile({
    required this.medicationName,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        medicationName,
        style: const TextStyle(
          color: Color.fromARGB(255, 103, 103, 186),
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        text,
        style: const TextStyle(
          color: Color.fromARGB(255, 103, 103, 186),
        ),
      ),
    );
  }
}
