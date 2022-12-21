import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldX extends StatefulWidget {
  const TextFormFieldX({
    Key key,
    @required this.controller,
    @required this.label,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.hintText,
    this.errorText,
    this.initPhoneCode,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.initialValue,
    this.keyboardAppearance,
    this.maxLength,
    this.maxLines = 1,
  }) : super(key: key);

  final CrossAxisAlignment crossAxisAlignment;
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String errorText;
  final String Function(String) validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final Country initPhoneCode;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final String initialValue;
  final Brightness keyboardAppearance;
  final int maxLength;
  final int maxLines;

  @override
  State<TextFormFieldX> createState() => _TextFormFieldXState();
}

class _TextFormFieldXState extends State<TextFormFieldX> {
  Country _selectedDialogCountry;

  @override
  void initState() {
    _selectedDialogCountry =
        widget.initPhoneCode ?? CountryPickerUtils.getCountryByPhoneCode('62');
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
                title: const Text('Select your phone code'),
                onValuePicked: (Country country) =>
                    setState(() => _selectedDialogCountry = country),
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
          Text(
            "(+${country.phoneCode})",
            style: const TextStyle(fontSize: 17),
          ),
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
              widget.keyboardType == TextInputType.phone
                  ? GestureDetector(
                      onTap: _openCountryPickerDialog,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 12, top: 12),
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black54))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CountryPickerUtils.getDefaultFlagImage(
                                _selectedDialogCountry),
                            const SizedBox(width: 8.0),
                            Flexible(
                                child: Text(
                              "+${_selectedDialogCountry.phoneCode} (${_selectedDialogCountry.isoCode}) ",
                              style: const TextStyle(fontSize: 15.7),
                            )),
                            const Padding(
                              padding: EdgeInsets.only(left: 0.0, right: 4.0),
                              child: Icon(Icons.arrow_drop_down),
                            ),
                            // Flexible(child: Text(country.name))
                          ],
                        ),
                      ),
                    )
                  : Container(),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  validator: widget.validator,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  textCapitalization: widget.textCapitalization,
                  autocorrect: widget.autocorrect,
                  initialValue: widget.initialValue,
                  keyboardAppearance: widget.keyboardAppearance,
                  maxLength: widget.maxLength,
                  maxLines: widget.maxLines,
                  onSaved: (value) {
                    if (widget.keyboardType == TextInputType.phone) {
                      widget.controller.text =
                          "(${_selectedDialogCountry.phoneCode}) " + value;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    errorText: widget.errorText,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF707070)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF707070)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
