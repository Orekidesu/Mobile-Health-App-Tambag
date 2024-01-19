  // ignore_for_file: file_names, depend_on_referenced_packages
  import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
  import '../Custom_Widgets/Custom_Footer.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import '../Custom_Widgets/Custom_Appbar.dart';
  import '../constants/light_constants.dart';
  import '../Custom_Widgets/Dashboard_List_Firebase.dart';
  import '../functions/custom_functions.dart';

  class Patient {
    final String id;
    final String name;
    final String address;
    Patient({required this.id, required this.name, required this.address});
  }

  class Dashboard extends StatefulWidget {
    const Dashboard({super.key});

    @override
    // ignore: library_private_types_in_public_api
    _DashboardState createState() => _DashboardState();
  }


  class _DashboardState extends State<Dashboard> {
    int tappedCardIndex = -1;
    bool isSnackbarVisible = false;
    String patientId = '';
    String? baranggay; // Added variable to store Baranggay field

    late CollectionReference patientsCollection;

    @override
    void initState() {
      super.initState();
      if (baranggay == null) {
        fetchBaranggay();
      }
    }


  Future<void> fetchBaranggay() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get the user's ID
        String userId = user.uid;

        // Reference to Firestore collection
        patientsCollection = FirebaseFirestore.instance.collection('admin');

        // Query Firestore to get the document for the current user
        DocumentSnapshot<Object?> snapshot =
            await patientsCollection.doc(userId).get();

        // Get the Baranggay field value
        String userBaranggay = snapshot.get('Baranggay');

        // Update the state with the Baranggay field value
        setState(() {
          baranggay = userBaranggay;
        });
      }
    } catch (e) {
      // Handle errors here
      showErrorNotification('Error fetching Baranggay: $e');
    }
  }

   @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Custom_Appbar(
                Baranggay: 'Baranggay ${baranggay ?? ''}',
                Apptitle: "TAMBAG",
                icon: Icons.logout,
                hasbackIcon: false,
                iconColor: Colors.white,
                hasRightIcon: true,
                Distination: () => showSignOutDialog(context),
                hasMessageIcon: true,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: baranggay == null
                    ? const Center(child: CircularProgressIndicator()) // Show a loading indicator
                    : DashboardListFirebase(
                        Baranggay: baranggay!,
                      ),
              ),
              const SizedBox(height: 20),
              const ProfileAndMasterlistRow(),
            ],
          ),
        ),
      ),
    ),
  );
}
}
