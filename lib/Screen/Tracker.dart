import 'package:Tambag_Health_App/custom_widgets/Custom_Tile.dart';
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

class Tracker extends StatefulWidget {
  final String patientId;

  const Tracker({Key? key, required this.patientId}) : super(key: key);

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  late Future<Map<String, dynamic>> patientData;
  late Future<List<Map<String, dynamic>>> medications;
  TextEditingController reminderController = TextEditingController();
  TextEditingController contraindicationController = TextEditingController();
  TextEditingController dietController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Intl.defaultLocale = 'fil';
    patientData = DataService.getPatientData(widget.patientId);
    medications = DataService.getMedications(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fil');
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
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
                                  16.0, 10.0, 16.0, 0.0),
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
                        height: 250,
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
                                            'No medication data available.');
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
                                                  medication['dosage'] ?? 'N/A',
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
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: periwinkleColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Reminder:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: backgroundColor,
                                ),
                              ),
                              TextField(
                                controller: reminderController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: backgroundColor,
                                      width: 4,
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                'Contraindication:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: backgroundColor,
                                ),
                              ),
                              TextField(
                                controller: contraindicationController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: backgroundColor,
                                      width: 4,
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                'Diet:',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: backgroundColor,
                                ),
                              ),
                              TextField(
                                controller: dietController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: backgroundColor,
                                      width: 4,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomActionButton(
                            onPressed: () {},
                            buttonText: "Print",
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
