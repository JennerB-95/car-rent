import 'package:car_rental/pages/search/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core.dart';

class SearchView extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.only(
                      left: 30,
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 24.0, left: 16.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      buildRecentSearch(),
                      SizedBox(height: 25),
                      Divider(
                        thickness: 1,
                        indent: 15,
                        endIndent: 15,
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRecentSearch() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "RECENT SEACRH",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                ),
              ),
              Row(
                children: [
                  Text(
                    "view all",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 280,
          child: ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: controller.cars
                .map((car) => GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Routes.BOOK_CAR,
                          arguments: car,
                          parameters: {
                            "heroTag":
                                "search" + car.id.toString() + car.images[0],
                          },
                        );
                      },
                      child: CarWidget(
                        car: car,
                        index: controller.cars.indexOf(car),
                        heroTag: "search" + car.id.toString() + car.images[0],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
