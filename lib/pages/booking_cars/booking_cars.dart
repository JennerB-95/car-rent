import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import '../../core.dart';
import '../../services/date_time_picker.dart';

enum SingingCharacter { pick_up, delivery }

class BookingCarsPage extends StatefulWidget {
  const BookingCarsPage({Key key}) : super(key: key);

  @override
  State<BookingCarsPage> createState() => _BookingCarsPageState();
}

class _BookingCarsPageState extends State<BookingCarsPage> {
  final argunemtData = Get.arguments;
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  var _startDate = DateTime.now();
  var _endDate = DateTime.now();

  String name;
  String email;
  String contact_number;
  String start_date;
  String end_date;

  var _pay = ['Depósito Bancario'];
  String _primary = 'Seleccione método de pago';

  @override
  void initState() {
    email = argunemtData[1]["email"];
    name = argunemtData[1]["first_name"] + ' ' + argunemtData[1]["last_name"];
    contact_number = argunemtData[1]["contact_number"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(argunemtData[1]);
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDateRangePicker(
              context: context,
              locale: Locale('es_ES'),
              firstDate: DateTime(DateTime.now().year - 5),
              lastDate: DateTime(DateTime.now().year + 5),
              initialDateRange: DateTimeRange(
                end: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day + 13),
                start: DateTime.now(),
              ),
              builder: (context, child) {
                return Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 400.0,
                      ),
                      child: child,
                    )
                  ],
                );
              });
        },
        tooltip: 'choose date Range',
        child: const Icon(Icons.calendar_today_outlined, color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            height: 100,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                color: Color(0xffF8F8F8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildBody(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildFooter(),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            FeatherIcons.chevronLeft,
            color: Colors.black,
            size: 35.0,
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xffF8F8F8),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBarWidget(
      actions: [
        InkWell(
          onTap: () => OpenDialog.info(
              lottieFilename: LottieFileName.COMING_SOON,
              lottiePadding: EdgeInsets.only(top: 50)),
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Icon(
              Icons.bookmark_border,
              color: Colors.white,
              size: 23,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricePerPeriod(String months, String price, bool selected) {
    return Expanded(
      child: Container(
        height: 95,
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(
            color: Colors.grey[300],
            width: selected ? 0 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              months + " Month",
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(child: Container()),
            Text(
              price,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "IDR",
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: Color(0xffF8F8F8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text(
                "Reserva de ${argunemtData[1]["first_name"]}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 16,
              ),
              margin: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*TableCalendar( 
                    pageJumpingEnabled: true,
                    focusedDay: _selectedDay,
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    locale: 'es_ES',
                    selectedDayPredicate: (day) {
                      return isSameDay(day, _selectedDay);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    rowHeight: 40.0,
                    calendarStyle: CalendarStyle(
                        defaultDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        cellMargin: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 6.0),
                        selectedDecoration: BoxDecoration(
                            color: Color(0xFF0D4A85),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0)),
                        todayDecoration: BoxDecoration(
                            color: Color(0xFF0D4A85).withOpacity(0.5),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0))),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Color(0xFF0D4A85),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Icon(
                          Ionicons.chevron_back,
                          color: Colors.white,
                        ),
                      ),
                      rightChevronIcon: Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Color(0xFF0D4A85),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Icon(
                          Ionicons.chevron_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),*/
                  SizedBox(height: 15),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('${name}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('${contact_number}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text('${email}'),
                  ),
                  SizedBox(height: 15),
                  MyDateTimePicker(
                    label: "De",
                    text: 'Fecha inicio',
                    ctrl: startDate,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'La fecha de inicio es requerida';
                      }
                      return null;
                    },
                    dateTime: _startDate,
                    onChange: (date) {
                      setState(() {
                        _startDate = date;
                        start_date = _startDate.toString();
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  MyDateTimePicker(
                    label: "A",
                    text: 'Fecha fin',
                    ctrl: endDate,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'La fecha fin es requerida';
                      }
                      return null;
                    },
                    dateTime: _endDate,
                    onChange: (date) {
                      setState(() {
                        _endDate = date;
                        end_date = _endDate.toString();
                      });
                    },
                  ),
                  // SizedBox(height: 15),
                  // ListTile(
                  //   title: const Text('Recoger'),
                  //   leading: Radio(
                  //     value: SingingCharacter.pick_up,
                  //     groupValue: _character,
                  //     onChanged: (SingingCharacter value) {
                  //       setState(() {
                  //         _character = value;
                  //       });
                  //     },
                  //   ),
                  // ),
                  // ListTile(
                  //   title: const Text('Entrega bidireccional'),
                  //   leading: Radio(
                  //     value: SingingCharacter.delivery,
                  //     groupValue: _character,
                  //     onChanged: (SingingCharacter value) {
                  //       setState(() {
                  //         _character = value;
                  //       });
                  //     },
                  //   ),
                  // ),
                  // SizedBox(height: 15),
                  // DropdownButton(
                  //   items: _pay
                  //       .map((String a) =>
                  //           DropdownMenuItem(value: a, child: Text(a)))
                  //       .toList(),
                  //   onChanged: ((value) => {
                  //         setState(() {
                  //           _pay = value;
                  //         })
                  //       }),
                  //   hint: Text(_primary),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificationCar(String title, String data) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      margin: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 2),
          Text(
            data,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
          InkWell(
            onTap: () => OpenDialog.info(
                lottieFilename: LottieFileName.COMING_SOON,
                lottiePadding: EdgeInsets.only(top: 50)),
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Reserva Ahora",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
