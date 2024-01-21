import 'package:flutter/material.dart';
import '../Screen/Masterlist.dart';
import '../Screen/addProfilePage.dart';
import '../constants/light_constants.dart';
import '../Custom_Widgets/CustomActionButton.dart';

class ProfileAndMasterlistRow extends StatelessWidget {
  final String selectedBrgy;
  const ProfileAndMasterlistRow({super.key, required this.selectedBrgy});

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
        CustomActionButton(
          foreground: periwinkleColor,
          background: Colors.white,
          borderColor: periwinkleColor,
          borderWidth: 2,
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Masterlist(),
            ),
          );
          },
          buttonText: "MEDICATION\nMASTERLIST",
          fontWeight: FontWeight.bold,

        ),
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
              builder: (context) => AddProfilePage(selectedBrgy: selectedBrgy,),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddProfileLabels() {
    return const Column(
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
}
