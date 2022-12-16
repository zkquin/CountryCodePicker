import 'package:country_code_picker/cities.dart';
import 'package:country_code_picker/city_code_dialog.dart';
import 'package:country_code_picker/country_code_dialog.dart';
import 'package:country_code_picker/countries.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'country_code_picker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'language_picker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  String _selectedNationality;
  String _selectedNationalityCode;

  String _selectedCity;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () => _openCountryPickerDialog(),
                child: _selectedNationality == null ? Text("Select", style: TextStyle(color: Colors.grey[800]),)
                    : Text(_selectedNationality, style: TextStyle(color: Colors.grey[800]),),
              ),
              TextButton(
                onPressed: () => _openCityPickerDialog(),
                child: _selectedCity == null ? Text("Select", style: TextStyle(color: Colors.grey[800]),)
                    : Text(_selectedCity, style: TextStyle(color: Colors.grey[800]),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCityPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: CityPickerDialog(
            code: _selectedNationalityCode,
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select city'),
            onValuePicked: (City city) => setState(() {
              _selectedCity = city.name;
              print(city.name);
              print(city.geonameid);
              print(city.country);
            }),
            itemBuilder: _buildCityDialogItem)),
  );

  Widget _buildCityDialogItem(City city) => Row(
    children: <Widget>[
      Text(city.name),
      // SizedBox(width: 8.0),
      // Flexible(child: Text("(${country.code})"))
    ],
  );

  void _openCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select your country'),
            onValuePicked: (Country country) => setState(() {
              _selectedNationality = country.name;
              _selectedNationalityCode = country.code;
              print(country.name);
              print(country.code);
              print(country.flagUri);
            }),
            itemBuilder: _buildCountryDialogItem)),
  );

  Widget _buildCountryDialogItem(Country country) => Row(
    children: <Widget>[
      Text(country.name),
      // SizedBox(width: 8.0),
      // Flexible(child: Text("(${country.code})"))
    ],
  );
}