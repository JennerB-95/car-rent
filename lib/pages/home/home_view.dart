import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:car_rental/models/equipment.dart';
import 'package:car_rental/pages/home/widgets/header_appbar.dart';
import 'package:car_rental/services/equipment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core.dart';

import 'dart:async';
import "package:http/http.dart" as http;

class HomeView extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildPersistentBottomNavigationNavBar());
  }

  Widget _buildPersistentBottomNavigationNavBar() {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      onItemSelected: (i) {
        setState(() {
          _controller.index = i;
        });
      },
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style3,
      // margin: EdgeInsets.only(bottom: 10.0)
    );
  }

  List<Widget> _buildScreens() {
    return [Home(), BookingList(), ProfileView()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        iconSize: 30.0,
        //textStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold,),
        icon: Icon(FeatherIcons.home),
        //title: 'Inicio',
        activeColorPrimary: Color(0xff333D55),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        iconSize: 30.0,
        // textStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold, ),
        icon: Icon(FeatherIcons.calendar),
        // title: 'Buscar',
        activeColorPrimary: Color(0xff333D55),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        iconSize: 30.0,
        // textStyle: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        icon: Icon(FeatherIcons.user),
        // title: 'Ajustes',
        activeColorPrimary: Color(0xff333D55),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List theData = [];
  String uid,
      username,
      first_name,
      last_name,
      contact_number,
      emailU,
      dpiPasaporte,
      licencia,
      tipoLicencia,
      nit;
  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
      first_name = prefs.getString("first_name");
      last_name = prefs.getString("last_name");
      contact_number = prefs.getString("contact_number");
      emailU = prefs.getString("email");
      dpiPasaporte = prefs.getString("dpiPasaporte");
      licencia = prefs.getString("licencia");
      tipoLicencia = prefs.getString("tipoLicencia");
      nit = prefs.getString("nit");
    });
    print("last name $last_name");
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
                "Bienvenido $first_name $last_name",
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
        FutureBuilder(
            future: EquipmentService.fetchAll(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              } else {
                List<Equipment> equipments = snapshot.data;

                return ImagesWidget(
                    images: equipments
                        .map((car) =>
                            "https://rentcarapex.ceandb.com/assets/img/equipments/thumbnail-images/" +
                            car.thumbnail_image)
                        .toList());
              }
            }),
      ],
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

                  return Column(
                    children: equipments
                        .map((car) => GestureDetector(
                              onTap: () {
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    screen: BookCarView(
                                      car: car,
                                    ));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(color: Colors.white),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                                fontWeight: FontWeight.bold),
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
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 3.0),
                                                padding: EdgeInsets.all(10.0),
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
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 3.0),
                                                padding: EdgeInsets.all(10.0),
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
                  );
                }
              }),
        ),
      ],
    );
  }
}
