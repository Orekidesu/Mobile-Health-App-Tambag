  //Function to return all patients
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_health_app_tambag/Screen/Dashboard.dart';

late CollectionReference patientsCollection =FirebaseFirestore.instance.collection('patients');

Future<List<Patient>> getAllPatients() async {
    QuerySnapshot querySnapshot = await patientsCollection.get();
    return querySnapshot.docs.map((DocumentSnapshot document) {
      return Patient(
        id: document.id,
        name: document['name'],
      );
    }).toList();
  }



