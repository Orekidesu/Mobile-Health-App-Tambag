class MedicationInfoProvider {
  static Map<String, Map<String, String>> medicationInformation = {
    "Gliclazide": {
      "reminder": "Take GLICLAZIDE as prescribed by your doctor.",
      "contraindication":
          "Do not take GLICLAZIDE if you are allergic to sulfonylureas.",
      "diet": "Maintain a balanced diet to regulate blood sugar levels.",
    },
    "Amlodipine": {
      "reminder": "Take Amlodipine regularly at the same time each day.",
      "contraindication":
          "Avoid grapefruit or grapefruit juice as it may interact with Amlodipine.",
      "diet":
          "Consider a low-sodium diet if recommended by your healthcare provider.",
    },
    "Losartan": {
      "reminder": "Follow the prescribed dosage schedule for Losartan.",
      "contraindication":
          "Inform your doctor of any kidney or liver issues before taking Losartan.",
      "diet":
          "Maintain a healthy diet with an emphasis on potassium-rich foods.",
    },
    "Metformin": {
      "reminder": "Take Metformin with meals to reduce stomach upset.",
      "contraindication":
          "Avoid excessive alcohol consumption while on Metformin.",
      "diet": "Adopt a well-balanced diet and regular exercise routine.",
    },
    "Simvastatin": {
      "reminder": "Take Simvastatin in the evening with or without food.",
      "contraindication":
          "Limit grapefruit and alcohol intake while on Simvastatin.",
      "diet": "Follow a low-cholesterol diet as advised by your doctor.",
    },
    "Metoprolol": {
      "reminder": "Take Metoprolol at the same time each day as prescribed.",
      "contraindication":
          "Inform your doctor of any respiratory issues before taking Metoprolol.",
      "diet": "Maintain a heart-healthy diet with reduced sodium intake.",
    },
    "Salbutamol": {
      "reminder": "Use Salbutamol inhaler as needed for respiratory symptoms.",
      "contraindication":
          "Consult your doctor if you experience increased heart rate with Salbutamol.",
      "diet": "No specific dietary restrictions for Salbutamol.",
    },
  };

  static Map<String, String> getMedicationInfo(String medicationName) {
    if (medicationInformation.containsKey(medicationName)) {
      return medicationInformation[medicationName]!;
    } else {
      return {};
    }
  }
}
