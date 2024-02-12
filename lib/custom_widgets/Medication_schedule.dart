// class MedicationProcessor {
//   static Map<String, Map<String, List<String>>> processMedications(
//       List<Map<String, dynamic>> medications) {
//     // Initialize the result map
//     Map<String, Map<String, List<String>>> result = {
//       'morning': {'before eat': [], 'after eat': []},
//       'noon': {'before eat': [], 'after eat': []},
//       'evening': {'before eat': [], 'after eat': []},
//     };

//     // Process each medication
//     for (var medication in medications) {
//       int frequency = medication['frequency'];
//       String tukma = medication['tukma'].toString().toLowerCase();
//       String medicationName = medication['name'].toString();

//       // Add the medication to the corresponding frequency and tukma in the result map
//       if (frequency == 1) {
//         result['morning']?[tukma]?.add(medicationName);
//       }
//       if (frequency == 2) {
//         result['morning']?[tukma]?.add(medicationName);
//         result['noon']?[tukma]?.add(medicationName);
//       }
//       if (frequency == 3) {
//         result['morning']?[tukma]?.add(medicationName);
//         result['noon']?[tukma]?.add(medicationName);
//         result['evening']?[tukma]?.add(medicationName);
//       }
//     }

//     return result;
//   }
// }

class MedicationProcessor {
  static Map<String, Map<String, String>> processMedications(
      List<Map<String, dynamic>> medications) {
    Map<String, Map<String, List<String>>> result = {
      'Buntag': {'Sa dili pa mukaon': [], 'Human ug kaon': []},
      'Udto': {'Sa dili pa mukaon': [], 'Human ug kaon': []},
      'Gabie': {'Sa dili pa mukaon': [], 'Human ug kaon': []},
    };

    // Process medications as before
    for (var medication in medications) {
      String frequency = medication['frequency'].toString();
      String tukma = medication['tukma'].toString();
      String medicationName = medication['name'].toString();
      String oras = medication['oras'].toString();

      if (frequency == '1') {
        if (oras.contains('Buntag')) {
          result['Buntag']?[tukma]?.add(medicationName);
        } else if (oras.contains('Udto')) {
          result['Udto']?[tukma]?.add(medicationName);
        } else {
          result['Gabie']?[tukma]?.add(medicationName);
        }
      } else if (frequency == '2') {
        if (oras.contains('Buntag ug Udto')) {
          result['Buntag']?[tukma]?.add(medicationName);
          result['Udto']?[tukma]?.add(medicationName);
        } else if (oras.contains('Udto ug Gabie')) {
          result['Udto']?[tukma]?.add(medicationName);
          result['Gabie']?[tukma]?.add(medicationName);
        } else {
          result['Buntag']?[tukma]?.add(medicationName);
          result['Gabie']?[tukma]?.add(medicationName);
        }
      } else {
        result['Buntag']?[tukma]?.add(medicationName);
        result['Udto']?[tukma]?.add(medicationName);
        result['Gabie']?[tukma]?.add(medicationName);
      }
    }

    Map<String, Map<String, String>> parseMedicationsToString(
        Map<String, Map<String, List<String>>> processedMedications) {
      Map<String, Map<String, String>> parsedResult = {};

      for (var timeSlot in processedMedications.keys) {
        parsedResult[timeSlot] = {};
        for (var tukma in processedMedications[timeSlot]!.keys) {
          parsedResult[timeSlot]![tukma] =
              processedMedications[timeSlot]![tukma]!.join(', ');
        }
      }

      return parsedResult;
    }

    print(parseMedicationsToString(result));

    return parseMedicationsToString(result);
  }
}

// ============================================= METHOD 2 ==================================================//

/*class MedicationProcessor {
  static Map<String, Map<String, List<String>>> processMedications(
      List<Map<String, dynamic>> medications) {
    // Initialize the result map
   Map<String, Map<String, List<String>>> result = {
      'morning': {'Sa dili pa mukaon': [], 'Human ug kaon': []},
      'noon': {'Sa dili pa mukaon': [], 'Human ug kaon': []},
      'evening': {'Sa dili pa mukaon': [], 'Human ug kaon': []},
    };

    // Process each medication
    for (var medication in medications) {
      int frequency = medication['frequency'];
      String tukma = medication['tukma'].toString();
      String medicationName = medication['name'].toString();

      // Add the medication to the corresponding frequency and tukma in the result map
      if (frequency == 1) {
        result['morning']?[tukma]?.add(medicationName);
      }
      if (frequency == 2) {
        result['morning']?[tukma]?.add(medicationName);
        result['noon']?[tukma]?.add(medicationName);
      }
      if (frequency == 3) {
        result['morning']?[tukma]?.add(medicationName);
        result['noon']?[tukma]?.add(medicationName);
        result['evening']?[tukma]?.add(medicationName);
      }
    }

    return result;
  }

  static Map<String, Map<String, String>> parseMedicationsToString(
      Map<String, Map<String, List<String>>> processedMedications) {
    // Initialize the result map for parsed medications
    Map<String, Map<String, String>> parsedResult = {};

    // Process each time slot in the result map
    processedMedications.forEach((timeSlot, value) {
      // Initialize the inner map for parsed medications within the time slot
      Map<String, String> parsedTimeSlot = {};

      // Process each tukma within the time slot
      value.forEach((tukma, medicationsList) {
        // Convert the list of medications to a single string
        String medicationsString = medicationsList.join(', ');

        // Add the result to the inner map
        parsedTimeSlot[tukma] = medicationsString;
      });

      // Add the inner map to the result map
      parsedResult[timeSlot] = parsedTimeSlot;
    });

    return parsedResult;
  }
}*/
