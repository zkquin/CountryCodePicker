import 'dart:convert';
import 'dart:io';
import "package:collection/collection.dart";

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

main() {
  final contents = File('lib/cities15000.json').readAsStringSync();
  final jsonLanguages = jsonDecode(contents);
  final List<City> city = jsonLanguages.map<City>((m) => City.fromMap(Map<String, String>.from(m))).toList();

  Map<String, List<City>> cityByCountry = groupBy(city, (City city) => city.country);

  cityByCountry.forEach((key, value) {
    for (var i = 0; i < value.length; i += 1) {
      final getters = value.map((l) {
        return 'City get ${toGetterName(l.name) + l.geonameid} => City("${l.geonameid}", "${l.country}", "${l.name}", "${l.lat}", "${l.lng}");';
      });

      // This alignment must be maintained.
      final defaultCountries = '''
List<City> $key = [
  ${value.map((l) => toGetterName(l.name) + l.geonameid).join(',\n  ')}
];
  ''';

      final staticClass = '''
// This is a generated file.
import '../cities.dart';

${getters.join('\n')}

$defaultCountries
''';

      File('lib/generated_cities/$key.g.dart').writeAsStringSync(staticClass);
    }
    print("Generating: $key.g.dart");
  });

  List<String> cityByCountryKeys = cityByCountry.keys.toList();

  final exportFile = '''
// This is a generated file.

import 'package:country_code_picker/cities.dart';

${cityByCountryKeys.map((key) => "import '$key.g.dart';").join('\n')}

class CityCountryReflector{
  List<City> operator [](String key) {
    switch(key) {
      ${cityByCountryKeys.map((key) => "case '$key': return $key;").join('\n      ')}
    }
    return [];
  }
}
''';

  File('lib/generated_cities/cities.g.dart').writeAsStringSync(exportFile);


}
