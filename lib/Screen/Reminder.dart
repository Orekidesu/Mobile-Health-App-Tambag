// ignore_for_file: camel_case_types, file_names, non_constant_identifier_names

import 'dart:async';
import 'package:Tambag_Health_App/Custom_Widgets/Cutom_table.dart';
import 'package:Tambag_Health_App/Custom_Widgets/Drug_interaction.dart';
import 'package:Tambag_Health_App/constants/light_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Custom_Widgets/CustomActionButton.dart';
import '../Custom_Widgets/Custom_Appbar.dart';
import '../Firebase_Query/Firebase_Functions.dart';
import '../functions/custom_functions.dart';
import 'Dashboard.dart';

class Patient {
  final String id;
  final String name;
  Patient({
    required this.id,
    required this.name,
  });
}

class Reminder extends StatefulWidget {
  final String selectedBrgy;
  const Reminder({super.key, required this.selectedBrgy});

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  TextEditingController messageController = TextEditingController();
  bool isSending = false;
  bool isLoading = false;
  String targetOras = '';
  List<String> list = <String>['Buntag', 'Udto', 'Gabie', 'Lapsed'];
  List<String> columns = ['Name', 'Contact Number', 'Medication'];
  List<List<String>> rows = [];
  List<List<String>> PatientData = [];

  @override
  void initState() {
    super.initState();
    _initializePatientList();
    setTime();
  }

  void setTime() {
    int currentHour = DateTime.now().hour;
    if (currentHour >= 6 && currentHour < 10) {
      setState(() {
        targetOras = 'Buntag';
      });
    } else if (currentHour >= 10 && currentHour < 14) {
      setState(() {
        targetOras = 'Udto';
      });
    } else if (currentHour >= 15 && currentHour < 22) {
      setState(() {
        targetOras = 'Gabie'; 
      });
    } else {
      setState(() {
        targetOras = 'Lapsed';
      });
    }
  }

  Future<void> _initializePatientList() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<Map<String, dynamic>> patientData =
          await getAllPatientNamesAndIds(widget.selectedBrgy);
      List<Map<String, dynamic>> patientsWithMedications = [];

      for (var patient in patientData) {
        List<Map<String, dynamic>> Medication =
            await DataService.getMedications(patient['id']);
        //print(Medication);

        List<String> matchingNames = Medication.where(
                (medicine) => (medicine['oras'] as String).contains(targetOras))
            .map((medicine) => medicine['name'] as String)
            .toList();

        List<Map<String, String>> dosageIndicationAndName = Medication.where(
                (medicine) => (medicine['oras'] as String).contains(targetOras))
            .map((medicine) => {
                  'name': (medicine['name'] as String).toUpperCase(),
                  'dosage': medicine['dosage'] as String,
                  'indication': medicine['indication'] as String
                })
            .toList();

        if (matchingNames.isEmpty) {
          continue;
        }

        MedicationInteractionChecker interactionChecker =
            MedicationInteractionChecker(allInteractions);
        List<String> DrugtoDrug =
            interactionChecker.getInteractionsDetails(matchingNames).toList();

        patientsWithMedications.add({
          'name': patient['name'],
          'contact_number': patient['contact_number'],
          'medication': matchingNames,
          'dosageIndicationAndName': dosageIndicationAndName,
          'reminder': Medication[0]['special_reminder'],
          'drugtodrug': DrugtoDrug,
        });
      }

      setState(() {
        rows = patientsWithMedications
            .map((patient) => [
                  patient['name'] as String,
                  patient['contact_number'] as String,
                  patient['medication'].join(', ') as String,
                ])
            .toList();
        PatientData = patientsWithMedications
            .map((patient) => [
                  patient['name'] as String,
                  patient['contact_number'] as String,
                  patient['dosageIndicationAndName'].join(', ') as String,
                  patient['reminder'] as String,
                  patient['drugtodrug'].join(', ') as String,
                ])
            .toList();
        isLoading = false;
      });
    } catch (error) {
      showErrorNotification('Error: $error');
      //print(error);
    }
  }

  Future<List<String?>> getContactNumbersWithBaranggay() async {
    try {
      final QuerySnapshot querySnapshot = await patientsCollection
          .where("address", isEqualTo: widget.selectedBrgy)
          .get();

      List<String?> contactNumbers = [];

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;

          if (data.containsKey("address") &&
              data["address"] == widget.selectedBrgy &&
              data.containsKey("contact_number")) {
            String? contactNumber = data['contact_number'];
            contactNumbers.add(contactNumber);
          }
        }

        return contactNumbers;
      } else {
        return []; // or handle the case where there are no documents with the given Baranggay
      }
    } catch (e) {
      return []; // or handle the error
    }
  }

  void sendMessage() async {
    try {
      setState(() {
        isSending = true;
      });
      for (var patient in PatientData) {
        String message = '';
        String number = patient[1];
        String patientString = patient[2];
        patientString = patientString
            .replaceAll('{ ', '')
            .replaceAll('} ', '')
            .replaceAll('name: ', '')
            .replaceAll('dosage: ', '')
            .replaceAll('indication: ', '')
            .replaceAll(': ', '');
        patientString = patientString
            .replaceAll('{', '')
            .replaceAll('}', '')
            .replaceAll(' ,', ',');
        String reminder = patient[3];
        String drugtodrug = patient[4];
        if (drugtodrug == '') {
          drugtodrug = 'Walay Interaction sa Tambal.';
        }
        message =
            'Maayong Adlaw! Kini ang imong pang-adlaw-adlaw na pahinumdom nga mutumar karon ${targetOras.toString()}:\n\n$patientString. $reminder\n\nInteraction sa mga Tambal:$drugtodrug \n\nTAMBAG, kanunay andam moabang!!';
        //print(message);
        await sendSMS(message, number);
      }

      //await sendSMS(Message, Number);
    } catch (e) {
      // Handle exceptions appropriately
      showErrorNotification('Failed to send message');
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: backgroundColor,
          height: MediaQuery.of(context).size.height, // Adjust as needed
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Custom_Appbar(
                Baranggay: "Reminder",
                Apptitle: "PATIENT",
                hasbackIcon: true,
                hasRightIcon: false,
                iconColor: Colors.white,
                DistinationBack: isSending || isLoading
                    ? null
                    : () => goToPage(context, const Dashboard()),
              ),
              const Divider(),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    style:
                        const TextStyle(color: periwinkleColor, fontSize: 15),
                    value: targetOras,
                    onChanged: null,
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
                  child: isLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: targetOras != 'Lapsed' ? MainAxisAlignment.start: MainAxisAlignment.center,
                          children: [
                            if (targetOras != 'Lapsed')
                              SingleChildScrollView(
                                child: MyTable(columns: columns, rows: rows),
                              ),
                            if (targetOras == 'Lapsed')
                              const Center(child: Text("Can't Remind Anymore",style: TextStyle(color: periwinkleColor, fontWeight: FontWeight.w600))),
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
                    onPressed: (isSending || isLoading || targetOras == 'Lapsed')
                        ? null
                        : () {
                            sendMessage();
                          },
                    buttonText: isSending ? 'Sending...' : 'Send',
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
