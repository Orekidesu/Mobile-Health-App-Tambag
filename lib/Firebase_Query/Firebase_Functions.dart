  //Function to return all patients
import 'package:Tambag/Screen/Masterlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screen/Dashboard.dart';

CollectionReference patientsCollection =FirebaseFirestore.instance.collection('patients');
CollectionReference medicationInventoryCollection =FirebaseFirestore.instance.collection('medication_inventory');

Future<List<Patient>> getAllPatients() async {
    QuerySnapshot querySnapshot = await patientsCollection.get();
    return querySnapshot.docs.map((DocumentSnapshot document) {
      return Patient(
        id: document['id'],
        name: document['name'],
      );
    }).toList();
  }

Future<List<medication_inventory>> getAllMedicalInventory() async {
    QuerySnapshot querySnapshot = await medicationInventoryCollection.get();
    return querySnapshot.docs.map((DocumentSnapshot document) {
      return medication_inventory(
        med_name: document['med_name'],
        med_quan: document['med_quan'],
      );
    }).toList();
  }

