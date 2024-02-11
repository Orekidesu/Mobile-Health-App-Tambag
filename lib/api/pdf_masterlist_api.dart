import 'dart:io';
import 'package:Tambag_Health_App/Screen/Masterlist.dart';
import 'package:Tambag_Health_App/api/pdf_api.dart';
import 'package:Tambag_Health_App/model/inventory_info.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfMasterListApi {
  List<pw.TableRow> _buildTableRows(List<Map<String, dynamic>> dataList,
      List<String> columnNames, List<String> keyNames) {
    return [
      pw.TableRow(
        children: columnNames.map((columnName) {
          return pw.Padding(
            padding: pw.EdgeInsets.all(4.0),
            child: pw.Center(
              child: pw.Text(
                columnName,
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 10.0),
              ),
            ),
          );
        }).toList(),
      ),
      for (var data in dataList)
        pw.TableRow(
          children: keyNames.map((keyName) {
            var value = data[keyName];
            var textValue = value is int ? value.toString() : value;
            return pw.Padding(
              padding: pw.EdgeInsets.all(4.0),
              child: pw.Text(textValue ?? 'N/A',
                  style: pw.TextStyle(fontSize: 10.0)),
            );
          }).toList(),
        ),
    ];
  }

  Future<File> generate(Inventory_info inventory_info) async {
    final pdf = Document();

    final header = await buildHeader(inventory_info);
    final medicationSummaryTable =
        await buildMedicationSummaryTable(inventory_info);
    final inventoryTable = await buildInventoryTable(inventory_info);
    pdf.addPage(
      MultiPage(
        build: (Context context) => [
          header,
          medicationSummaryTable!,
        ],
      ),
    );

    pdf.addPage(
      MultiPage(
        build: (Context context) => [
          inventoryTable!,
        ],
      ),
    );

    final barangay = await inventory_info.barangay;
    return PdfApi.saveDocument(
        name: 'Brgy ${barangay} Medication Masterlist.pdf', pdf: pdf);
  }

  // ====================HEADER AREA ==================== //
  Future<Widget> buildHeader(Inventory_info inventoryInfo) async {
    final barangay = await inventoryInfo.barangay;
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
        // pw.SizedBox(
        //   height: 20.0,
        // ),
        pw.Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(children: [
                    pw.Text(
                      'MEDICATION MASTERLIST',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Barangay ${barangay}',
                      style: pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ])
                ])),
        pw.SizedBox(height: 10.0),
      ],
    );
  }

  // ====================MEDICATION SUMMARY AREA ==================== //
  Future<Widget?> buildMedicationSummaryTable(
      Inventory_info inventoryInfo) async {
    final medicalSummary = await inventoryInfo.medicationSummary;

    return pw.Container(
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('CLIENT MEDICATION SUMMARY',
              style:
                  pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
          pw.Text(
              '   Dinhi makita ang tanan nga tambal nga gigamit sa mga “geriatric client” ug ang gidaghanun nga gikinahanglan para sa matag tambal',
              style: pw.TextStyle(
                fontSize: 10,
              )),
          pw.SizedBox(height: 15),
          pw.Container(
            child: pw.Table(
              border: pw.TableBorder.all(),
              children: _buildTableRows(medicalSummary,
                  ['MEDICATION', 'QUANTITY'], ['med_name', 'med_quan']),
            ),
          ),
          pw.SizedBox(height: 20.0),
        ],
      ),
    );
  }

  // ====================MEDICATION INVENTORY AREA ==================== //
  Future<Widget?> buildInventoryTable(Inventory_info inventoryInfo) async {
    final inventory = await inventoryInfo.allMedicalInventory;

    return pw.Container(
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('MEDICATION INVENTORY',
              style:
                  pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
          pw.Text(
              '   Dri makita ang mga pondo nga tambal sa Barangay Health Station',
              style: pw.TextStyle(
                fontSize: 10,
              )),
          pw.SizedBox(height: 15),
          pw.Container(
            child: pw.Table(
              border: pw.TableBorder.all(),
              children: _buildTableRows(inventory, ['MEDICATION', 'QUANTITY'],
                  ['med_name', 'med_quan']),
            ),
          ),
          pw.SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
