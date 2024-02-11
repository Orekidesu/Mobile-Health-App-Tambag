import 'package:Tambag_Health_App/Screen/Masterlist.dart';

class Inventory_info {
  final Future<List<Map<String, dynamic>>> allMedicalInventory;
  final Future<List<Map<String, dynamic>>> medicationSummary;
  final String barangay;

  const Inventory_info({
    required this.allMedicalInventory,
    required this.medicationSummary,
    required this.barangay,
  });
}
