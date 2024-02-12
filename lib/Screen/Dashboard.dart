// ignore_for_file: file_names, depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Custom_Widgets/Custom_Footer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Custom_Widgets/Custom_Appbar_Dashboard.dart';
import '../constants/light_constants.dart';
import '../Custom_Widgets/Dashboard_List_Firebase.dart';
import '../functions/custom_functions.dart';
import 'SmsSender.dart';

class Patient {
  final String id;
  final String name;
  final String address;
  final String addedDate;
  Patient(
      {required this.id,
      required this.name,
      required this.address,
      required this.addedDate});
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
  String? baranggay;
  late CollectionReference patientsCollection;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    if (baranggay == null) {
      fetchBaranggay();
    }
  }

  @override
  void dispose() {
    _isMounted = false; // Set to false when the widget is disposed
    super.dispose();
  }

  Future<void> fetchBaranggay() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;
        patientsCollection = FirebaseFirestore.instance.collection('admin');
        DocumentSnapshot<Object?> snapshot =
            await patientsCollection.doc(userId).get();
        String userBaranggay = snapshot.get('Baranggay');

        if (_isMounted) {
          setState(() {
            baranggay = userBaranggay;
          });
        }
      }
    } catch (e) {
      if (_isMounted) {
        showErrorNotification('Error fetching Baranggay: $e');
      }
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
                  Baranggay: 'Baranggay ${baranggay ?? 'Loading...'}',
                  selectedBrgy: '$baranggay',
                  Apptitle: "TAMBAG",
                  icon: Icons.logout,
                  hasbackIcon: false,
                  iconColor: Colors.white,
                  hasRightIcon: true,
                  Distination: baranggay == null
                      ? null
                      : () => showSignOutDialog(context),
                  MessagePage: baranggay == null
                      ? null
                      : () => goToPage(
                          context,
                          smsSender(
                            selectedBrgy: baranggay ?? '',
                          )),
                  hasMessageIcon: true,
                ),
                const Divider(),
                Expanded(
                  child: baranggay == null
                      ? const Center(child: CupertinoActivityIndicator())
                      : DashboardListFirebase(
                          Baranggay: baranggay ?? '',
                        ),
                ),
                const Divider(),
                ProfileAndMasterlistRow(
                  selectedBrgy: baranggay ?? '',
                  Barangay: baranggay,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
