import 'package:Tambag_Health_App/Screen/Masterlist.dart';

class Inventory_info {
  final Future<List<medication_inventory>> allMedicalInventoryFuture;
  final Future<Map<String, int>> medicationQuantitiesFuture;
  final String barangay;

  const Inventory_info({
    required this.allMedicalInventoryFuture,
    required this.medicationQuantitiesFuture,
    required this.barangay,
  });
}
