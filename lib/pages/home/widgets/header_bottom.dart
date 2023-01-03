import 'package:car_rental/core.dart';
import 'package:flutter/material.dart';

class HeaderBottom extends StatelessWidget {
  const HeaderBottom({
    Key key,
    @required this.displayCar,
  }) : super(key: key);

  final Car displayCar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleWidget(
            title: displayCar.model,
            subtitle: displayCar.brand,
          ),
        ],
      ),
    );
  }
}
