import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:intl/intl.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class MyDateTimePicker extends StatefulWidget {
  final DateTime dateTime;
  final void Function(DateTime) onChange;
  final bool noPadding;
  final String label;
  final bool timePicker;
  final String text;

  final bool maxNow;
  final FormFieldValidator<String> validator;
  final TextEditingController ctrl;

  MyDateTimePicker({
    @required this.dateTime,
    @required this.onChange,
    this.noPadding = false,
    this.label = 'Escriba aquí',
    this.text,
    this.timePicker = false,
    this.maxNow = true,
    this.validator,
    this.ctrl,
  });

  @override
  _MyDateTimePickerState createState() => _MyDateTimePickerState();
}

class _MyDateTimePickerState extends State<MyDateTimePicker> {
  final _ctrl = TextEditingController();
  final _ctrlNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _ctrl.text = _formattedDate(widget.dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDatetimePicker(context);
      },
      child: AbsorbPointer(
        child: Padding(
          padding: EdgeInsets.symmetric(
              // horizontal: widget.noPadding ? 0.0 : 15.0,
              // vertical: widget.noPadding ? 0.0 : 10.0,
              ),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xffe9ecef).withOpacity(0.7),
                borderRadius: BorderRadius.circular(10.0)),
            child: TextFormField(
              validator: widget.validator,
              onFieldSubmitted: (value) {
                _ctrlNode.unfocus();
                FocusScope.of(context).requestFocus(_ctrlNode);
              },
              controller: widget.ctrl,
              decoration: InputDecoration(
                  hintText: widget.text,
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(
                    FeatherIcons.calendar,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(18.0)),
            ),
          ),
        ),
      ),
    );
  }

  void _showDatetimePicker(context) {
    if (widget.timePicker) {
      DatePicker.showDateTimePicker(
        context,
        showTitleActions: true,
        currentTime: this.widget.dateTime,
        maxTime: widget.maxNow ? DateTime.now() : null,
        locale: LocaleType.es,
        onChanged: (date) {
          widget.onChange(date);

          setState(() {
            _ctrl.text = _formattedDate(date);
          });
        },
      );
    } else {
      DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        currentTime: this.widget.dateTime,
        minTime: DateTime(1900, 1, 1),
        maxTime: widget.maxNow ? DateTime.now() : null,
        locale: LocaleType.es,
        onChanged: (date) {
          widget.onChange(date);

          setState(() {
            widget.ctrl.text = _formattedDate(date);
          });
        },
      );
    }
  }

  String _formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
