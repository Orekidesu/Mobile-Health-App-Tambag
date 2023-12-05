import 'package:flutter/material.dart';
import '../Screen/Masterlist.dart';
import '../Screen/addProfilePage.dart';
import '../constants/light_constants.dart';

class ProfileAndMasterlistRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAddProfileButton(context),
        const SizedBox(width: 10),
        _buildAddProfileLabels(),
        const SizedBox(width: 20),
        _buildMedicationMasterlistButton(context),
      ],
    );
  }

  Widget _buildAddProfileButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: periwinkleColor, // Change to your desired color
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: IconButton(
        icon: const Icon(Icons.add),
        color: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProfilePage(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddProfileLabels() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          child: Text(
            'ADD',
            style: TextStyle(
              color: periwinkleColor, // Change to your desired color
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
              color: periwinkleColor, // Change to your desired color
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationMasterlistButton(BuildContext context) {
    return ElevatedButton(
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
          color: periwinkleColor, // Change to your desired color
          width: 1.0,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(3.0),
        child: SizedBox(
          width: 100,
          child: Text(
            'MEDICATION\nMASTERLIST',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: periwinkleColor, // Change to your desired color
              height: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}
