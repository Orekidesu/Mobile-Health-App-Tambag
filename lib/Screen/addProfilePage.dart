import 'package:flutter/material.dart';
import 'package:mobile_health_app_tambag/Screen/Dashboard.dart';

class AddProfilePage extends StatefulWidget {
  @override
  _AddProfilePageState createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController medicationController = TextEditingController();

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _appBar(context),
            const SizedBox(height: 20),
            _nameTextField(),
            _ageTextField(),
            _addressTextField(),
            _medicationTextField(),
          ],
        ),
      )),
    );
  }

  Padding _medicationTextField() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Medication:',
            style: TextStyle(
              color: periwinkleColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            constraints: const BoxConstraints(
              minWidth: 100.0, // Minimum width
              maxWidth: 400.0, // Maximum width
              minHeight: 100.0, // Minimum height
              maxHeight: 300.0, // Maximum height
            ),
            child: TextField(
              controller: medicationController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: periwinkleColor,
                    width: 4,
                  ),
                ),
              ),
              // Additional properties for the TextField can be added here
            ),
          ),
        ],
      ),
    );
  }

  Padding _addressTextField() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Address:',
            style: TextStyle(
              color: periwinkleColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: addressController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the radius as needed
                borderSide: const BorderSide(
                  color: periwinkleColor, // Set the border color
                  width: 4,
                ),
              ),
            ),
            // Additional properties for the TextField can be added here
          ),
        ],
      ),
    );
  }

  Padding _ageTextField() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Age:',
            style: TextStyle(
              color: periwinkleColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: ageController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the radius as needed
                borderSide: const BorderSide(
                  color: periwinkleColor, // Set the border color
                  width: 4,
                ),
              ),
            ),
            // Additional properties for the TextField can be added here
          ),
        ],
      ),
    );
  }

  Padding _nameTextField() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Name:',
            style: TextStyle(
              color: periwinkleColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the radius as needed
                borderSide: const BorderSide(
                  color: periwinkleColor, // Set the border color
                  width: 4,
                ),
              ),
            ),
            // Additional properties for the TextField can be added here
          ),
        ],
      ),
    );
  }

  Row _appBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: periwinkleColor,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                // Navigate to the add profile page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const Dashboard(), // Replace with your login page widget
                  ),
                );
              },
            ),
          ),
        ),
        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ADD PROFILE',
                style: TextStyle(
                  color: periwinkleColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
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
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
