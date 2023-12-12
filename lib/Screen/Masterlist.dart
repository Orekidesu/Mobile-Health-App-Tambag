import 'package:flutter/material.dart';
import '../Custom_Widgets/Custom_Appbar.dart';
import '../Custom_Widgets/Custom_Dialog.dart';
import '../constants/light_constants.dart';
import '../functions/custom_functions.dart';
import 'Dashboard.dart';
import '../Custom_Widgets/Cutom_table.dart';
import '../Custom_Widgets/CustomActionButton.dart';


class Masterlist extends StatefulWidget {
  const Masterlist({super.key});

  @override
  State<Masterlist> createState() => _MasterlistState();
}

class _MasterlistState extends State<Masterlist> {
  List<String> columns = ['Medication', 'Quantity'];
  List<List<String>> rows = [
    ['Amiodipine', '15', ],
    ['Losartan', '5', ],
    ['Metmorfin', '2', ],
    ['Novalin R FlexPen', '4', ],
  ];

  List<String> medInventoryColumns = ['Medication', 'Quantity'];
  List<List<String>> medInventoryRows = [
    ['Amiodipine', '3', ],
    ['Losartan', '6', ],
    ['Metmorfin', '1', ],
  ];

  void showTesttDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          buttonText: 'Print',
          onSignOut: () {
            
          },
          message: 'Do you want to Print?',
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
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
            const SizedBox(
              height: 25,
            ),
            const Text('CLIENT MEDICATION SUMMARY',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: periwinkleColor,
              fontSize: 20,
            ),),
            const Text(
                'Diri nga seksyon makita ang tanang\ntambal nga ginagamit sa mga geriatic\nclient ug ang kadaghanon nga\ngikinahanglan matag tambal.',
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  color: periwinkleColor,
                  fontSize: 15,
                ),
            ),
            const SizedBox(height: 25,),
            MyTable(columns: columns, rows: rows),
            const SizedBox(height: 25,),

            const Text('MEDICATION INVENTORY',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: periwinkleColor,
              fontSize: 20,
            ),),
            const Text(
                'Diri nga seksyon makita ang istak sa\ntambal.',
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  color: periwinkleColor,
                  fontSize: 15,
                ),
            ),
            const SizedBox(height: 10,),
            MyTable(columns: medInventoryColumns, rows: medInventoryRows),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomActionButton(onPressed: () => showTesttDialog, buttonText: 'Print'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
