// ignore_for_file: camel_case_types, file_names, non_constant_identifier_names

import 'package:Tambag_Health_App/Custom_Widgets/Custom_dropdown.dart';
import 'package:Tambag_Health_App/constants/light_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Custom_Widgets/CustomActionButton.dart';
import '../Custom_Widgets/Custom_Appbar.dart';
import '../Custom_Widgets/Custom_TextField.dart';
import '../Firebase_Query/Firebase_Functions.dart';
import '../functions/custom_functions.dart';
import 'Dashboard.dart';

class smsSender extends StatefulWidget {
  final String selectedBrgy;
  const smsSender({super.key, required this.selectedBrgy});

  @override
  State<smsSender> createState() => _smsSenderState();
}

class _smsSenderState extends State<smsSender> {
  TextEditingController messageController = TextEditingController();
  List<String> Brgy = ['Guadalupe', 'Patag', 'Gabas'];
  bool isSending = false;

  @override
  void dispose() {
    // Dispose of the messageController when the widget is disposed
    messageController.dispose();
    super.dispose();
  }

  Future<List<String?>> getContactNumbersWithBaranggay() async {
    try {
      final QuerySnapshot querySnapshot = await patientsCollection
          .where("address", isEqualTo: widget.selectedBrgy)
          .get();

      List<String?> contactNumbers = [];

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;

          if (data.containsKey("address") &&
              data["address"] == widget.selectedBrgy &&
              data.containsKey("contact_number")) {
            String? contactNumber = data['contact_number'];
            contactNumbers.add(contactNumber);
          }
        }

        return contactNumbers;
      } else {
        return []; // or handle the case where there are no documents with the given Baranggay
      }
    } catch (e) {
      return []; // or handle the error
    }
  }

  void sendMessage() async {
    try {
      if (messageController.text.isEmpty) {
        showErrorNotification('Message is Empty');
        return;
      }

      setState(() {
        isSending = true;
      });

      List<String?> numbers = await getContactNumbersWithBaranggay();

      if (numbers.isEmpty) {
        showErrorNotification('No contact numbers available');
        return;
      }

      String commaSeparatedNumbers =
          numbers.where((number) => number != null).join(', ');

      await sendSMS(messageController.text, commaSeparatedNumbers);
    } catch (e) {
      // Handle exceptions appropriately
      showErrorNotification('Failed to send message');
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Custom_Appbar(
                Baranggay: "Announcement",
                Apptitle: "PATIENT",
                hasbackIcon: true,
                hasRightIcon: false,
                iconColor: Colors.white,
                DistinationBack: isSending
                    ? null
                    : () => goToPage(context, const Dashboard()),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'To:',
                            style: TextStyle(color: periwinkleColor),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: CustomDropdown(
                              items: Brgy,
                              isEnabled: false,
                              value: widget.selectedBrgy,
                              onChanged: (String newValue) {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: messageController,
                        labelText: 'Message:',
                        maxLines: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomActionButton(
                    custom_width: 320,
                    onPressed: () {
                      sendMessage();
                    },
                    buttonText: isSending ? 'Sending...' : 'Send',
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
