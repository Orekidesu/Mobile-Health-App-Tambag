import 'package:Tambag_Health_App/Firebase_Query/Firebase_Functions.dart';
import 'package:Tambag_Health_App/custom_widgets/Drug_interaction.dart';
import 'package:Tambag_Health_App/custom_widgets/text_widget_info.dart';
import 'package:flutter/material.dart';

class TrackerPDF extends StatefulWidget {
  final String patientId;

  const TrackerPDF({Key? key, required this.patientId}) : super(key: key);

  @override
  _TrackerPDFState createState() => _TrackerPDFState();
}

class _TrackerPDFState extends State<TrackerPDF> {
  late Future<Map<String, dynamic>> patientData;
  late Future<List<Map<String, dynamic>>> medications;
  late Future<List<Map<String, dynamic>>> medicationInteractions;

  @override
  void initState() {
    super.initState();

    // Intl.defaultLocale = 'fil';
    patientData = DataService.getPatientData(widget.patientId);
    medications = DataService.getMedications(widget.patientId);
    medicationInteractions = _initializeMedicationInteractions();
  }

  //
  Future<List<Map<String, dynamic>>> _initializeMedicationInteractions() async {
    final patientMedications = await medications;
    final interactionChecker = MedicationInteractionChecker(allInteractions);

    final List<String> medicationNames =
        patientMedications.map((med) => med['name'] as String).toList();

    final List<Map<String, dynamic>> medicationInteractions =
        interactionChecker.getInteractions(medicationNames);

    return medicationInteractions;
  }

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: const Row(
                children: [
                  // Put a circular image
                  Image(
                    image: AssetImage('assets/tambag.png'),
                    width: 90.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'TAMBAG',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text('Telehealth And Medications-',
                          style: TextStyle(
                            fontSize: 8,
                          )),
                      Text('Barangay Assistance to Geriatic Clients',
                          style: TextStyle(
                            fontSize: 8,
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PATIENT PROFILE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: patientData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No patient data available.');
                      } else {
                        final patientInfo = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomBoldText(
                                label: 'Pangan', boldText: patientInfo['name']),
                            CustomBoldText(
                                label: 'Edad', boldText: patientInfo['age']),
                            CustomBoldText(
                                label: 'Puy-anan',
                                boldText: patientInfo['address']),
                            CustomBoldText(
                                label: 'Doktor', boldText: patientInfo['name']),
                            CustomBoldText(
                                label: 'Numero sa Selpon',
                                boldText: patientInfo['contact_number']),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'MGA TAMBAL',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            Container(),
          ],
        ),
      ),
    ));
  }
}

class CustomBoldText extends StatelessWidget {
  final String label;
  final String boldText;

  const CustomBoldText({required this.label, required this.boldText, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$label: ',
        style:
            TextStyle(fontSize: 12), // You can adjust the font size as needed
        children: <TextSpan>[
          TextSpan(
            text: boldText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
