import 'package:Tambag_Health_App/Custom_Widgets/CustomActionButton.dart';
import 'package:Tambag_Health_App/Firebase_Query/Firebase_Functions.dart';
import 'package:Tambag_Health_App/custom_widgets/Drug_interaction.dart';
import 'package:Tambag_Health_App/custom_widgets/Medication_schedule.dart';
import 'package:Tambag_Health_App/custom_widgets/text_widget_info.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
  late Future<Map<String, Map<String, String>>> processedMedications;
  @override
  void initState() {
    super.initState();

    // Intl.defaultLocale = 'fil';
    patientData = DataService.getPatientData(widget.patientId);
    medications = DataService.getMedications(widget.patientId);
    medicationInteractions = _initializeMedicationInteractions();
    processedMedications = _initializeProcessedMedications();
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

  //
  Future<Map<String, Map<String, String>>>
      _initializeProcessedMedications() async {
    final patientMedications = await medications;
    final processedMedications =
        MedicationProcessor.processMedications(patientMedications);

    return processedMedications;
  }

  //

  List<TableRow> _buildTableRows(List<Map<String, dynamic>> dataList,
      List<String> columnNames, List<String> keyNames) {
    return [
      TableRow(
        children: columnNames.map((columnName) {
          return TableCell(
            child: Center(
              child: Text(
                columnName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      for (var data in dataList)
        TableRow(
          children: keyNames.map((keyName) {
            return TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(data[keyName] ?? 'N/A'),
              ),
            );
          }).toList(),
        ),
    ];
  }

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
                  const Text(
                    'PATIENT PROFILE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: patientData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: Text(''));
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
                                label: 'Doktor',
                                boldText: patientInfo['physician']),
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
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 50.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      // ====================MGA TAMBAL AREA ================= //
                      // #############FIRST TABLE############# //
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text(
                          'MGA TAMBAL',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),

                      Container(
                        // THIS IS WHERE I WANT THE TABLE
                        child: FutureBuilder<Map<String, Map<String, String>>>(
                          future: processedMedications,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: Text(''));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text(
                                  'No processed medication data available.');
                            } else {
                              final processedMedicationsData = snapshot.data!;
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Table(
                                  border: TableBorder.all(color: Colors.grey),
                                  defaultColumnWidth: IntrinsicColumnWidth(),
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                            child: Center(
                                                child: Text(
                                          'TIME',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ))),
                                        TableCell(
                                            child: Center(
                                                child: Text(
                                          'TUKMA',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ))),
                                        for (var day in [
                                          'LUNES',
                                          'MARTES',
                                          'MIYERKULES',
                                          'HUWEBES',
                                          'BIYERNES',
                                          'SABADO',
                                          'DOMINGO',
                                        ])
                                          TableCell(
                                              child: Center(
                                                  child: Text(
                                            day,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ))),
                                      ],
                                    ),
                                    for (var timeSlot in [
                                      'Buntag',
                                      'Udto',
                                      'Gabie'
                                    ])
                                      for (var tukma in [
                                        'Sa dili pa mukaon',
                                        'Human ug kaon'
                                      ])
                                        TableRow(
                                          children: [
                                            TableCell(
                                              child: Center(
                                                child: tukma == 'Human ug kaon'
                                                    ? Text('')
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(timeSlot),
                                                      ),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    Center(child: Text(tukma)),
                                              ),
                                            ),
                                            for (var day in [
                                              'Monday',
                                              'Tuesday',
                                              'Wednesday',
                                              'Thursday',
                                              'Friday',
                                              'Saturday',
                                              'Sunday',
                                            ])
                                              TableCell(
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      processedMedicationsData[
                                                                  timeSlot]
                                                              ?[tukma] ??
                                                          'N/A',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Container(
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: medications,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text(
                                  'No medication data available.');
                            } else {
                              final medicationsList = snapshot.data!;
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Table(
                                  border: TableBorder.all(color: Colors.grey),
                                  defaultColumnWidth: IntrinsicColumnWidth(),
                                  children: _buildTableRows(
                                    medicationsList,
                                    [
                                      'TAMBAL',
                                      'GIDAG-HANUN',
                                      'PARA ASA KINI',
                                      'PAHINUMDOM',
                                    ],
                                    [
                                      'name',
                                      'dosage',
                                      'indication',
                                      'special_reminder'
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),

                      //======================== DRUG INTERACTION AREA ================== //
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text(
                          'INTERACTION SA MGA TAMBAL',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),

                      Container(
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: medicationInteractions,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: Text(''));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text(
                                  'No medication data available.');
                            } else {
                              final medicationsList = snapshot.data!;
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Table(
                                  border: TableBorder.all(color: Colors.grey),
                                  defaultColumnWidth: IntrinsicColumnWidth(),
                                  children: _buildTableRows(
                                    medicationsList,
                                    ['TAMBAL 1', 'TAMBAL 2', 'INTERAKSYON'],
                                    [
                                      'medicine1',
                                      'medicine2',
                                      'interactionDetails'
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.download),
                onPressed: () {},
              ),
            ),
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
