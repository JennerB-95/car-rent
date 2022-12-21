import 'package:flutter/material.dart';

import '../../core.dart';

class DropdownFormField extends StatelessWidget {
  const DropdownFormField({
    @required this.controller,
    @required this.labelText,
    @required this.items,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.validator,
    this.value,
    this.hintText,
    Key key,
  }) : super(key: key);
  final TextEditingController controller;
  final ItemValue value;
  final String labelText, hintText;
  final List<ItemValue> items;
  final String Function(String) validator;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            labelText,
            style: const TextStyle(color: Color(0xFF4D4C4C), fontSize: 18),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value?.value,
            validator: validator,
            onChanged: (value) {
              controller.text = value;
            },
            items: items
                .map((item) => DropdownMenuItem<String>(
                    value: item.value, child: Text(item.name)))
                .toList(),
            decoration: InputDecoration(
              // labelText: labelText,
              hintText: hintText,
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF707070)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF707070)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
