// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mobile_health_app_tambag/Screen/Tracker.dart';
import '../Screen/Dashboard.dart';
import '../Screen/Follow_up.dart';
import '../Screen/Patient_profile.dart';
import '../constants/light_constants.dart';
import '../Firebase_Query/Firebase_Functions.dart';

class Dashboard_List_Firebase extends StatefulWidget {
  const Dashboard_List_Firebase({super.key});

  @override
  _Dashboard_List_FirebaseState createState() => _Dashboard_List_FirebaseState();
}

class _Dashboard_List_FirebaseState extends State<Dashboard_List_Firebase> {
  int tappedCardIndex = -1; // Initialize with an invalid index

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Patient>>(
      future: getAllPatients(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No patients available.');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Patient patient = snapshot.data![index];
              int count = index + 1;
              return PatientCard(
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
              );
            },
          );
        }
      },
    );
  }
}

class PatientCard extends StatelessWidget {
  final Patient patient;
  final int count;
  final int index;
  final int tappedCardIndex;
  final VoidCallback onTap;

  const PatientCard({
    required this.patient,
    required this.count,
    required this.index,
    required this.tappedCardIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: tappedCardIndex == index ? periwinkleColor : backgroundColor,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: periwinkleColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            "PATIENT $count",
            style: TextStyle(
              color: tappedCardIndex == index ? Colors.white : periwinkleColor,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${patient.name}',
                style: TextStyle(
                  color:
                      tappedCardIndex == index ? Colors.white : periwinkleColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: rose,
                    radius: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Patient_Profile(patientId: patient.id),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        shape: const CircleBorder(),
                        backgroundColor: rose,
                        foregroundColor: Colors.white,
                      ),
                      child: const Icon(Icons.local_hospital),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: lightyellow,
                    radius: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Follow_up(
                              patientId: patient.id.toString(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        shape: const CircleBorder(),
                        backgroundColor: lightyellow,
                        foregroundColor: Colors.white,
                      ),
                      child: const Icon(Icons.people),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: lightblue,
                    radius: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Tracker(
                              patientId: patient.id.toString(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        shape: const CircleBorder(),
                        backgroundColor: lightblue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Icon(Icons.calendar_month),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
