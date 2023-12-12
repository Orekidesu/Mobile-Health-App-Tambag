// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Custom_Widgets/Custom_Appbar.dart';
import '../Custom_Widgets/Custom_Dialog.dart';
import '../Firebase_Query/Firebase_Functions.dart';
import '../constants/light_constants.dart';
import '../functions/custom_functions.dart';
import 'Dashboard.dart';
import '../Custom_Widgets/Cutom_table.dart';
import '../Custom_Widgets/CustomActionButton.dart';

class medication_inventory {
  final String med_name;
  final int med_quan;
  medication_inventory({required this.med_name, required this.med_quan});
}

class Masterlist extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Masterlist({Key? key});

  @override
  State<Masterlist> createState() => _MasterlistState();
}

class _MasterlistState extends State<Masterlist> {
  List<String> columns = ['Medication', 'Quantity'];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<medication_inventory>>(
      future: getAllMedicalInventory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CupertinoActivityIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No medication inventory available.')),
          );
        } else {
          // Sort the medication inventory data alphabetically based on med_name
          List<medication_inventory> sortedMedicationInventory =
              List.from(snapshot.data!);
          sortedMedicationInventory.sort((a, b) =>
              a.med_name.toLowerCase().compareTo(b.med_name.toLowerCase()));

          // Build rows for the table using sorted data
          List<List<String>> rows = sortedMedicationInventory.map((med) {
            return [med.med_name, med.med_quan.toString()];
          }).toList();

          return Scaffold(
            body: Container(
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
                    hasRightIcon: false,
                    iconColor: Colors.white,
                    DistinationBack: () => goToPage(context, const Dashboard()),
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
                  const SizedBox(height: 25),
                  MyTable(columns: columns, rows: rows),
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
                  MyTable(columns: columns, rows: rows),
                  const SizedBox(height: 10),
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
      },
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