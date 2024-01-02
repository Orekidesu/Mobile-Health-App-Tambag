// ignore_for_file: camel_case_types

import 'package:Tambag_Health_App/custom_widgets/Drug_interaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screen/Dashboard.dart';
import '../custom_widgets/text_widget_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../functions/custom_functions.dart';
import '../Custom_Widgets/Custom_Appbar.dart';
import '../constants/light_constants.dart';
import '../Firebase_Query/Firebase_Functions.dart';
import 'package:Tambag_Health_App/custom_widgets/Custom_Tile.dart';

class Patient_Profile extends StatefulWidget {
  final String patientId;

  const Patient_Profile({super.key, required this.patientId});

  @override
  State<Patient_Profile> createState() => _Patient_ProfileState();
}

class _Patient_ProfileState extends State<Patient_Profile> {
  late Future<Map<String, dynamic>> patientData;
  late Future<List<Map<String, dynamic>>> medications;
  int count = 0;

  late Future<List<Map<String, dynamic>>> interactingMedications;
  late Future<List<String>> interactionDetails;

  @override
  void initState() {
    super.initState();
    patientData = DataService.getPatientData(widget.patientId);
    medications = DataService.getMedications(widget.patientId);
    interactingMedications = _initializeInteractingMedications();
    interactionDetails = _initializeInteractionDetails();
  }

  Future<List<Map<String, dynamic>>> _initializeInteractingMedications() async {
    final patientMedications = await medications;
    final interactionChecker = MedicationInteractionChecker(allInteractions);

    final List<String> medicationNames =
        patientMedications.map((med) => med['name'] as String).toList();
    final List<String>? interactingMedicines =
        interactionChecker.checkInteractions(medicationNames);

    final List<Map<String, dynamic>> interactingMedications = patientMedications
        .where((medication) =>
            interactingMedicines != null &&
            interactingMedicines.contains(medication['name']))
        .map((medication) {
      final name = medication['name'] as String;
      final dosage = medication['dosage'] as String? ?? 'N/A';

      return {
        'name': name,
        'dosage': dosage,
      };
    }).toList();

    return interactingMedications;
  }

  Future<List<String>> _initializeInteractionDetails() async {
    final patientMedications = await medications;
    final interactionChecker = MedicationInteractionChecker(allInteractions);

    final List<String> medicationNames =
        patientMedications.map((med) => med['name'] as String).toList();
    final List<String>? interactingMedicines =
        interactionChecker.checkInteractions(medicationNames);

    final List<String> interactionDetails =
        interactionChecker.getInteractionsDetails(interactingMedicines ?? []);

    return interactionDetails;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Custom_Appbar(
                      Baranggay: "PROFILE",
                      Apptitle: "PATIENT",
                      hasbackIcon: true,
                      hasRightIcon: false,
                      iconColor: Colors.white,
                      DistinationBack: () =>
                          goToPage(context, const Dashboard()),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<Map<String, dynamic>>(
                            future: patientData,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Text('No patient data available.');
                              } else {
                                final patientInfo = snapshot.data!;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextWidget(
                                      text1: 'Name:',
                                      text2: patientInfo['name'] ?? 'N/A',
                                    ),
                                    CustomTextWidget(
                                      text1: 'Age:',
                                      text2: patientInfo['age'] ?? 'N/A',
                                    ),
                                    CustomTextWidget(
                                      text1: 'Address:',
                                      text2: patientInfo['address'] ?? 'N/A',
                                    ),
                                    CustomTextWidget(
                                      text1: 'Physician:',
                                      text2: patientInfo['physician'] ?? 'N/A',
                                    ),
                                    CustomTextWidget(
                                      text1: 'Mobile:',
                                      text2: patientInfo['contact_number'] ??
                                          'N/A',
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // Medications section
                    Expanded(
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: medications,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CupertinoActivityIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('No medication data available.');
                          } else {
                            final medicationsList = snapshot.data!;
                            return ListView(
                              children: medicationsList.map((medication) {
                                return CardWithIcon(
                                  icon: FontAwesomeIcons.pills,
                                  title: "${medication['name']}",
                                  subtitle: medication['dosage'] ?? 'N/A',
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0.0),
          height: 200.0,
          margin: const EdgeInsets.only(bottom: 25.0),
          child: Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: periwinkleColor,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  child: Center(
                    child: Text(
                      'DRUG MEDICATION INTERACTIONS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 120.0,
                    width: 400.0,
                    padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: interactingMedications,
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
                                    'No interacting medications available.');
                              } else {
                                final interactingMedicationsList =
                                    snapshot.data!;
                                return Column(
                                  children: interactingMedicationsList
                                      .map((interaction) {
                                    return ListTile(
                                      title: Text(
                                        interaction['name']
                                                .toString()
                                                .toUpperCase() ??
                                            'N/A',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: periwinkleColor,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${interaction['dosage'] ?? 'N/A'}',
                                        style: TextStyle(
                                          color: periwinkleColor,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),

                          //INTERACTION DETAILS SECTION: IT SHOULD CONTAIN A CENTERED HEADING CALLED "INTERACTIONS" AND BELOW IT ARE THE INTERACTION DETAILS //

                          FutureBuilder<List<String>>(
                            future: interactionDetails,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text('');
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Text('');
                              } else {
                                final interactionDetailsList = snapshot.data!;
                                return Column(
                                  children: [
                                    const SizedBox(height: 10.0),
                                    Center(
                                      child: Text(
                                        'INTERACTIONS',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: periwinkleColor,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: interactionDetailsList.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            interactionDetailsList[index],
                                            style: TextStyle(
                                                color: periwinkleColor),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardWithIcon extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final Color borderColor;

  const CardWithIcon({
    Key? key,
    this.icon,
    required this.title,
    required this.subtitle,
    this.borderColor = const Color.fromARGB(255, 103, 103, 186),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 0),
      child: SizedBox(
        height: MediaQuery.of(context).size.width < 600 ? 125.0 : 150.0,
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ListTile(
            leading: icon != null
                ? Icon(icon, color: const Color.fromARGB(255, 103, 103, 186))
                : null,
            title: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: Color.fromARGB(255, 103, 103, 186),
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                color: Color.fromARGB(255, 103, 103, 186),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
