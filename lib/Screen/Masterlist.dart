// ignore_for_file: non_constant_identifier_names, camel_case_types, file_names, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Custom_Widgets/Add_Medication_Dialog.dart';
import '../Custom_Widgets/Custom_Appbar.dart';
import '../Custom_Widgets/Custom_Dialog.dart';
import '../Firebase_Query/Firebase_Functions.dart';
import '../constants/light_constants.dart';
import 'Dashboard.dart';
import '../Custom_Widgets/Cutom_table.dart';
import '../Custom_Widgets/CustomActionButton.dart';
import '../functions/custom_functions.dart';

class medication_inventory {
  final String med_name;
  final int med_quan;
  medication_inventory({required this.med_name, required this.med_quan});
}

class Masterlist extends StatefulWidget {
  
  // ignore: use_key_in_widget_constructors
  const Masterlist({Key? key}) : super(key: key);


  @override
  State<Masterlist> createState() => _MasterlistState();

}

class _MasterlistState extends State<Masterlist> {

final Future<Map<String, int>> _medicationQuantitiesFuture = getMedicationQuantities();
final Future<List<medication_inventory>> _allMedicalInventoryFuture = getAllMedicalInventory();

  List<String> columns = ['Medication', 'Quantity'];

  void _showMyDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: const BorderSide(width: 2, color: periwinkleColor),
          ),
          scrollable: true,
          backgroundColor: backgroundColor,
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(periwinkleColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const AddMedication(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Custom_Appbar(
              Apptitle: "MEDICATION",
              Baranggay: "MASTERLIST",
              hasbackIcon: true,
              hasRightIcon: true,
              icon: Icons.add,
              iconColor: Colors.white,
              DistinationBack: () => goToPage(context, const Dashboard()),
              Distination: () {
                _showMyDialog(context);
              },
            ),
            const SizedBox(height: 25),
            const Text(
              'CLIENT MEDICATION SUMMARY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: periwinkleColor,
                fontSize: 20,
              ),
            ),
            const Text(
              'Diri nga seksyon makita ang tanang\ntambal nga ginagamit sa mga geriatic\nclient ug ang kadaghanon nga\ngikinahanglan matag tambal.',
              style: TextStyle(
                fontWeight: FontWeight.w100,
                color: periwinkleColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<Map<String, int>>(
              future: _medicationQuantitiesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No medication inventory available.'));
                } else {
                  // Extract medication data from the snapshot
                  Map<String, int> medicationQuantities = snapshot.data!;

                  // Build rows for the table using sorted data
                  List<MapEntry<String, int>> sortedRows =
                      medicationQuantities.entries.toList()
                        ..sort((a, b) => a.key.compareTo(b.key));

                  List<List<String>> rows = sortedRows.map((entry) {
                    return [entry.key, entry.value.toString()];
                  }).toList();

                  return MyTable(columns: columns, rows: rows);
                }
              },
            ),
            const SizedBox(height: 25),
            const Text(
              'MEDICATION INVENTORY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: periwinkleColor,
                fontSize: 20,
              ),
            ),
            const Text(
              'Diri nga seksyon makita ang istak sa\ntambal.',
              style: TextStyle(
                fontWeight: FontWeight.w100,
                color: periwinkleColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<medication_inventory>>(
              future: _allMedicalInventoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No medication inventory available.'));
                } else {
                  // Sort the medication inventory data alphabetically based on med_name
                  List<medication_inventory> sortedMedicationInventory =
                      List.from(snapshot.data!);
                  sortedMedicationInventory.sort((a, b) => a.med_name
                      .toLowerCase()
                      .compareTo(b.med_name.toLowerCase()));

                  // Build rows for the table using sorted data
                  List<List<String>> rows =
                      sortedMedicationInventory.map((med) {
                    return [med.med_name, med.med_quan.toString()];
                  }).toList();

                  return MyTable(columns: columns, rows: rows);
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomActionButton(
                  onPressed: () => showTestDialog(context),
                  buttonText: 'Print',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showTestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          buttonText: 'Print',
          onSignOut: () {},
          message: 'Do you want to Print?',
        );
      },
    );
  }
}

