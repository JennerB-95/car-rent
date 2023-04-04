import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:car_rental/models/equipment.dart';
import 'package:car_rental/pages/booking_cars/booking_cars.dart';
import 'package:car_rental/services/equipment_service.dart';
import 'package:car_rental/shared/widgets/images_widget3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:share/share.dart';
//import 'package:html/parser.dart';
import '../../core.dart';

class BookCarView extends StatefulWidget {
  final Equipment car;

  const BookCarView({Key key, @required this.car}) : super(key: key);
  @override
  State<BookCarView> createState() => _BookCarViewState();
}

class _BookCarViewState extends State<BookCarView>
    with TickerProviderStateMixin {
  AnimationController _colorAnimationController;
  Animation _colorTween, _iconColorTween;
  // ScrollController      _scrollController;
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 500);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  @override
  void initState() {
    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.white, end: Colors.white)
        .animate(_colorAnimationController);
    _iconColorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_colorAnimationController);
    super.initState();
    // _scrollController = new ScrollController();
    _controller = AnimationController(vsync: this, duration: _duration);
    super.initState();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 350);
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: _body(),
      bottomNavigationBar: buildFooter(),
    );
  }

  Widget _body() {
    return SizedBox.expand(
      child: NotificationListener<ScrollNotification>(
          onNotification: _scrollListener,
          child: CustomScrollView(
            slivers: [
              _images(),
              SliverList(delegate: SliverChildListDelegate([_description()]))
            ],
          )),
    );
  }

  Widget _images() {
    List carsImages = jsonDecode(widget.car.slider_images);
    List<String> imagesSlider = carsImages
        .map((car) =>
            "https://rentcarapex.ceandb.com/assets/img/equipments/slider-images/${car.toString()}")
        .toList();
    return Container(
        child: AnimatedBuilder(
      animation: _colorAnimationController,
      builder: (BuildContext context, child) => SliverAppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(10.0),
            height: 40,
            width: 40,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.black.withOpacity(0.5)),
            child: Icon(
              FeatherIcons.chevronLeft,
              color: Colors.white,
              size: 35.0,
            ),
          ),
        ),
        /* IconButton(
            onPressed: () => Navigator.pop(context),
            icon:
                Icon(FeatherIcons.x, color: _iconColorTween.value, size: 25.0)),*/
        actionsIconTheme: IconThemeData(
          size: 35.0,
          color: _iconColorTween.value,
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: _colorTween.value,
        expandedHeight: MediaQuery.of(context).size.width > 500 ? 600 : 300.0,
        floating: true,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            background: SafeArea(
              child: Stack(
                children: <Widget>[
                  ImagesWidget3(
                    images: imagesSlider,
                    isExpanded: false,
                  ),
                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      alignment: Alignment.bottomCenter,
                      height:
                          MediaQuery.of(context).size.width > 500 ? 600 : 300.0,
                    ),
                  )
                ],
              ),
            )),
      ),
    ));
    /*
    return Container(
      child: ImagesWidget3(
        images: imagesSlider,
        isExpanded: false,
      ),
    );*/
  }

  Widget _description() {
    return Container(
      child: FadeInUp(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TitleWidget(title: widget.car.title, subtitle: widget.car.name),
            SizedBox(height: 17),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildPricePerPeriod("Q${widget.car.per_day_price}/Día"),
                  SizedBox(width: 16),
                  _buildPricePerPeriod("Q${widget.car.per_week_price}/Semana"),
                ],
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_parseHtmlString(widget.car.description),
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15.0)),
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
              child: Text(widget.car.features,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15.0)),
            ),
            SizedBox(height: 17),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(context) {
    List carsImages = jsonDecode(widget.car.slider_images);
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
          ),
          SizedBox(height: 17),
          FadeInUp(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWidget(title: widget.car.title, subtitle: widget.car.name),
                SizedBox(height: 17),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildPricePerPeriod("Q${widget.car.per_day_price}/Día"),
                      SizedBox(width: 16),
                      _buildPricePerPeriod(
                          "Q${widget.car.per_week_price}/Semana"),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(widget.car.description,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 15.0)),
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                      Text("Características", style: TextStyle(fontSize: 25.0)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(widget.car.features,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 15.0)),
                ),
                SizedBox(height: 17),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }*/

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
                "Q${widget.car.per_day_price}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: BookingCarsPage(
                    car: widget.car,
                  ));
            },
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

  Widget _buildPricePerPeriod(price) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(right: 14, left: 14, bottom: 20.0, top: 20.0),
        decoration: BoxDecoration(
          color: Color(0xff333D55),
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

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }
}
