import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_health_app_tambag/Screen/Dashboard.dart';
import 'package:mobile_health_app_tambag/custom_widgets/text_widget_info.dart';

class Tracker extends StatefulWidget {
  final String patientId;
  const Tracker({Key? key, required this.patientId}) : super(key: key);

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  static const Color backgroundColor = Color.fromRGBO(245, 248, 255, 1.0);
  static const Color periwinkleColor = Color.fromARGB(255, 103, 103, 186);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: periwinkleColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Dashboard(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: CustomTextWidget(
                        text1: 'TRACKER',
                        text2: '',
                      ))
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16, 10.0, 16.0, 0.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(text1: 'NAME:', text2: 'OREKI HOUTAROU'),
                      CustomTextWidget(text1: 'AGE:', text2: '22'),
                      CustomTextWidget(
                          text1: 'ADDRESS:',
                          text2: 'PUROK 5,BARANGAY GUADALUPE, BAYBAY '),
                      CustomTextWidget(
                          text1: 'PHYSICIAN:', text2: 'DR. STRANGE'),
                      CustomTextWidget(
                          text1: 'CONTACT NO:', text2: '09881242331'),
                    ],
                  ),
                ),
              ),

              // LIST MEDICATION //
              Expanded(
                flex: 2,
                child: Container(
                  height: 300,
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      constraints: BoxConstraints.expand(),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(FontAwesomeIcons.pills),
                                    SizedBox(
                                      width: 16.0,
                                    ),
                                    Text(
                                      'LUNES',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              255, 103, 103, 186)),
                                    ),
                                  ],
                                )),
                            Expanded(
                              flex: 8,
                              child: ListView(
                                children: [
                                  MedicationTile(
                                      medicationName: 'AMLODIPINE',
                                      text: '50mg'),
                                  MedicationTile(
                                      medicationName: 'LOSARTAN',
                                      text: '500mg'),
                                  MedicationTile(
                                      medicationName: 'METROPOLOL',
                                      text: '5mg'),
                                  MedicationTile(
                                      medicationName: 'PARACETAMOL',
                                      text: '10mg'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(top: 16.0),
                  margin: EdgeInsets.only(bottom: 25.0),
                  height: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: periwinkleColor,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Reminders',
                                fillColor: backgroundColor,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: periwinkleColor),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Contraindications',
                                fillColor: backgroundColor,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: periwinkleColor),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Diet',
                                fillColor: backgroundColor,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: periwinkleColor),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'PRINT',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 103, 103, 186)),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class MedicationTile extends StatelessWidget {
  final String text;
  final String medicationName;

  MedicationTile({
    required this.medicationName,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        medicationName,
        style: TextStyle(
          color: Color.fromARGB(255, 103, 103, 186),
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        text,
        style: TextStyle(
          color: Color.fromARGB(255, 103, 103, 186),
        ),
      ),
    );
  }
}
