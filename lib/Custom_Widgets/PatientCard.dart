import 'package:flutter/material.dart';
import '../Screen/Dashboard.dart';
import '../Screen/Follow_up.dart';
import '../Screen/Patient_profile.dart';
import '../Screen/Tracker.dart';
import '../constants/light_constants.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final int count;
  final int index;
  final int tappedCardIndex;
  final VoidCallback onTap;

  const PatientCard({super.key, 
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
              const SizedBox(height: 8,)
            ],
          ),
        ),
      ),
    );
  }
}