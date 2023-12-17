  // ignore_for_file: file_names, depend_on_referenced_packages
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
    Patient({required this.id, required this.name});
  }

  class Dashboard extends StatefulWidget {
    const Dashboard({Key? key}) : super(key: key);

    @override
    // ignore: library_private_types_in_public_api
    _DashboardState createState() => _DashboardState();
  }

  class _DashboardState extends State<Dashboard> {
    int tappedCardIndex = -1;
    bool isSnackbarVisible = false;
    String patientId = '';

    late CollectionReference patientsCollection;
    @override
    void initState() {
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          color: backgroundColor,
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Custom_Appbar(
                  Baranggay: "Baranggay Guadalupe",
                  Apptitle: "TAMBAG",
                  icon: Icons.logout,
                  hasbackIcon: false,
                  iconColor: Colors.white,
                  hasRightIcon: true,
                  Distination: () => showSignOutDialog(context),
                ),
                const SizedBox(height: 10),
                const Expanded(
                  child: DashboardListFirebase(),
                ),
                const SizedBox(height: 20),
                const ProfileAndMasterlistRow(),
              ],
            ),
          ),
        ),
      );
    }
  }
