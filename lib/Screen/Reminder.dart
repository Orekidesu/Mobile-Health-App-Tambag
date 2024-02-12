// ignore_for_file: camel_case_types, file_names, non_constant_identifier_names

import 'dart:async';
import 'package:Tambag_Health_App/Custom_Widgets/Cutom_table.dart';
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
  List<String> list = <String>['Buntag', 'Hapon', 'Gabie'];
  List<String> columns = ['Name', 'Contact Number', 'Medication'];
  List<List<String>> rows = [];

  @override
  void initState() {
    super.initState();
    _initializePatientList();
    targetOras = list.first;
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

        List<String> matchingNames =
            Medication.where((medicine) => medicine['oras'] == targetOras)
                .map((medicine) => medicine['name'] as String)
                .toList();

        patientsWithMedications.add({
          'name': patient['name'],
          'contact_number': patient['contact_number'],
          'medication': matchingNames,
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
        isLoading = false;
      });
    } catch (error) {
      showErrorNotification('Error: $error');
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
      if (messageController.text.isEmpty) {
        showErrorNotification('Message is Empty');
        return;
      }

      setState(() {
        isSending = true;
      });

      List<String?> numbers = await getContactNumbersWithBaranggay();
      if (numbers.isEmpty) {
        showErrorNotification('No contact numbers available');
        return;
      }

      String commaSeparatedNumbers =
          numbers.where((number) => number != null).join(', ');

      await sendSMS(messageController.text, commaSeparatedNumbers);
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
                    value: targetOras,
                    onChanged: (String? newValue) {
                      setState(() {
                        targetOras = newValue!;
                        _initializePatientList();
                      });
                    },
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
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              MyTable(columns: columns, rows: rows)
                            ],
                          ),
                        ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomActionButton(
                    custom_width: 320,
                    onPressed: (isSending || isLoading)
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
