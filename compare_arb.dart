import 'dart:convert';
import 'dart:io';

void main() {
  final enFile = File(r'c:\Users\Sunil.Kumar\Downloads\taksh_e_commerce-feature-arpit-prev-apk-ui\taksh_e_commerce-feature-arpit-prev-apk-ui\lib\l10n\app_en.arb');
  final hiFile = File(r'c:\Users\Sunil.Kumar\Downloads\taksh_e_commerce-feature-arpit-prev-apk-ui\taksh_e_commerce-feature-arpit-prev-apk-ui\lib\l10n\app_hi.arb');

  final enContent = json.decode(enFile.readAsStringSync()) as Map<String, dynamic>;
  final hiContent = json.decode(hiFile.readAsStringSync()) as Map<String, dynamic>;

  final enKeys = enContent.keys.where((k) => !k.startsWith('@')).toSet();
  final hiKeys = hiContent.keys.where((k) => !k.startsWith('@')).toSet();

  print('Total EN keys: ${enKeys.length}');
  print('Total HI keys: ${hiKeys.length}');

  final missingInHi = enKeys.difference(hiKeys);
  final missingInEn = hiKeys.difference(enKeys);

  if (missingInHi.isNotEmpty) {
    print('\nMissing keys in HI (${missingInHi.length}):');
    final sortedMissing = missingInHi.toList()..sort();
    for (var key in sortedMissing) {
      print('- $key');
      // Also print the English value to help with translation
      // print('  Value: ${enContent[key]}'); 
    }
  }

  if (missingInEn.isNotEmpty) {
    print('\nKeys in HI but not in EN (${missingInEn.length}):');
     final sortedExtra = missingInEn.toList()..sort();
    for (var key in sortedExtra) {
      print('- $key');
    }
  }

  if (missingInHi.isEmpty && missingInEn.isEmpty) {
    print('\nAll functional keys are present in both files.');
  }
}
