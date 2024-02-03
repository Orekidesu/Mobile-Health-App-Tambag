class PatientInfo {
  final Future<Map<String, dynamic>> patientData;
  final Future<List<Map<String, dynamic>>> medications;
  final Future<List<Map<String, dynamic>>> medicationInteractions;
  final Future<Map<String, Map<String, String>>> processedMedications;

  const PatientInfo({
    required this.patientData,
    required this.medications,
    required this.medicationInteractions,
    required this.processedMedications,
  });
}
