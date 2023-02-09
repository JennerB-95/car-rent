import 'dart:convert';

import 'package:car_rental/models/my_booking.dart';
import 'package:car_rental/pages/search/search_controller.dart';
import 'package:car_rental/services/my_booking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;

const albumImage =
    'https://raw.githubusercontent.com/digitaljoni/examples_flutter/master/music_player/images/album.png';

class BookingList extends StatefulWidget {
  const BookingList({Key key}) : super(key: key);

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var booking = [];
  final List<String> entries = <String>['A', 'B', 'C'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF8F8F8),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeader(),
                    FutureBuilder(
                      future: MisReservasService.fetchAll(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                          List<MisReservas> _misReservas = [];
                          _misReservas = snapshot.data;
                          print("reservas $_misReservas");
                          return Column(
                            children: _misReservas.map((e) {
                              return Container(
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      width: 110,
                                      height: 110,
                                      child: Image.network(
                                        "https://rentcarapex.ceandb.com/assets/img/equipments/thumbnail-images/" +
                                            e.thumbnail_image.toString(),
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
                                    ),
                                    Expanded(
                                        child: Container(
                                      padding: EdgeInsets.only(
                                          top: 20, left: 10, right: 10),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  e.user_id,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.5,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Text(
                                                _formattedDate(DateTime.parse(
                                                        e.start_date)) +
                                                    ' - ' +
                                                    _formattedDate(
                                                        DateTime.parse(
                                                            e.end_date)),
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.5,
                                                )),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Text("\Q",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                Text(
                                                    e.grand_total ?? "Sin info",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ],
                                            )
                                          ]),
                                    ))
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    )
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
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(children: [
        SizedBox(
          height: 35.0,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mis Reservaciones",
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xff333D55),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ]),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Jenner Otoniel Bamac Gomez",
              style: TextStyle(fontSize: 16),
            ),
          ],
        )
      ]),
    );
  }

  String _formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
