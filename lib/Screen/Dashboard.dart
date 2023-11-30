import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:mobile_health_app_tambag/Screen/addProfilePage.dart';
import 'Masterlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Login.dart';
import 'Follow_up.dart';

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
  //Constants Color
  static const Color backgroundColor = Color.fromRGBO(245, 248, 255, 1.0);
  static const Color periwinkleColor = Color.fromARGB(255, 103, 103, 186);
  static const Color rose = Color.fromRGBO(230, 192, 201, 1.0);
  static const Color lightyellow = Color.fromRGBO(255, 229, 167, 1.0);
  static const Color lightblue = Color.fromRGBO(167, 215, 246, 1.0);
  static const LinearGradient periwinkleGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 103, 103, 186),
      Color.fromARGB(255, 103, 103, 186)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  int tappedCardIndex = -1;
  bool isSnackbarVisible = false;
  String patientId = '';


  late CollectionReference patientsCollection;

  @override
  void initState() {
    super.initState();
    patientsCollection = FirebaseFirestore.instance.collection('patients');
  }

  void signout() {
    Fluttertoast.showToast(
      msg: 'Signout Successfully',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: periwinkleColor,
      textColor: Colors.white,
      fontSize: 16.0,
      webPosition: "center",
      webBgColor: "$periwinkleGradient",
    );
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const Login(), // Replace with your login page widget
      ),
    );
  }

  void showErrorNotification(String? errorMessage) {
    Fluttertoast.showToast(
        msg: 'Error: ${errorMessage ?? "Unknown error"}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: periwinkleColor,
        textColor: Colors.white,
        fontSize: 16.0,
        webPosition: "center",
        webBgColor: "$periwinkleGradient");
  }

  // Add this function inside your _LoginState class
  void showSignOutSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Are you sure you want to sign out?'),
        duration: const Duration(minutes: 5),
        behavior: SnackBarBehavior.floating, // Make the SnackBar taller
        shape: RoundedRectangleBorder(
          // Customize the shape
          borderRadius: BorderRadius.circular(15.0),
        ),
        action: SnackBarAction(
          label: 'Sign Out',
          onPressed: () {
            //Signout to
            FirebaseAuth.instance.signOut();
            signout();
          },
        ),
      ),
    );
  }

  //Function to return all patients
  Future<List<Patient>> getAllPatients() async {
    QuerySnapshot querySnapshot = await patientsCollection.get();
    return querySnapshot.docs.map((DocumentSnapshot document) {
      return Patient(
        id: document.id,
        name: document['name'],
      );
    }).toList();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TAMBAG',
                          style: TextStyle(
                            color: periwinkleColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Baranggay Guadalupe',
                          style: TextStyle(
                            color: periwinkleColor,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: periwinkleColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.logout),
                      color: Colors.white,
                      onPressed: () {
                        // Show the sign-out confirmation dialog
                        showSignOutSnackbar();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Patient>>(
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
                          return InkWell(
                            onTap: () {
                              // Update the tapped card
                              setState(() {
                                tappedCardIndex = index;
                              });
                            },
                            child: Card(
                              elevation: 0,
                              color: tappedCardIndex == index
                                  ? periwinkleColor
                                  : backgroundColor,
                              margin: const EdgeInsets.all(8.0),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: periwinkleColor, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(
                                  "PATIENT $count",
                                  style: TextStyle(
                                    color: tappedCardIndex == index
                                        ? Colors.white
                                        : periwinkleColor,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: ${patient.name}',
                                      style: TextStyle(
                                        color: tappedCardIndex == index
                                            ? Colors.white
                                            : periwinkleColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: rose,
                                          radius: 20,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Show a Snackbar when the first button is clicked
                                              if (!isSnackbarVisible) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'Button 1 Clicked. Index: $index'),
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                        onVisible: () {
                                                          // Set the flag to true when the Snackbar is visible
                                                          setState(() {
                                                            isSnackbarVisible =
                                                                true;
                                                          });
                                                        },
                                                      ),
                                                    )
                                                    .closed
                                                    .then((SnackBarClosedReason
                                                        reason) {
                                                  // Set the flag to false when the Snackbar is closed
                                                  setState(() {
                                                    isSnackbarVisible = false;
                                                  });
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(0),
                                              shape: const CircleBorder(),
                                              backgroundColor: rose,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Icon(
                                                Icons.local_hospital),
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
                                            
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(0),
                                              shape: const CircleBorder(),
                                              backgroundColor: lightblue,
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Icon(
                                                Icons.calendar_month),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: periwinkleColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                      onPressed: () {
                        // Navigate to the add profile page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddProfilePage(), // Replace with your login page widget
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Text(
                          'ADD',
                          style: TextStyle(
                            color: periwinkleColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Text(
                          'PROFILE',
                          style: TextStyle(
                            color: periwinkleColor,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Masterlist'),
                            content: const Text('Redirected to Masterlist.'),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Masterlist(),
                                    ),
                                  );
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: const BorderSide(
                        color: periwinkleColor,
                        width: 1.0,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: SizedBox(
                        width: 100,
                        child: Text(
                          'MEDICATION\nMASTERLIST',
                          textAlign: TextAlign
                              .center, // Center the text within the container
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: periwinkleColor,
                            height: 1.3,
                          ),
                        ),
                      ),
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
