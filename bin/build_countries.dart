import 'dart:convert';
import 'dart:io';
import 'package:recase/recase.dart';

import 'package:country_code_picker/countries.dart';

toGetterName(String countryName) => countryName
    // Remove commas and parentheses
    .replaceAll(RegExp('[,\(\)]'), '')
    // Replace punctuated name
    .replaceAll('ü', 'u')
    .camelCase;

/// Reads countries.json and generates lib/countries.g.dart, which contains
/// countries.countryName constants and the countries.defaultCountries list.
main() {
  final contents = File('lib/countries.json').readAsStringSync();
  final jsonLanguages = jsonDecode(contents);
  final List<Country> countries = jsonLanguages
      .map<Country>((m) => Country.fromMap(Map<String, String>.from(m)))
      .toList();
  final getters = countries.map((l) {
    final getterName = toGetterName(l.name);
    return "  static Country get $getterName => Country('${l.code}', '${l.name}', '${l.dialCode}', '${l.flagUri}');";
  });

  final defaultCountries = '''
static List<Country> defaultCountries =
  [${countries.map((l) => 'Countries.' + toGetterName(l.name)).join(',\n')}];
''';

  final staticClass = '''
// This is a generated file. See DEVELOPMENT_NOTES.md.
import 'countries.dart';

class Countries {
${getters.join('\n')}

$defaultCountries
}
''';
  File('lib/countries.g.dart').writeAsStringSync(staticClass);
}
