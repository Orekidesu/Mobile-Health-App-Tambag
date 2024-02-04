import 'package:Tambag_Health_App/Screen/TrackerPDF.dart';
import 'package:Tambag_Health_App/api/pdf_api.dart';
import 'package:Tambag_Health_App/api/pdf_tracker_api.dart';
import 'package:Tambag_Health_App/custom_widgets/Custom_Tile.dart';
import 'package:Tambag_Health_App/custom_widgets/Drug_interaction.dart';
import 'package:Tambag_Health_App/custom_widgets/Medication_schedule.dart';
import 'package:intl/intl.dart';

import '../Firebase_Query/Firebase_Functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Screen/Dashboard.dart';
import '../custom_widgets/text_widget_info.dart';
import '../Custom_Widgets/CustomActionButton.dart';
import '../constants/light_constants.dart';
import '../Custom_Widgets/Custom_Appbar.dart';
import '../functions/custom_functions.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../model/patient_info.dart';

class Tracker extends StatefulWidget {
  final String patientId;

  const Tracker({super.key, required this.patientId});

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  late Future<Map<String, dynamic>> patientData;
  late Future<List<Map<String, dynamic>>> medications;
  TextEditingController reminderController = TextEditingController();
  TextEditingController contraindicationController = TextEditingController();
  TextEditingController dietController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fil');
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          padding: const EdgeInsets.all(20),
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
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<Map<String, dynamic>>(
                        future: patientData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('No patient data available.');
                          } else {
                            final patientInfo = snapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 5.0, 16.0, 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomTextWidget(
                                    text1: 'NAME:',
                                    text2: patientInfo['name'] ?? 'N/A',
                                  ),
                                  CustomTextWidget(
                                    text1: 'AGE:',
                                    text2:
                                        patientInfo['age']?.toString() ?? 'N/A',
                                  ),
                                  CustomTextWidget(
                                    text1: 'ADDRESS:',
                                    text2: patientInfo['address'] ?? 'N/A',
                                  ),
                                  CustomTextWidget(
                                    text1: 'PHYSICIAN:',
                                    text2: patientInfo['physician'] ?? 'N/A',
                                  ),
                                  CustomTextWidget(
                                    text1: 'CONTACT NO.:',
                                    text2:
                                        patientInfo['contact_number'] ?? 'N/A',
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                      // LIST MEDICATION //
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                        height: 350,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: periwinkleColor,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(FontAwesomeIcons.pills),
                                    SizedBox(width: 10.0),
                                    Text(
                                      // Get the current day and format it to your needs (e.g., 'EEEE' for full day name).
                                      DateFormat('EEEE', 'fil')
                                          .format(DateTime.now()),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 103, 103, 186),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child:
                                      FutureBuilder<List<Map<String, dynamic>>>(
                                    future: medications,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                        //  child: Text('Please wait...'),);
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return const Text(
                                            'No medication data available. ');
                                      } else {
                                        final List<Map<String, dynamic>>
                                            medicationList = snapshot.data!;
                                        return ListView.builder(
                                          itemCount: medicationList.length,
                                          itemBuilder: (context, index) {
                                            final medication =
                                                medicationList[index];
                                            return MedicationTile(
                                              medicationName:
                                                  medication['name'] ?? 'N/A',
                                              text:
                                                  "${medication['dosage']}.\n${medication['indication']}." ??
                                                      'N/A',
                                            );
                                          },
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
                      const SizedBox(
                        height: 5,
                      ),
                      // Card(
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(20.0),
                      //   ),
                      //   color: periwinkleColor,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(16.0),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: [
                      //         const Text(
                      //           'Reminder:',
                      //           style: TextStyle(
                      //             fontSize: 16.0,
                      //             color: backgroundColor,
                      //           ),
                      //         ),
                      //         TextField(
                      //           controller: reminderController,
                      //           decoration: InputDecoration(
                      //             filled: true,
                      //             fillColor: Colors.white,
                      //             border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(10.0),
                      //               borderSide: const BorderSide(
                      //                 color: backgroundColor,
                      //                 width: 4,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         const Text(
                      //           'Contraindication:',
                      //           style: TextStyle(
                      //             fontSize: 16.0,
                      //             color: backgroundColor,
                      //           ),
                      //         ),
                      //         TextField(
                      //           controller: contraindicationController,
                      //           decoration: InputDecoration(
                      //             filled: true,
                      //             fillColor: Colors.white,
                      //             border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(10.0),
                      //               borderSide: const BorderSide(
                      //                 color: backgroundColor,
                      //                 width: 4,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         const Text(
                      //           'Diet:',
                      //           style: TextStyle(
                      //             fontSize: 16.0,
                      //             color: backgroundColor,
                      //           ),
                      //         ),
                      //         TextField(
                      //           controller: dietController,
                      //           decoration: InputDecoration(
                      //             filled: true,
                      //             fillColor: Colors.white,
                      //             border: OutlineInputBorder(
                      //               borderRadius: BorderRadius.circular(10.0),
                      //               borderSide: const BorderSide(
                      //                 color: backgroundColor,
                      //                 width: 4,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 5,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TrackerPDF(patientId: widget.patientId),
                                ),
                              );
                            },
                            /*async {
                              try {
                                Map<String, dynamic> patientData =
                                    await DataService.getPatientData(
                                        widget.patientId);
                                List<Map<String, dynamic>> medications =
                                    await DataService.getMedications(
                                        widget.patientId);
                                List<Map<String, dynamic>>
                                    medicationInteractions =
                                    await _initializeMedicationInteractions();
                                Map<String, Map<String, String>>
                                    processedMedications =
                                    await _initializeProcessedMedications();

                                PatientInfo patientInfo = PatientInfo(
                                  patientData: Future.value(patientData),
                                  medications: Future.value(medications),
                                  medicationInteractions:
                                      Future.value(medicationInteractions),
                                  processedMedications:
                                      Future.value(processedMedications),
                                );

                                PdfTrackerApi api = PdfTrackerApi();
                                final pdfFile = await api.generate(patientInfo);
                                await PdfApi.openFile(pdfFile);
                              } catch (e) {
                                print('Error: $e');
                              }
                            },
                            */
                            buttonText: "Save as PDF",
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
