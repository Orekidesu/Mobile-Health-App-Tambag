import 'package:flutter/material.dart';
import 'Masterlist.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  static const Color backgroundColor = Color.fromRGBO(245, 248, 255, 1.0);
  static const Color periwinkleColor = Color.fromARGB(255, 103, 103, 186);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor, // Set the background color
        padding: const EdgeInsets.all(16.0), // Adjust padding as needed
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Container(
                          height: 25.0,
                          child: const Text(
                            'TAMBAG',
                            style: TextStyle(
                              color: periwinkleColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              decoration: TextDecoration.none,
                              fontFamily: 'Arial',
                            ),
                            textAlign: TextAlign.left, // Align text to the left
                          ),
                        ),
                        Container(
                          height: 25.0,
                          child: const Text(
                            'Baranggay Guadalupe',
                            style: TextStyle(
                              color: periwinkleColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              decoration: TextDecoration.none,
                              fontFamily: 'Arial',
                            ),
                            textAlign: TextAlign.left, // Align text to the left
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
                      icon: const Icon(Icons.more_vert),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Add any additional logic as needed
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity, // Set the width to match the column
                    height: 400.0, // Set the desired height
                    color: Colors.blue, // Set the background color
                    child:
                        SizedBox(), // You can add child widgets inside the SizedBox if needed
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: periwinkleColor, // Set the background color
                      borderRadius:
                          BorderRadius.circular(30.0), // Set the border radius
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      color: Colors.white, // Set the icon color
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Add any additional logic as needed
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20.0, // Set the desired height
                        child: const Text(
                          'ADD',
                          style: TextStyle(
                            color: periwinkleColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                            fontFamily: 'Arial',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        height: 20.0, // Set the desired height
                        child: const Text(
                          'PROFILE',
                          style: TextStyle(
                            color: periwinkleColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.none,
                            fontFamily: 'Arial',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 150.0, // Set the desired width
                    height: 50.0, // Set the desired height
                    child: ElevatedButton(
                      onPressed: () {
                        // Call the function and show a dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Masterlist'),
                              content: Text('Redirected to Masterlist.'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Masterlist(),
                                      ),
                                    );
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // Set the background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Set the border radius
                        ),
                        side: const BorderSide(
                          color:
                              periwinkleColor, // Set the border color to black
                          width: 1.0, // Set the border width to 1 logical pixel
                        ),
                      ),
                      child: const Text(
                        'Medication\nMasterlist',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Set the text to bold
                          color: periwinkleColor, // Set the font color
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
