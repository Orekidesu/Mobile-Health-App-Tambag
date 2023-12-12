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

Future<Map<String, int>> getMedicationQuantities() async {
  final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collectionGroup('medications').get();

  final Map<String, int> medicationQuantities = {};

  for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
    final String medName = doc.data()['med_name'] as String;
    final int medQuan = doc.data()['med_quan'] as int;

    if (medicationQuantities.containsKey(medName)) {
      medicationQuantities[medName] = medicationQuantities[medName]! + medQuan;
    } else {
      medicationQuantities[medName] = medQuan;
    }
  }

  return medicationQuantities;
}

