import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_health_app_tambag/Screen/Dashboard.dart';
import 'package:mobile_health_app_tambag/custom_widgets/text_widget_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Patient_Profile extends StatefulWidget {
  final String patientId;

  const Patient_Profile({Key? key, required this.patientId}) : super(key: key);

  @override
  State<Patient_Profile> createState() => _Patient_ProfileState();
}

class _Patient_ProfileState extends State<Patient_Profile> {
  static const Color backgroundColor = Color.fromRGBO(245, 248, 255, 1.0);
  static const Color periwinkleColor = Color.fromARGB(255, 103, 103, 186);

  late Future<Map<String, dynamic>> patientData;
  late Future<List<Map<String, dynamic>>> medications;
  int count = 0;

  @override
  void initState() {
    super.initState();
    patientData = getPatientData();
    medications = getMedications();
  }

  Future<Map<String, dynamic>> getPatientData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(widget.patientId)
          .get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching patient data: $e');
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getMedications() async {
    try {
      final medicationsSnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(widget.patientId)
          .collection('medications')
          .get();

      count = 0;
      return medicationsSnapshot.docs.map((medicationDoc) {
        count++;
        return {
          'name': medicationDoc['medicationName'],
          'dosage': medicationDoc['dosage'],
          'count': count,
        };
      }).toList();
    } catch (e) {
      print('Error fetching medications: $e');
      return [];
    }
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
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: periwinkleColor,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Dashboard(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          CustomTextWidget(
                              text1: 'PATIENT\nPROFILE', text2: ''),
                          const SizedBox(width: 10),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
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
                                  return Text('No patient data available.');
                                } else {
                                  final patientInfo = snapshot.data!;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        text2:
                                            patientInfo['physician'] ?? 'N/A',
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
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Expanded(
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: medications,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Text('No medication data available.');
                              } else {
                                final medicationsList = snapshot.data!;
                                return ListView(
                                  padding: EdgeInsets.fromLTRB(10, 10, 16, 0),
                                  children: medicationsList.map((medication) {
                                    return CardWithIcon(
                                      icon: FontAwesomeIcons.pills,
                                      title:
                                          "MEDICATION ${medication['count']}\n${medication['name']}" ??
                                              'N/A',
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
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0.0),
        height: 200,
        margin: EdgeInsets.only(bottom: 25.0),
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
            constraints: BoxConstraints.expand(),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Text(
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
            leading: Icon(icon, color: Color.fromARGB(255, 103, 103, 186)),
            title: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: Color.fromARGB(255, 103, 103, 186),
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                color: Color.fromARGB(255, 103, 103, 186),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
