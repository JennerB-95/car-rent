import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class CountryFormField extends StatefulWidget {
  const CountryFormField({
    Key key,
    @required this.controller,
    @required this.label,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.hintText,
    this.initCountry,
    this.validator,
  }) : super(key: key);

  final CrossAxisAlignment crossAxisAlignment;
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String Function(String) validator;
  final Country initCountry;

  @override
  State<CountryFormField> createState() => _CountryFormFieldState();
}

class _CountryFormFieldState extends State<CountryFormField> {
  Country _selectedDialogCountry;

  @override
  void initState() {
    _selectedDialogCountry =
        widget.initCountry ?? CountryPickerUtils.getCountryByIsoCode('ID');
    // widget.controller.text = _selectedDialogCountry.name;
    // debugPrint("widget.controller.text = ${widget.controller.text}");
    super.initState();
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
                titlePadding: const EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration:
                    const InputDecoration(hintText: 'Search...'),
                isSearchable: true,
                title: const Text('Select your country'),
                onValuePicked: (Country country) => setState(() {
                      _selectedDialogCountry = country;
                      widget.controller.text = _selectedDialogCountry.name;
                      debugPrint(
                          "widget.controller.text = ${widget.controller.text}");
                    }),
                // itemFilter: (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
                priorityList: [
                  CountryPickerUtils.getCountryByIsoCode('ID'),
                  CountryPickerUtils.getCountryByIsoCode('MY'),
                  CountryPickerUtils.getCountryByIsoCode('SG'),
                  CountryPickerUtils.getCountryByIsoCode('TR'),
                  CountryPickerUtils.getCountryByIsoCode('US'),
                  CountryPickerUtils.getCountryByIsoCode('AU'),
                ],
                itemBuilder: _buildDialogItem)),
      );

  Widget _buildDialogItem(Country country) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: 8.0),
          Flexible(
              child: Text(
            country.name,
            style: const TextStyle(fontSize: 17),
          )),
          const SizedBox(width: 8.0),
          Text("(+${country.phoneCode})"),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      children: [
        Text(
          widget.label,
          style: const TextStyle(color: Color(0xFF4D4C4C), fontSize: 18),
        ),
        SizedBox(
          height: 57,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _openCountryPickerDialog,
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 12, top: 12),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black54))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CountryPickerUtils.getDefaultFlagImage(
                            _selectedDialogCountry),
                        const SizedBox(width: 8.0),
                        Expanded(
                            child: FittedBox(
                          alignment: Alignment.topLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _selectedDialogCountry.name,
                            style: const TextStyle(fontSize: 16.7),
                          ),
                        )),
                        const Padding(
                          padding: EdgeInsets.only(left: 0.0, right: 2.0),
                          child: Icon(Icons.arrow_drop_down),
                        ),
                        // Flexible(child: Text(country.name))
                      ],
                    ),
                  ),
                ),
              )
              // Expanded(
              //   child: TextFormField(
              //     controller: widget.controller,
              //     validator: widget.validator,
              //     keyboardType: widget.keyboardType,
              //     inputFormatters: widget.inputFormatters,
              //     decoration: InputDecoration(
              //       hintText: widget.hintText,
              //       enabledBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Color(0xFF707070)),
              //       ),
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Color(0xFF707070)),
              //       ),
              //       // prefix: SizedBox(
              //       //   // height: 100,
              //       //   child: Icon(Icons.ac_unit),
              //       // )
              //       prefix: CountryPickerUtils.getDefaultFlagImage(
              //           _selectedDialogCountry),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
