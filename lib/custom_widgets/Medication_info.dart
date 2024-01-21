class MedicationInfoProvider {
  static Map<String, Map<String, String>> medicationInformation = {
    "Gliclazide": {
      "reminder": "Mukaon sa dili pa tumaron ang tambal. Maglikay sa pagdrive.",
    },
    "Amlodipine": {
      "reminder": "Maglikay sa pagkaon og buongon ug grabeng pagpangusog.",
    },
    "Losartan": {
      "reminder": "Limitahi ang pag-konsumo og mga parat.",
    },
    "Metformin": {
      "reminder":
          "Likayi ang mga makahubog nga imnunon;  ipahibalo dayun ang mga dili maayo nga gibati.",
    },
    "Simvastatin": {
      "reminder":
          "Maglikay sa pagkaon og buongon, ipahibalo dayun kung makabati og sakit sa kalawasan.",
    },
    "Metoprolol": {
      "reminder":
          "Limitahi ang pag-konsumo og mga parat ug mga ilimnon nga makahubog.",
    },
    "Salbutamol": {
      "reminder":
          "Likayi ang pagkaon sa tsokolate ug pag-inom sa kape, tsa-a, ug Coke; daghan ang pag-inom og tubig.",
    },
    "Atorvastatin": {
      "reminder":
          "Dili usapon o buk-on ang tableta. Maglikay sa pagkaon og buongon ug mga ilimnon nga makahubog.",
    },
    "Citicoline": {
      "reminder": "Mahimo nga tumaron ang tambal nga wala'y sulod ang tiyan.",
    },
    "Rosuvastatin": {
      "reminder":
          "I-sustinar ang saktong pagkaon; ipahibalo dayun kung makabati og sakit sa kalawasan.",
    },
    "Valproic Acid": {
      "reminder":
          "Ayaw hunongi og kalit ang paginom sa tambal; ipahibalo dayon kung mugrabe ang konbulsyon.",
    },
    "Carvedilol": {
      "reminder":
          "Angay nga magmonitor sa BP ug pulso sa dili pa tumaron ang tambal.",
    },
    "Clopidogrel": {
      "reminder": "Magbantay sa mga kalit na pagdugo.",
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
