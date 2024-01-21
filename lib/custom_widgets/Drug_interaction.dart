class MedicationInteractionChecker {
  final Map<String, Map<String, String>> interactionMaps;

  MedicationInteractionChecker(this.interactionMaps);

  List<String>? checkInteractions(List<String> medicines) {
    List<String>? interactingMedicines;

    for (String medicine in medicines) {
      if (interactionMaps.containsKey(medicine)) {
        final interactions = interactionMaps[medicine]!;
        // print('Checking interactions for: $medicine');

        for (String otherMedicine in medicines) {
          if (medicine != otherMedicine &&
              interactions.containsKey(otherMedicine)) {
            interactingMedicines ??= [];
            interactingMedicines.add(medicine);
            //  print('Interaction found with: $otherMedicine');
            break; // No need to check further for this medicine
          }
        }
      }
    }

    //  print('Medicines: $medicines');
    // print('Interacting Medicines: $interactingMedicines');

    return interactingMedicines;
  }

  List<String> getInteractionsDetails(List<String> medicines) {
    Set<String> interactionsDetails = Set();
    Set<String> processedInteractions = Set();

    for (int i = 0; i < medicines.length; i++) {
      String medicine = medicines[i];
      if (interactionMaps.containsKey(medicine)) {
        final interactions = interactionMaps[medicine]!;
        for (int j = i + 1; j < medicines.length; j++) {
          String otherMedicine = medicines[j];
          if (interactions.containsKey(otherMedicine)) {
            final interactionKey = '$medicine-$otherMedicine';
            if (!processedInteractions.contains(interactionKey) &&
                !interactionsDetails.contains(interactions[otherMedicine])) {
              interactionsDetails.add(interactions[otherMedicine]!);
              processedInteractions.add(interactionKey);
            }
          }
        }
      }
    }

    // print('Interactions Details: $interactionsDetails');
    return interactionsDetails.toList();
  }

//
  List<Map<String, dynamic>> getInteractions(List<String> medicines) {
    List<Map<String, dynamic>> interactionsDetails = [];
    Set<String> processedInteractions = Set();

    for (int i = 0; i < medicines.length; i++) {
      String medicine1 = medicines[i];
      if (interactionMaps.containsKey(medicine1)) {
        final interactions = interactionMaps[medicine1]!;

        for (int j = i + 1; j < medicines.length; j++) {
          String medicine2 = medicines[j];
          if (interactions.containsKey(medicine2)) {
            final interactionKey = '$medicine1-$medicine2';
            if (!processedInteractions.contains(interactionKey)) {
              interactionsDetails.add({
                'medicine1': medicine1,
                'medicine2': medicine2,
                'interactionDetails': interactions[medicine2],
              });
              processedInteractions.add(interactionKey);
            }
          }
        }
      }
    }

    print('Medicines: $medicines');
    print('Interactions Details: $interactionsDetails');
    return interactionsDetails;
  }

  //
}

final Map<String, Map<String, String>> allInteractions = {
  // ===AMLODIPINE=== //
  "Amlodipine": {
    "Metformin":
        "Makapadugang sa epekto sa Metformin kon i-kombinar pagtumar sa Amlodipine; nangahulogan nga makapaus-os og samot sa blood sugar.",
    "Simvastatin":
        "Taas kini og posibilidad nga makaresulta og pamaol ug pagkaluya.",
    "Gliclazide":
        "Makapaus-os sa proseso nga metabolismo sa Gliclazide kon i-kombinar pagtumar sa Amlodipine.",
    "Metoprolol": "Makapadugang sa iregyular na pagpitik sa kasing-kasing.",
    // "Losartan": "",
    "Salbutamol":
        "Makapaus-os ang Salbutamol sa epekto sa Amlodipine nga anti-altapresyon.",
    // "Atorvastatin": "",
    // "Citicoline": "",
    // "Rosuvastatin": "",
    "Valproic Acid":
        "Makapaus-os sa proseso nga metabolismo sa Valproic Acid kon i-kombinar pagtumar sa Amlodipine.",
    "Carvedilol": "Makapadugang sa iregyular na pagpitik sa kasing-kasing.",
    "Clopidogrel":
        "Makapaus-os sa epekto sa Clopidogrel kon i-kombinar pagtumar sa Amlodipine; nangahulogan nga di kaayo kini makapalabnaw sa dugo.",
  },

  // METFORMIN=== //
  "Metformin": {
    "Amlodipine":
        "Makapadugang sa epekto sa Metformin kon i-kombinar pagtumar sa Amlodipine; nangahulogan nga makapaus-os og samot sa blood sugar.",
    "Simvastatin":
        "Makapadugang sa epekto sa Simvastatin ang Metformin; nangahulogan nga mas makapaus-os og samot sa Cholesterol sa dugo.",
    "Gliclazide":
        "Ang kombinasyon sa Gliclazide ug Metformin mas maayo nga makaubos sa blood sugar kon ubanan sa pagkaon ug ehersisyo. Apan, kini mahimong magresulta usab og ubos kaayo na blood sugar.",
    "Metoprolol":
        "Makapadugang sa epekto sa Metformin kon i-kombinar sa Metoprolol; nangahulogan nga makapaus-os og samot sa blood sugar.",
    // "Losartan": "",
    "Salbutamol":
        "Ang Metformin makapaus-os sa proseso sa pagpagawas sa Salbutamol sa atong lawas; nangahulogan nga magpabilin nga taas ang lebel sa Salbutamol sa atong dugo.",
    "Atorvastatin":
        "Makapadugang sa epekto sa Atorvastatin ang Metformin; nangahulogan nga mas makapaus-os og samot sa Cholesterol sa dugo.",
    // "Citicoline": "",
    "Rosuvastatin":
        "Makapadugang sa epekto sa Rosuvastatin ang Metformin; nangahulogan nga mas makapaus-os og samot sa Cholesterol sa dugo.",
    // "Valproic Acid": "",
    "Carvedilol":
        "Makapadugang sa epekto sa Metformin kon i-kombinar sa Carvedilol; nangahulogan nga makapaus-os og samot sa blood sugar.",
    "Clopidogrel":
        "Makapataas sa lebel sa Metformin kon i-kombinar pagtumar sa Clopidogrel.",
  },

  // ===SIMVASTATIN=== //
  "Simvastatin": {
    "Amlodipine":
        "Taas kini og posibilidad nga makaresulta og pamaol ug pagkaluya.",
    "Metformin":
        "Makapadugang sa epekto sa Simvastatin ang Metformin; nangahulogan nga mas makapaus-os og samot sa Cholesterol sa dugo.",
    "Gliclazide":
        "Makapaus-os sa proseso nga metabolismo sa Gliclazide kon i-kombinar pagtumar sa Simvastatin.",
    "Metoprolol":
        "Makapaus-os sa proseso nga metabolismo sa Simvastatin kon i-kombinar pagtumar sa Metoprolol.",
    "Losartan":
        "Ang Simvastatin makapaus-os sa proseso sa pagpagawas sa Losartan sa atong lawas; nangahulogan nga magpabilin nga taas ang lebel sa Losartan sa atong lawas.",
    // "Salbutamol": "",
    "Atorvastatin":
        "Ang Simvastatin makapaus-os sa proseso sa pagpagawas sa Atorvastatin sa atong lawas; nangahulogan nga magpabilin nga taas ang lebel sa Atorvastatin sa atong dugo.",
    // "Citicoline": "",
    "Rosuvastatin":
        "Makapaus-os sa proseso sa pagpagawas sa Rosuvastatin sa atong lawas; nangahulogan nga magpabilin nga taas ang lebel sa Rosuvastatin sa atong lawas.",
    "Valproic Acid":
        "Makapaus-os sa proseso nga metabolismo sa Simvastatin kon i-kombinar pagtumar sa Valproic Acid.",
    "Carvedilol":
        "Makapataas sa lebel sa Simvastatin kon i-kombinar pagtumar sa Carvedilol.",
    "Clopidogrel":
        "Makapaus-os sa proseso nga metabolismo sa Simvastatin kon i-kombinar pagtumar sa Clopidogrel.",
  },

  // ===GLICLAZIDE=== //
  "Gliclazide": {
    "Amlodipine":
        "Makapaus-os sa proseso nga metabolismo sa Gliclazide kon i-kombinar pagtumar sa Amlodipine.",
    "Metformin":
        "Ang kombinasyon sa Gliclazide ug Metformin mas maayo nga makaubos sa blood sugar kon ubanan sa pagkaon ug ehersisyo. Apan, kini mahimong magresulta usab og ubos kaayo na blood sugar.",
    "Simvastatin":
        "Makapaus-os sa proseso nga metabolismo sa Gliclazide kon i-kombinar pagtumar sa Simvastatin.",
    "Metoprolol":
        "Makapadugang sa epekto sa Gliclazide kon i-kombinar sa Metoprolol; nangahulogan nga makapaus-os og samot sa blood sugar.",
    "Losartan":
        "Makapaus-os sa proseso nga metabolismo sa Gliclazide kon i-kombinar pagtumar sa Losartan.",
    "Salbutamol":
        "Ang Salbutamol makapaus-os sa epekto sa Gliclazide; nangahulogan nga magpabilin nga taas o dili mu-ubos ang lebel sa blood sugar.",
    // "Atorvastatin": "",
    // "Citicoline": "",
    "Rosuvastatin":
        "Makapadugang sa epekto sa Gliclazide kon i-kombinar sa Rosuvastatin; nangahulogan nga makapaus-os og samot sa blood sugar.",
    "Valproic Acid":
        "Makapaus-os sa proseso nga metabolismo sa Gliclazide kon i-kombinar pagtumar sa Valproic Acid.",
    "Carvedilol":
        "Makapadugang sa epekto sa Gliclazide kon i-kombinar sa Carvedilol; nangahulogan nga makapaus-os og samot sa blood sugar.",
    "Clopidogrel":
        "Makapaus-os sa proseso nga metabolismo sa Gliclazide kon i-kombinar pagtumar sa Clopidogrel.",
  },

  // ===METOPROLOL=== //
  "Metoprolol": {
    "Amlodipine": "Makapadugang sa iregyular na pagpitik sa kasing-kasing.",
    "Metformin":
        "Makapadugang sa epekto sa Metformin kon i-kombinar sa Metoprolol; nangahulogan nga makapaus-os og samot sa blood sugar.",
    "Simvastatin":
        "Makapaus-os sa proseso nga metabolismo sa Simvastatin kon i-kombinar pagtumar sa Metoprolol.",
    "Gliclazide":
        "Makapadugang sa epekto sa Gliclazide kon i-kombinar sa Metoprolol; nangahulogan nga makapaus-os og samot sa blood sugar.",
    "Losartan": "Makapadugang sa iregyular na pagpitik sa kasing-kasing.",
    "Salbutamol":
        "Makapaus-os sa epekto sa Salbutamol kon i-kombinar pagtumar sa Metoprolol.",
    // "Atorvastatin": "",
    // "Citicoline": "",
    // "Rosuvastatin": "",
    // "Valproic Acid": "",
    "Carvedilol": "Makapadugang sa iregyular na pagpitik sa kasing-kasing.",
    // "Clopidogrel": "",
  },

  // ===LOSARTAN=== //
  "Losartan": {
    // "Amlodipine": "",
    // "Metformin": "",
    "Simvastatin":
        "Ang Simvastatin makapaus-os sa proseso sa pagpagawas sa Losartan sa atong lawas; nangahulogan nga magpabilin nga taas ang lebel sa Losartan sa atong lawas.",
    "Gliclazide":
        "Makapaus-os sa proseso nga metabolismo sa Gliclazide kon i-kombinar pagtumar sa Losartan.",
    "Metoprolol": "Makapadugang sa iregyular na pagpitik sa kasing-kasing.",
    "Salbutamol":
        "Makapaus-os ang Salbutamol sa epekto sa Losartan nga anti-altapresyon.",

    "Atorvastatin":
        "Makapaus-os sa proseso nga metabolismo sa Atorvastatin kon i-kombinar pagtumar sa Losartan.",
    // "Citicoline": "",
    // "Rosuvastatin": "",
    "Valproic Acid":
        "Mas mutaas ang risgo sa kadugayon sa interbal sa pagkontrak ug ang pagrelaks sa kasingkasing kung ang Losartan i-kombinar pagtumar sa Valproic Acid.",
    "Carvedilol": "Makapadugang sa iregyular na pagpitik sa kasing-kasing.",
    "Clopidogrel":
        "Makapaus-os sa proseso nga metabolismo sa Clopidogrel kon i-kombinar pagtumar sa Losartan.",
  },

  // ===SALBUTAMOL=== //
  "Salbutamol": {
    "Amlodipine":
        "Makapaus-os ang Salbutamol sa epekto sa Amlodipine nga anti-altapresyon.",
    "Metformin":
        "Ang Metformin makapaus-os sa proseso sa pagpagawas sa Salbutamol sa atong lawas; nangahulogan nga magpabilin nga taas ang lebel sa Salbutamol sa atong dugo.",
    // "Simvastatin": "",
    "Gliclazide":
        "Ang Salbutamol makapaus-os sa epekto sa Gliclazide; nangahulogan nga magpabilin nga taas o dili mu-ubos ang lebel sa blood sugar.",
    "Metoprolol":
        "Makapaus-os sa epekto sa Salbutamol kon i-kombinar pagtumar sa Metoprolol.",
    "Losartan":
        "Makapaus-os ang Salbutamol sa epekto sa Losartan nga anti-altapresyon.",
    // "Atorvastatin": "",
    // "Citicoline": "",
    // "Rosuvastatin": "",
    "Valproic Acid":
        "Mas mutaas ang risgo sa kadugayon sa interbal sa pagkontrak ug ang pagrelaks sa kasingkasing kung ang Salbutamol i-kombinar pagtumar sa Valproic Acid.",
    "Carvedilol":
        "Makapaus-os sa epekto sa Salbutamol kon i-kombinar pagtumar sa Carvedilol.",
    // "Clopidogrel": "",
  },

//===================NEW MEDICINES======================= //

  // ATORVASTATIN //
  "Atorvastatin": {
    // "Amlodipine":"",
    "Metformin":
        "Makapadugang sa epekto sa Atorvastatin ang Metformin; nangahulogan nga mas makapaus-os og samot sa Cholesterol sa dugo.",
    "Simvastatin":
        "Ang Simvastatin makapaus-os sa proseso sa pagpagawas sa Atorvastatin sa atong lawas; nangahulogan nga magpabilin nga taas ang lebel sa Atorvastatin sa atong dugo.",
    // "Gliclazide":"",
    // "Metoprolol":"",
    "Losartan":
        "Makapaus-os sa proseso nga metabolismo sa Atorvastatin kon i-kombinar pagtumar sa Losartan.",
    // "Salbutamol":"",
    // "Citicoline":"",
    "Rosuvastatin":
        "Makapaus-os sa proseso sa pagpagawas sa Rosuvastatin sa atong lawas; nangahulogan nga magpabilin nga taas ang lebel sa Rosuvastatin sa atong lawas.",
    "Valproic Acid":
        "Makapaus-os sa proseso nga metabolismo sa Atorvastatin kon i-kombinar pagtumar sa Valproic Acid.",
    // "Carvedilol":"",
    "Clopidogrel":
        "Makapaus-os sa proseso nga metabolismo sa Atorvastatin kon i-kombinar pagtumar sa Clopidogrel.",
  },
  // CITICOLINE //
  "Citicoline": {
    "Amlodipine": "",
    "Metformin": "",
    "Simvastatin": "",
    "Gliclazide": "",
    "Metoprolol": "",
    "Losartan": "",
    "Salbutamol": "",
    "Atorvastatin": "",
    "Rosuvastatin": "",
    "Valproic Acid": "",
    "Carvedilol": "",
    "Clopidogrel": "",
  },

  // ROSUVASTATIN //
  "Rosuvastatin": {
    // "Amlodipine": "",
    "Metformin":
        "Makapadugang sa epekto sa Rosuvastatin ang Metformin; nangahulogan nga mas makapaus-os og samot sa Cholesterol sa dugo.",
    "Simvastatin":
        "Makapaus-os sa proseso sa pagpagawas sa Rosuvastatin sa atong lawas; nangahulogan nga magpabilin nga taas ang lebel sa Rosuvastatin sa atong lawas.",
    "Gliclazide":
        "Makapadugang sa epekto sa Gliclazide kon i-kombinar sa Rosuvastatin; nangahulogan nga makapaus-os og samot sa blood sugar.",
    // "Metoprolol": "",
    // "Losartan": "",
    // "Salbutamol": "",
    "Atorvastatin":
        "Makapaus-os sa proseso sa pagpagawas sa Rosuvastatin sa atong lawas; nangahulogan nga magpabilin nga taas ang lebel sa Rosuvastatin sa atong lawas.",
    // "Citicoline": "",
    "Valproic Acid":
        "Makapaus-os sa proseso sa pagpagawas sa Valproic Acid sa atong lawas; nangahulogan nga magpabilin nga taas ang lebel sa Valproic Acid sa atong lawas.",
    "Carvedilol":
        "Makapaus-os sa proseso nga metabolismo sa Carvedilol kon i-kombinar pagtumar sa Rosuvastatin.",
    "Clopidogrel":
        "Makapaus-os sa proseso nga metabolismo sa Rosuvastatin kon i-kombinar pagtumar sa Clopidogrel.",
  },

  // VALPROIC ACID //
  "Valproic Acid": {
    "Amlodipine":
        "Makapaus-os sa proseso nga metabolismo sa Valproic Acid kon i-kombinar pagtumar sa Amlodipine.",
    // "Metformin": "",
    "Simvastatin":
        "Makapaus-os sa proseso nga metabolismo sa Simvastatin kon i-kombinar pagtumar sa Valproic Acid.",
    "Gliclazide":
        "Makapaus-os sa proseso nga metabolismo sa Gliclazide kon i-kombinar pagtumar sa Valproic Acid.",
    // "Metoprolol": "",
    "Losartan":
        "Mas mutaas ang risgo sa kadugayon sa interbal sa pagkontrak ug ang pagrelaks sa kasingkasing kung ang Losartan i-kombinar pagtumar sa Valproic Acid.",
    "Salbutamol":
        "Mas mutaas ang risgo sa kadugayon sa interbal sa pagkontrak ug ang pagrelaks sa kasingkasing kung ang Salbutamol i-kombinar pagtumar sa Valproic Acid.",
    "Atorvastatin":
        "Makapaus-os sa proseso nga metabolismo sa Atorvastatin kon i-kombinar pagtumar sa Valproic Acid.",
    // "Citicoline": "",
    "Rosuvastatin":
        "Makapaus-os sa proseso sa pagpagawas sa Valproic Acid sa atong lawas; nangahulogan nga magpabilin nga taas ang lebel sa Valproic Acid sa atong lawas.",
    "Carvedilol":
        "Makapaus-os sa proseso nga metabolismo sa Carvedilol kon i-kombinar pagtumar sa Valproic Acid.",
    "Clopidogrel":
        "Makapaus-os sa proseso nga metabolismo sa Clopidogrel kon i-kombinar pagtumar sa Valproic Acid.",
  },

  // CARVEDILOL //
  "Carvedilol": {
    "Amlodipine": "Makapadugang sa iregyular na pagpitik sa kasing-kasing.",
    "Metformin":
        "Makapadugang sa epekto sa Metformin kon i-kombinar sa Carvedilol; nangahulogan nga makapaus-os og samot sa blood sugar.",
    "Simvastatin":
        "Makapataas sa lebel sa Simvastatin kon i-kombinar pagtumar sa Carvedilol.",
    "Gliclazide":
        "Makapadugang sa epekto sa Gliclazide kon i-kombinar sa Carvedilol; nangahulogan nga makapaus-os og samot sa blood sugar.",
    "Metoprolol": "Makapadugang sa iregyular na pagpitik sa kasing-kasing.",
    "Losartan": "Makapadugang sa iregyular na pagpitik sa kasing-kasing.",
    "Salbutamol":
        "Makapaus-os sa epekto sa Salbutamol kon i-kombinar pagtumar sa Carvedilol.",
    // "Atorvastatin": "",
    // "Citicoline": "",
    "Rosuvastatin":
        "Makapaus-os sa proseso nga metabolismo sa Carvedilol kon i-kombinar pagtumar sa Rosuvastatin.",
    "Valproic Acid":
        "Makapaus-os sa proseso nga metabolismo sa Carvedilol kon i-kombinar pagtumar sa Valproic Acid.",
    "Clopidogrel":
        "Makapaus-os sa epekto sa Clopidogrel kon i-kombinar pagtumar sa Carvedilol; nangahulogan nga di kaayo kini makapalabnaw sa dugo.",
  },

  // CLOPIDOGREL //
  "Clopidogrel": {
    "Amlodipine":
        "Makapaus-os sa epekto sa Clopidogrel kon i-kombinar pagtumar sa Amlodipine; nangahulogan nga di kaayo kini makapalabnaw sa dugo.",
    "Metformin":
        "Makapataas sa lebel sa Metformin kon i-kombinar pagtumar sa Clopidogrel.",
    "Simvastatin":
        "Makapaus-os sa proseso nga metabolismo sa Simvastatin kon i-kombinar pagtumar sa Clopidogrel.",
    "Gliclazide":
        "Makapaus-os sa proseso nga metabolismo sa Gliclazide kon i-kombinar pagtumar sa Clopidogrel.",
    // "Metoprolol": "",
    "Losartan":
        "Makapaus-os sa proseso nga metabolismo sa Clopidogrel kon i-kombinar pagtumar sa Losartan.",
    // "Salbutamol": "",
    "Atorvastatin":
        "Makapaus-os sa proseso nga metabolismo sa Atorvastatin kon i-kombinar pagtumar sa Clopidogrel.",
    // "Citicoline": "",
    "Rosuvastatin":
        "Makapaus-os sa proseso nga metabolismo sa Rosuvastatin kon i-kombinar pagtumar sa Clopidogrel.",
    "Valproic Acid":
        "Makapaus-os sa proseso nga metabolismo sa Clopidogrel kon i-kombinar pagtumar sa Valproic Acid.",
    "Carvedilol":
        "Makapaus-os sa epekto sa Clopidogrel kon i-kombinar pagtumar sa Carvedilol; nangahulogan nga di kaayo kini makapalabnaw sa dugo.",
  },
};
