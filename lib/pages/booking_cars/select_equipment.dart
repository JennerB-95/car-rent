import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../models/equipment.dart';
import '../../services/equipment_service.dart';
import '../book_car/book_car_view.dart';

class EquipmentsPage extends StatefulWidget {
  const EquipmentsPage({Key key}) : super(key: key);

  @override
  State<EquipmentsPage> createState() => _EquipmentsPageState();
}

class _EquipmentsPageState extends State<EquipmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: AppBar(
        title: Text(
          "Reservar",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              FeatherIcons.chevronLeft,
              color: Colors.grey,
            )),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
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
            child: FutureBuilder(
                future: EquipmentService.fetchAll(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: new AlwaysStoppedAnimation<Color>(
                          Color(0xff333D55),
                        ),
                      ),
                    );
                  } else {
                    List<Equipment> equipments = snapshot.data;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Column(
                        children: equipments
                            .map((car) => GestureDetector(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: BookCarView(
                                          car: car,
                                        ),
                                        withNavBar: true);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.0),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Image.network(
                                          "https://rentcarapex.ceandb.com/assets/img/equipments/thumbnail-images/" +
                                              car.thumbnail_image.toString(),
                                          height: 120.0,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                backgroundColor: Colors.white,
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(
                                                  Color(0xff333D55),
                                                ),
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                car.title,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    car.name,
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                        EdgeInsets.symmetric(
                                                            vertical: 3.0),
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    color: Colors.grey[50],
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3.0),
                                                      child: Text(
                                                        "Q${car.per_day_price}/Día",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13.0),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 3.0),
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    color: Colors.grey[50],
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3.0),
                                                      child: Text(
                                                        "Q${car.per_week_price}/Semana",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
