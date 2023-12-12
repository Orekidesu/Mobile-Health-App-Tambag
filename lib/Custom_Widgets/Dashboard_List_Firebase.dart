// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Screen/Dashboard.dart';
import '../Firebase_Query/Firebase_Functions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'PatientCard.dart';

class Dashboard_List_Firebase extends StatefulWidget {
  const Dashboard_List_Firebase({super.key});

  @override
  _Dashboard_List_FirebaseState createState() =>
      _Dashboard_List_FirebaseState();
}

class _Dashboard_List_FirebaseState extends State<Dashboard_List_Firebase> {
  int tappedCardIndex = -1; // Initialize with an invalid index

 void doNothing(BuildContext context) {
    setState(() {
      // Do nothing with the context
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Patient>>(
      future: getAllPatients(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const CupertinoActivityIndicator();
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Patient patient = snapshot.data![index];
              int count = index + 1;
              return Container(
                margin: const EdgeInsets.all(4.0),
                child: Slidable(
                    // Specify a key if the Slidable is dismissible.
                  key: const ValueKey(0),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                
                    // A pane can dismiss the Slidable.
                    dismissible: DismissiblePane(onDismissed: () {}),
                
                    // All actions are defined in the children parameter.
                    children: [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        onPressed: doNothing,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: PatientCard(
                    patient: patient,
                    count: count,
                    index: index,
                    tappedCardIndex: tappedCardIndex,
                    onTap: () {
                      // Update the tapped card
                      setState(() {
                        tappedCardIndex = index;
                      });
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}


