import 'dart:convert';
import 'dart:io';

import 'package:recase/recase.dart';
import 'package:diacritic/diacritic.dart';

import 'package:country_code_picker/cities.dart';

// TODO: replaceAll not working.
toGetterName(String countryName) => removeDiacritics(
    countryName
    .replaceAll(RegExp("[,\(\)'’‘`]"), '')
    .replaceAll('ə', 'e')
    .replaceAll('ð', 'o')
    .camelCase);

/// Reads cities15000.json and generates lib/cities.g.dart, which contains
/// city.cityName constants and the city.defaultCities list.
main() {
  final contents = File('lib/cities15000.json').readAsStringSync();
  final jsonLanguages = jsonDecode(contents);
  final List<City> city = jsonLanguages
      .map<City>((m) => City.fromMap(Map<String, String>.from(m)))
      .toList();
  final getters = city.map((l) {
    final getterName = toGetterName(l.name);
    return '  static City get $getterName${l.geonameid} => City("${l.geonameid}", "${l.country}", "${l.name}", "${l.lat}", "${l.lng}");';
  });

  final defaultCountries = '''
  static List<City> defaultCities =
    [${city.map((l) => 'Cities.' + toGetterName(l.name) + l.geonameid).join(',\n')}];
  ''';

  final staticClass = '''
// This is a generated file.
import 'cities.dart';

class Cities {
${getters.join('\n')}

$defaultCountries
}
''';
  File('lib/cities.g.dart').writeAsStringSync(staticClass);
}
