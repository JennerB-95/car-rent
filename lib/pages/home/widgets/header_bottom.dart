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
          InkWell(
            onTap: () => OpenDialog.info(
                lottieFilename: LottieFileName.COMING_SOON,
                lottiePadding: EdgeInsets.only(top: 50)),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text(
                    "My Garage",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 23,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
