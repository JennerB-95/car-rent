import 'dart:convert';

import 'package:car_rental/shared/widgets/images_widget3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:html/parser.dart';
import '../../core.dart';

class BookCarView extends GetView<BookCarController> {
  final car = Get.arguments;
  final heroTag = Get.parameters["heroTag"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildFooter(),
    );
  }

  Widget buildHeader(context) {
    List carsImages = jsonDecode(car["slider_images"]);
    List<String> imagesSlider = carsImages
        .map((car) =>
            "https://rentcarapex.ceandb.com/assets/img/equipments/slider-images/${car.toString()}")
        .toList();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImagesWidget3(
            images: imagesSlider,
            isExpanded: false,
            heroTag: heroTag,
          ),
          SizedBox(height: 17),
          TitleWidget(title: car["title"], subtitle: car["name"]),
          SizedBox(height: 17),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildPricePerPeriod("Q${car["per_day_price"]}/Día"),
                SizedBox(width: 16),
                _buildPricePerPeriod("Q${car["per_week_price"]}/Semana"),
              ],
            ),
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(_parseHtmlString(car["description"]),
                textAlign: TextAlign.justify, style: TextStyle(fontSize: 15.0)),
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("Características", style: TextStyle(fontSize: 25.0)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(car["features"],
                textAlign: TextAlign.justify, style: TextStyle(fontSize: 15.0)),
          ),
          SizedBox(height: 17),
        ],
      ),
    );
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  Widget _buildPricePerPeriod(price) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(right: 14, left: 14, bottom: 20.0, top: 20.0),
        decoration: BoxDecoration(
          color: Color(0xff0C1239),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Text(
          price,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Precio de renta por día",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Q${car["per_day_price"]}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () => Get.toNamed(
              Routes.BOOKING_CARS,
              arguments: car,
            ),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Reservar",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                        // fontSize: 16,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
