// ignore_for_file: camel_case_types, file_names

import 'package:Tambag_Health_App/Custom_Widgets/Custom_dropdown.dart';
import 'package:Tambag_Health_App/constants/light_constants.dart';
import 'package:flutter/material.dart';

import '../Custom_Widgets/Custom_Appbar.dart';
import '../functions/custom_functions.dart';
import 'Dashboard.dart';

class smsSender extends StatefulWidget {
  const smsSender({super.key});

  @override
  State<smsSender> createState() => _smsSenderState();
}

String selectedBrgy = 'Guadalupe';
List<String> Brgy = ['Guadalupe', 'Patag', 'Gabas'];

class _smsSenderState extends State<smsSender> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Custom_Appbar(
                Baranggay: "Announcement",
                Apptitle: "PATIENT",
                hasbackIcon: true,
                hasRightIcon: false,
                iconColor: Colors.white,
                DistinationBack: () => goToPage(context, const Dashboard()),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                                  16.0, 10.0, 16.0, 0.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('To:',style: TextStyle(color: periwinkleColor),),
                          SizedBox(width: 15,),
                          Expanded(
                            child: CustomDropdown(
                                        items: Brgy,
                                        value: selectedBrgy,
                                        onChanged: (String newValue) {
                                          setState(() {
                                            selectedBrgy = newValue;
                                          });
                                        },
                                      ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))


            ],
          ),
        ),
      ),
    );
  }
}