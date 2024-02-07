import 'dart:io';
import 'package:Tambag_Health_App/Screen/TrackerPDF.dart';
import 'package:Tambag_Health_App/api/pdf_api.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import '../model/patient_info.dart';

class CustomBoldText extends pw.StatelessWidget {
  final String label;
  final String boldText;

  CustomBoldText({required this.label, required this.boldText});

  @override
  pw.Widget build(pw.Context context) {
    return pw.RichText(
      text: pw.TextSpan(
        text: '$label: ',
        style: pw.TextStyle(fontSize: 12),
        children: <pw.TextSpan>[
          pw.TextSpan(
            text: boldText,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class PdfTrackerApi {
  Future<File> generate(PatientInfo patientInfo) async {
    final pdf = Document();

    final header = await buildHeader(patientInfo);
    final table = await buildTable(patientInfo);

    pdf.addPage(
      MultiPage(
        build: (Context context) => [
          header,
          table!,
        ],
      ),
    );

    final patientData = await patientInfo.patientData;
    return PdfApi.saveDocument(name: '${patientData['name']}.pdf', pdf: pdf);
  }

  Future<Widget> buildHeader(PatientInfo patientInfo) async {
    final patientData = await patientInfo.patientData;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
          child: pw.Row(
            children: [
              pw.Image(
                pw.MemoryImage(
                  (await rootBundle.load('assets/tambag.png'))
                      .buffer
                      .asUint8List(),
                ),
                width: 90.0,
                height: 100.0,
                fit: pw.BoxFit.cover,
              ),
              pw.SizedBox(
                width: 10.0,
              ),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    height: 10.0,
                  ),
                  pw.Text(
                    'TAMBAG',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('Telehealth And Medications-',
                      style: pw.TextStyle(
                        fontSize: 8,
                      )),
                  pw.Text('Barangay Assistance to Geriatic Clients',
                      style: pw.TextStyle(
                        fontSize: 8,
                      )),
                ],
              ),
            ],
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'PATIENT PROFILE',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(
                height: 10.0,
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  CustomBoldText(
                      label: 'Pangan:', boldText: patientData['name']),
                  CustomBoldText(label: 'Edad:', boldText: patientData['age']),
                  CustomBoldText(
                      label: 'Puy-anan:', boldText: patientData['address']),
                  CustomBoldText(
                      label: 'Doktor:', boldText: patientData['physician']),
                  CustomBoldText(
                      label: 'Numero sa Selpon:',
                      boldText: patientData['contact_number']),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<Widget?> buildTable(PatientInfo patientInfo) async {
    final processedMedications = await patientInfo.processedMedications;
    int rowCounter = 0;
    return pw.Container(
        child: pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          height: 20,
        ),
        pw.Center(
            child: pw.Text('MGA TAMBAL',
                style: pw.TextStyle(
                    fontSize: 12, fontWeight: pw.FontWeight.bold))),
        pw.SizedBox(
          height: 20,
        ),
        pw.Container(
          child: pw.Table(
            columnWidths: {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(1),
              4: pw.FlexColumnWidth(1),
              5: pw.FlexColumnWidth(1),
              6: pw.FlexColumnWidth(1),
              7: pw.FlexColumnWidth(1),
              8: pw.FlexColumnWidth(1),
              9: pw.FlexColumnWidth(1),
            },
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  pw.Center(
                      child: pw.Text('ORAS',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Center(
                      child: pw.Text('TUKMA',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  for (var day in [
                    'LUNES',
                    'MARTES',
                    'MIYERKULES',
                    'HUWEBES',
                    'BIYERNES',
                    'SABADO',
                    'DOMINGO'
                  ])
                    pw.Center(
                        child: pw.Text(day,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                ],
              ),
              for (var timeSlot in ['Buntag', 'Udto', 'Gabie'])
                for (var tukma in ['Sa dili pa mukaon', 'Human ug kaon'])
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(4.0),
                        child: pw.Text(
                            tukma == 'Sa dili pa mukaon' ? timeSlot : ''),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(4.0),
                        child: pw.Text(tukma),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(4.0),
                        child: pw.Center(
                            child: pw.Text(processedMedications[timeSlot]
                                    ?[tukma] ??
                                'N/A')),
                      ),
                    ],
                  ),
            ],
          ),
        )
      ],
    ));
  }
}
