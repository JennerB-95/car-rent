import 'dart:convert';

import 'package:car_rental/pages/search/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  Future myBookings() async {
    var url = "http://api-apex.ceandb.com/bookingList.php";
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(<String, String>{
          "user_id": "29",
        }));

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print("responses ${jsondata}");
      print("responses ${jsondata["data"]}");

      print(jsondata["status"]);
      if (jsondata["status"] == false) {
        print('No se pudo realizar la consulta, error.');
      } else {
        if (jsondata["status"] == true) {
          print('Exito.');
          setState(() {
            booking = jsondata["data"];
          });
        } else {
          print('Algo salió mal.');
        }
      }
    } else {
      print('Error al conectar al servidor.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    myBookings();
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
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildHeader(),
                  buildList(context),
                ],
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

  Widget buildList(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return buildContain(context);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  Widget buildContain(BuildContext context) {
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
              albumImage,
              fit: BoxFit.fitHeight,
            ),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Nombre de algo",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  )
                ],
              ),
              Text("Nombre de algo en pequeno",
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
                        fontWeight: FontWeight.bold,
                      )),
                  Text("100.00",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              )
            ]),
          ))
        ],
      ),
    );
  }
}
