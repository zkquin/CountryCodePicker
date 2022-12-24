import 'generated_cities/cities.g.dart';
export 'generated_cities/cities.g.dart';

class City {
  City(
    this.geonameid,
    this.country,
    this.name,
    this.lat,
    this.lng
  );

  final String geonameid;
  final String country;
  final String name;
  final String lat;
  final String lng;

  City.fromMap(Map<String, String> map)
      : geonameid = map['geonameid']!,
        country = map['country']!,
        name = map['name']!,
        lat = map['lat']!,
        lng = map['lng']!;

  /// Returns the City matching a geo-name ID code from the standard list.
  factory City.fromID(String geonameId) {
    var _cityCountryReflector = new CityCountryReflector();
    return _cityCountryReflector[geonameId].firstWhere((l) => l.geonameid == geonameId);
  }

  bool operator ==(o) =>
      o is City && geonameid == o.geonameid && country == o.country && name == o.name
          && lat == o.lat && lng == o.lng;

  @override
  int get hashCode => super.hashCode;
}
