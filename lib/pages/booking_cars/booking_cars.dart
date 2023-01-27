import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core.dart';
import '../../services/date_time_picker.dart';
import 'package:http/http.dart' as http;

enum SingingCharacter { pick_up, delivery }

class BookingCarsPage extends StatefulWidget {
  const BookingCarsPage({Key key}) : super(key: key);

  @override
  State<BookingCarsPage> createState() => _BookingCarsPageState();
}

class _BookingCarsPageState extends State<BookingCarsPage> {
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

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString("user_id");
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

    print(
        " user data $uid $username $first_name $last_name $contact_number $emailU $dpiPasaporte $licencia $tipoLicencia $nit");
    return;
  }

  final argunemtData = Get.arguments;
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  var _startDate = DateTime.now();
  var _endDate = DateTime.now();

  String start_date;
  String end_date;
  String errormsg;
  bool error, showprogress;
  bool showPassword = true;
  var _pay = ['Depósito Bancario'];
  String _primary = 'Seleccione método de pago';

  Future saveBooking() async {
    print(argunemtData[0]['equipment_id']);
    var url = "http://api-apex.ceandb.com/bookingAdd.php";
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(<String, String>{
          "name": first_name + last_name,
          "email": emailU,
          "contact_number": contact_number,
          "start_date": start_date,
          "end_date": end_date,
          "user_id": uid,
          "equipment_id": argunemtData[0]['equipment_id'],
        }));
    print("body ${response.body}");
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      print(jsondata["status"]);
      if (jsondata["status"] == false) {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = jsondata["message"];
        });
      } else {
        if (jsondata["status"] == true) {
          setState(() {
            error = false;
            showprogress = false;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainView()));
        } else {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Something went wrong.";
        }
      }
    } else {
      setState(() {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = "Error connecting to server.";
      });
    }
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
                "Reserva de ${username}",
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
                right: 16,
              ),
              margin: EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    horizontalTitleGap: 0.0,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    leading: Icon(Icons.person),
                    title: Text('${first_name}' + ' ' + '${last_name}'),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    horizontalTitleGap: 0.0,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    leading: Icon(Icons.phone),
                    title: Text('${contact_number}'),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    horizontalTitleGap: 0.0,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    leading: Icon(Icons.email),
                    title: Text('${emailU}'),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: MyDateTimePicker(
                          maxNow: false,
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
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: MyDateTimePicker(
                          maxNow: false,
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
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  buildActionButton(),

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
            onTap: () => saveBooking(),
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

  Widget buildActionButton() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: ElevatedButton(
          child: const Text('Agregar conductores autorizados'),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text('Modal BottomSheet'),
                        ElevatedButton(
                          child: const Text('Close BottomSheet'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xff333D55),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            elevation: 0.2,
            textStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
