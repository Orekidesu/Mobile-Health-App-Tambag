// ignore_for_file: camel_case_types, library_private_types_in_public_api, use_build_context_synchronously, file_names

import '../functions/custom_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Screen/Dashboard.dart';
import '../Firebase_Query/Firebase_Functions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Custom_Dialog.dart';
import 'PatientCard.dart';

class DashboardListFirebase extends StatefulWidget {
  
  const DashboardListFirebase({super.key});

  @override
  _DashboardListFirebaseState createState() => _DashboardListFirebaseState();
}

class _DashboardListFirebaseState extends State<DashboardListFirebase> {
  int tappedCardIndex = -1;
  late Future<List<Patient>> patientData;

  @override
  void initState() {
    super.initState();
    setState(() {
      patientData = getAllPatients();
    });
  }


  @override
  void dispose() {
    // Cancel or dispose of asynchronous operations here
    super.dispose();
  }

  Future<void> deletePatient(String patientId) async {
  try {
    await deletePatientAndMedication(patientId);
    await deletePatientFromFollowUpHistoryCollection(patientId);

    // Refresh the patient list
    setState(() {
      patientData = getAllPatients();
    });

  } catch (error) {
    if (mounted) {
      // Handle error: Show a Snackbar or log the error.
      showErrorNotification('Error deleting patient: $error');
    }
  }
}


  void deleConfirmation(String id,BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          buttonText: 'Delete',
          onSignOut: () {
            deletePatient(id);
            Navigator.pop(context); // Assuming you have access to the 'context' variable
          },
          message: 'Are you sure to delete?',
        );
      },
    );
  }

  Future<void> deleteSubcollectionDocuments(String documentId, String subcollectionPath) async {
    final subcollectionRef = patientsCollection.doc(documentId).collection(subcollectionPath);
    final subcollectionSnapshot = await subcollectionRef.get();

    for (final doc in subcollectionSnapshot.docs) {
      await subcollectionRef.doc(doc.id).delete();
    }
  }


  Future<void> deleteSubcollection(String documentId, String subcollectionPath) async {
    await deleteSubcollectionDocuments(documentId, subcollectionPath);
    final documentRef = patientsCollection.doc(documentId);
    await documentRef.collection(subcollectionPath).doc().delete();
  }

  Future<void> deletePatientAndMedication(String patientId) async {
    try {
      // Delete patient document from the "patients" collection
      QuerySnapshot<Object?> rawPatientSnapshot = await patientsCollection.where('id', isEqualTo: patientId).get();

      QuerySnapshot<Map<String, dynamic>>? patientQuerySnapshot = rawPatientSnapshot as QuerySnapshot<Map<String, dynamic>>?;

      if (patientQuerySnapshot == null) {
        // Handle case where cast fails (data doesn't match expected type)
        showErrorNotification('Unexpected data format. Please contact support.');
        return;
      }

      // Delete the documents found in the query
      for (QueryDocumentSnapshot<Map<String, dynamic>> patientDoc in patientQuerySnapshot.docs) {
        // Delete the subcollection and its documents
        await deleteSubcollection(patientDoc.id, 'medications');
        // Delete the patient document
        await patientDoc.reference.delete();
      }
    } catch (error) {
      showErrorNotification('Error deleting patient and medication: $error');
      rethrow; // Re-throw the error after logging
    }
  }


  Future<void> deletePatientFromFollowUpHistoryCollection(String patientId) async {
    try {
      // Use where to find the document with the matching patientId
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('follow_up_history')
              .where('id', isEqualTo: patientId)
              .get();

      // Delete the documents found in the query
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (error) {
      showErrorNotification('Error deleting patient from follow_up_history collection: $error');
      rethrow; // Re-throw the error after logging
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Patient>>(
      future: patientData,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('No patient')],
                );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Patient patient = snapshot.data![index];
              int count = index + 1;
              return Container(
                margin: const EdgeInsets.all(4.0),
                child: Slidable(
                  key: ValueKey(index),
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        onPressed: (context) => deleConfirmation(patient.id,context),
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
                      if (mounted) {
                        setState(() {
                          tappedCardIndex = index;
                        });
                      }
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
