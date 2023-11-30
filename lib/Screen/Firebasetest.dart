import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Patient {
  final String id;
  final String name;
  final DateTime dateOfBirth;

  Patient({required this.id, required this.name, required this.dateOfBirth});
}

class FirebaseTest extends StatefulWidget {
  @override
  _FirebaseTestState createState() => _FirebaseTestState();
}

class _FirebaseTestState extends State<FirebaseTest> {
  CollectionReference patients = FirebaseFirestore.instance.collection('patients');

  Future<void> addPatient(String name, DateTime dateOfBirth) async {
    await patients.add({
      'name': name,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
    });
  }

  Future<List<Patient>> getAllPatients() async {
    QuerySnapshot querySnapshot = await patients.get();

    return querySnapshot.docs.map((DocumentSnapshot document) {
      return Patient(
        id: document.id,
        name: document['name'],
        dateOfBirth: (document['dateOfBirth'] as Timestamp).toDate(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Dashboard'),
      ),
      body: FutureBuilder<List<Patient>>(
        future: getAllPatients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No patients available.');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Patient patient = snapshot.data![index];
                return ListTile(
                  title: Text('Patient ${index + 1}'),
                  subtitle: Text('Name: ${patient.name}\nDOB: ${patient.dateOfBirth}'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Example: Add a new patient
          addPatient('John Doe', DateTime(1990, 1, 1));
          setState(() {}); // Refresh the UI to reflect the new data (you might want to use a state management solution)
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FirebaseTest(),
  ));
}
