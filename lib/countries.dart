import 'countries.g.dart';
export 'countries.g.dart';

class Country {
  Country(this.code, this.name, this.dialCode, this.flagUri);

  final String name;
  final String code;
  final String dialCode;
  final String flagUri;

  Country.fromMap(Map<String, String> map)
      : name = map['name']!,
        code = map['code']!,
        dialCode = map['dial_code']!,
        flagUri = 'flags/${map['code']!.toLowerCase()}.png';

  /// Returns the Country matching the given ISO code from the standard list.
  factory Country.fromCode(String code) =>
      Countries.defaultCountries.firstWhere((l) => l.code == code);

  bool operator ==(o) =>
      o is Country && name == o.name && code == o.code && dialCode == o.dialCode
          && flagUri == o.flagUri;

  @override
  int get hashCode => super.hashCode;
}
