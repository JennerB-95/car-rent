import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core.dart';

class FittedButton extends StatelessWidget {
  const FittedButton({
    Key key,
    @required this.onPressed,
    @required this.label,
    this.color,
    this.padding,
  }) : super(key: key);

  final Function() onPressed;
  final String label;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? Get.theme.colorScheme.primary,
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                height: 40,
                width: 40,
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
