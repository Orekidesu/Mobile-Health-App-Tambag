// ignore_for_file: camel_case_types

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

class Patient_Profile extends StatefulWidget {
  final String patientId;

  const Patient_Profile({Key? key, required this.patientId}) : super(key: key);

  @override
  State<Patient_Profile> createState() => _Patient_ProfileState();
}

class _Patient_ProfileState extends State<Patient_Profile> {
  late Future<Map<String, dynamic>> patientData;
  late Future<List<Map<String, dynamic>>> medications;
  int count = 0;

  @override
  void initState() {
    super.initState();
    patientData = DataService.getPatientData(widget.patientId);
    medications = DataService.getMedications(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
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
                                      text1: 'NAME:',
                                      text2: patientInfo['name'] ?? 'N/A',
                                    ),
                                    CustomTextWidget(
                                      text1: 'AGE:',
                                      text2: patientInfo['age'] ?? 'N/A',
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
                    Container(
                      height:
                          MediaQuery.of(context).size.width < 600 ? 300 : 500,
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Expanded(
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
                              return const Text(
                                  'No medication data available.');
                            } else {
                              final medicationsList = snapshot.data!;
                              return ListView(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 16, 0),
                                children: medicationsList.map((medication) {
                                  return CardWithIcon(
                                    icon: FontAwesomeIcons.pills,
                                    title:
                                        "MEDICATION ${medication['count']}\n${medication['name']}",
                                    subtitle: medication['dosage'] ?? 'N/A',
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0.0),
        height: 200,
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
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: const Text(
                  'DRUG MEDICATION INTERACTIONS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardWithIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color borderColor;

  CardWithIcon({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.borderColor = const Color.fromARGB(255, 103, 103, 186),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 0),
      child: Container(
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
            leading:
                Icon(icon, color: const Color.fromARGB(255, 103, 103, 186)),
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
