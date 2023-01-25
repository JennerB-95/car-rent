import 'package:car_rental/pages/home/widgets/header_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import '../../core.dart';

class HomeView extends GetView<HomeController> {
  final user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF8F8F8),
      child: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeader(),
                    buildTopDeals(),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Image.asset(
              "assets/images/header.png",
              //fit: BoxFit.scaleDown,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 70.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            children: [
              CircleAvatar(
                maxRadius: 25,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541"),
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(
                "Bienvenido, ${user["first_name"]} ${user["last_name"]}",
                style: TextStyle(
                    fontSize: 18.0,
                    color: Color(0xff333D55),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            "Los mejores vehículos para ti",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xffBEBEBE),
                fontSize: 18),
          ),
        ),
        ImagesWidget(
            images: controller.theData
                .map((car) =>
                    "https://rentcarapex.ceandb.com/assets/img/equipments/thumbnail-images/${car['thumbnail_image']}")
                .toList()),
      ],
    );
  }

  Widget buildAvailableCars() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.AVAILABLE_CARS),
      child: Padding(
        padding: EdgeInsets.only(top: 20, right: 16, left: 16),
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          padding: EdgeInsets.all(24),
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Available Cars",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Long term and short term",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                height: 50,
                width: 50,
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

  Widget buildTopDeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, bottom: 15.0),
          child: Text(
            "Disponibles",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: controller.theData
                .map((car) => GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Routes.BOOK_CAR,
                          arguments: [car, user],
                          parameters: {
                            "heroTag": "home" +
                                car["name"].toString() +
                                "https://rentcarapex.ceandb.com/assets/img/equipments/thumbnail-images/${car['thumbnail_image']}",
                          },
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.network(
                              "https://rentcarapex.ceandb.com/assets/img/equipments/thumbnail-images/${car['thumbnail_image']}",
                              height: 120.0,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    car["title"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.car_rental,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 3.0,
                                      ),
                                      Text(
                                        car["name"],
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.pin_drop,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 3.0,
                                      ),
                                      Text(
                                        "Quetzaltenango",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3.0),
                                        padding: EdgeInsets.all(10.0),
                                        color: Colors.grey[50],
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Text(
                                            "Q${car["per_day_price"]}/Día",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 3.0),
                                        padding: EdgeInsets.all(10.0),
                                        color: Colors.grey[50],
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Text(
                                            "Q${car["per_week_price"]}/Semana",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              FeatherIcons.chevronRight,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget buildTopDealers() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TOP DEALERS",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      "More",
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
              ),
            ],
          ),
        ),
        Container(
          height: 150,
          margin: EdgeInsets.only(bottom: 16),
          child: ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: controller.dealers
                .map((dealer) => DealerWidget(
                    dealer: dealer, index: controller.dealers.indexOf(dealer)))
                .toList(),
          ),
        ),
      ],
    );
  }
}
