class MedicationInteractionChecker {
  final Map<String, Map<String, String>> interactionMaps;

  MedicationInteractionChecker(this.interactionMaps);

  List<String>? checkInteractions(List<String> medicines) {
    List<String>? interactingMedicines;

    for (String medicine in medicines) {
      if (interactionMaps.containsKey(medicine)) {
        final interactions = interactionMaps[medicine]!;
        print('Checking interactions for: $medicine');

        for (String otherMedicine in medicines) {
          if (medicine != otherMedicine &&
              interactions.containsKey(otherMedicine)) {
            interactingMedicines ??= [];
            interactingMedicines.add(medicine);
            print('Interaction found with: $otherMedicine');
            break; // No need to check further for this medicine
          }
        }
      }
    }

    print('Medicines: $medicines');
    print('Interacting Medicines: $interactingMedicines');

    return interactingMedicines;
  }

  List<String> getInteractionsDetails(List<String> medicines) {
    List<String> interactionsDetails = [];
    Set<String> processedInteractions = Set();

    for (int i = 0; i < medicines.length; i++) {
      String medicine = medicines[i];
      if (interactionMaps.containsKey(medicine)) {
        final interactions = interactionMaps[medicine]!;
        for (int j = i + 1; j < medicines.length; j++) {
          String otherMedicine = medicines[j];
          if (interactions.containsKey(otherMedicine)) {
            final interactionKey = '$medicine-$otherMedicine';
            if (!processedInteractions.contains(interactionKey)) {
              interactionsDetails.add(interactions[otherMedicine]!);
              processedInteractions.add(interactionKey);
            }
          }
        }
      }
    }

    print('Interactions Details: $interactionsDetails');
    return interactionsDetails;
  }
}

final Map<String, Map<String, String>> allInteractions = {
  // AMLODIPINE //
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
  },

  // METFORMIN //
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
  },

  // SIMVASTATIN //
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
  },

  // GLICLAZIDE //
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
  },

  // METOPROLOL //
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
  },

  // LOSARTAN //
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
  },

  // SALBUTAMOL //
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
  },
};
