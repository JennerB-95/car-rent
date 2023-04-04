import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:car_rental/core.dart';
import 'package:car_rental/models/my_booking.dart';
import 'package:car_rental/pages/booking_cars/booking_detail.dart';
import 'package:car_rental/services/my_booking.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../models/conductor_auth.dart';
import '../../models/equipment.dart';
import '../../models/user_model.dart';
import '../../services/conductor_auth_service.dart';
import '../../services/date_time_picker.dart';
import 'package:http/http.dart' as http;

import '../../services/equipment_service.dart';
import '../booking_cars/select_equipment.dart';

class BookingList extends StatefulWidget {
  const BookingList({Key key}) : super(key: key);

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var booking = [];
  final List<String> entries = <String>['A', 'B', 'C'];
  bool adminLogin = false;
  String selectedUser;
  String selectedCar;
  String _userName = "";
  String _userLastName = "";
  List<String> _filters = [];
  var _startDate = DateTime.now();
  var _endDate = DateTime.now();
  String perWeekPriceCar;
  String perDayPriceCar;

  String start_date;
  String end_date;
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController _nombreAux = TextEditingController();
  TextEditingController _direccionAux = TextEditingController();
  TextEditingController _telefonoAux = TextEditingController();
  TextEditingController _fechaNacimientoAux = TextEditingController();
  TextEditingController _driveLicenceAux = TextEditingController();
  TextEditingController _driveLicenceDateAux = TextEditingController();
  TextEditingController _birthDate = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _nitAux = TextEditingController();
  TextEditingController _driverLicenseExpires = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _locationDelivery = TextEditingController();
  TextEditingController _dpiPassportAux = TextEditingController();
  String _choiceChip = " ";
  var _bornDate = DateTime.now();
  var _licenseDate = DateTime.now();
  bool _isVisible = false;
  String licenseType = "";
  String locationDelivery = "";
  DateFormat dateFormat;
  String _dateAge;
  String _driverLicenseExp;
  String errormsg;
  bool error, showprogress;
  bool showPassword = true;
  bool showLocationDelivery = false;
  var licenseTypes = ['A', 'B', "C"];
  var deliveryChoice = ['', 'B', "C"];

  int currentStep = 0;
  String gender;
  bool numberOfDays = false;
  int _numberOfDays = 0;
  String _maxOfDays = "";
  String total = "";
  bool deliveryCar = false;
  String days = "Seleccione la fecha de la reserva";
  String uid,
      username,
      first_name,
      last_name,
      contact_number,
      emailU,
      dpiPasaporte,
      licencia,
      tipoLicencia,
      nit,
      dpiPassAuth;

  String selecterAuth1;
  String selecterAuth2;

  @override
  void initState() {
    getInitialInfo();
    super.initState();
  }

  getInitialInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      adminLogin = prefs.getBool("is_admin") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Reservas",
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        //sheroTag: adminId,
        backgroundColor: Color(0xff333D55),
        onPressed: adminLogin
            ? () {
                showMaterialModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: showReservationForm(),
                    );
                  },
                );
              }
            : () => PersistentNavBarNavigator.pushNewScreen(context,
                screen: EquipmentsPage(), withNavBar: true),
        child: Icon(
          FeatherIcons.plus,
          color: Colors.white,
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Color(0xffF8F8F8),
      body: SafeArea(
        child: FutureBuilder(
          future: adminLogin
              ? MisReservasService.fetch()
              : MisReservasService.fetchAll(),
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
              if (_misReservas.length > 0) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GridView.count(
                    physics: ScrollPhysics(),
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 500 ? 2 : 1,
                    crossAxisSpacing: 9.0,
                    mainAxisSpacing: 2.0,
                    shrinkWrap: true,
                    childAspectRatio: 1.4,
                    children: _misReservas.reversed.map((e) {
                      print(e.name);
                      return GestureDetector(
                        onTap: adminLogin
                            ? () {
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    screen: BookingDetail(
                                      id: e.id,
                                      data: e,
                                    ),
                                    withNavBar: true);
                              }
                            : null,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
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
                                height: 130,
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
                                            new AlwaysStoppedAnimation<Color>(
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
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: SingleChildScrollView(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e.title,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.5,
                                                ),
                                              ),
                                              Text(e.name ?? ""),
                                              Text(
                                                  "Fecha de creación ${_formattedDate(DateTime.parse(e.created_at))}"),
                                              Divider(),
                                              Text(
                                                  "Del " +
                                                      _formattedDate(
                                                          DateTime.parse(
                                                              e.start_date)) +
                                                      ' al ' +
                                                      _formattedDate(
                                                          DateTime.parse(
                                                              e.end_date)),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    height: 1.5,
                                                  )),
                                              SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  Text("\Q",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  Text(
                                                      e.grand_total ??
                                                          "Sin info",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(e.location ?? ""),
                                              Text(
                                                  "Dias:  ${_numberOfDaysString(DateTime.parse(e.end_date), DateTime.parse(e.start_date))}")
                                            ]),
                                      )))
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              } else {
                return Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FeatherIcons.clipboard,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Lista de reservas está vacía.",
                          style: TextStyle(fontSize: 17.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  String _numberOfDaysString(DateTime day1, DateTime day2) {
    String days;
    days = (day1.difference(day2).inDays + 1).toString();
    return days;
  }

  Widget showReservationForm() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return FadeInUp(
            child: Container(
          color: Color(0xffF8F8F8),
          margin: EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              SafeArea(
                child: Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.grey, size: 27.0),
                  ),
                ),
              ),
              Expanded(
                child: CoolStepper(
                  config: CoolStepperConfig(
                      icon: Icon(
                        FeatherIcons.userCheck,
                      ),
                      backText: "ANTERIOR",
                      nextText: 'SIGUIENTE',
                      stepText: 'PASO',
                      ofText: 'DE',
                      finalText: ''),
                  onCompleted: () {},
                  steps: <CoolStep>[
                    CoolStep(
                      title: "Cliente",
                      subtitle: "Selecciona al cliente para la reserva",
                      validation: () => null,
                      content: Container(
                        child: FutureBuilder(
                          future: UserService.fetchAll(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
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
                              List<User> _users = snapshot.data;
                              return Container(
                                child: SingleChildScrollView(
                                  child: Column(
                                      children: ListTile.divideTiles(
                                    context: context,
                                    tiles: _users.reversed
                                        .where((element) => element.id != "40")
                                        .map((e) {
                                      if (e.firstName != null ||
                                          e.lastName != null) {
                                        return ListTile(
                                          tileColor: Colors.grey,
                                          leading: Icon(
                                            MdiIcons.accountCircle,
                                            size: 35.0,
                                            color: Colors.grey,
                                          ),
                                          selected: true,
                                          onTap: () {
                                            setState(() {
                                              selectedUser = e.id;
                                              _userName = e.firstName;
                                              _userLastName = e.lastName;
                                              contact_number = e.contactNumber;
                                              emailU = e.email;
                                            });
                                            _showConductorAuth();
                                          },
                                          selectedColor: selectedUser == e.id
                                              ? kPrimaryColor
                                              : Colors.black,
                                          title: Text(
                                              "${e.firstName ?? 'Usuario'} ${e.id}"),
                                          subtitle: Text(
                                              "${e.lastName ?? 'Usuario'}"),
                                        );
                                      }
                                    }).toList(),
                                  )),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    CoolStep(
                        title: "Vehículo",
                        subtitle: "Seleccione el vehículo para la reserva",
                        validation: () => null,
                        content: Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, bottom: 15.0),
                              child: Text(
                                "Disponibles",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            FutureBuilder(
                                future: EquipmentService.fetchAll(),
                                builder: (context, snapshot) {
                                  if (snapshot.data == null) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                          Color(0xff333D55),
                                        ),
                                      ),
                                    );
                                  } else {
                                    List<Equipment> equipments = snapshot.data;

                                    return Column(
                                        children: ListTile.divideTiles(
                                      context: context,
                                      tiles: equipments
                                          .map((car) => ListTile(
                                                tileColor: Colors.grey,
                                                leading: Image.network(
                                                  "https://rentcarapex.ceandb.com/assets/img/equipments/thumbnail-images/${car.thumbnail_image.toString()}",
                                                  height: 100.0,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent
                                                              loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2.0,
                                                        backgroundColor:
                                                            Colors.white,
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
                                                selected: true,
                                                onTap: () {
                                                  setState(() {
                                                    selectedCar =
                                                        car.equipment_id;
                                                    perWeekPriceCar =
                                                        car.per_week_price;
                                                    perDayPriceCar =
                                                        car.per_day_price;
                                                  });
                                                },
                                                selectedColor: selectedCar ==
                                                        car.equipment_id
                                                    ? kPrimaryColor
                                                    : Colors.black,
                                                title: Text("${car.title} "),
                                                subtitle: Text("${car.name}"),
                                              ))
                                          .toList(),
                                    ));
                                  }
                                }),
                          ],
                        ))),
                    CoolStep(
                        title: "Datos de la reserva",
                        subtitle: "Llene los siguientes campos",
                        content: Container(
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xffe9ecef).withOpacity(0.7),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FeatherIcons.calendar,
                                        color: Colors.grey,
                                      ),
                                      VerticalDivider(),
                                      Text(
                                        "$days",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () => {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder:
                                              (BuildContext context, setState) {
                                            return Dialog(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Seleccione la fecha",
                                                      style: TextStyle(
                                                          fontSize: 18.0),
                                                    ),
                                                    SizedBox(
                                                      height: 15.0,
                                                    ),
                                                    Visibility(
                                                        visible: numberOfDays,
                                                        child: Text(
                                                          _maxOfDays,
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color: _numberOfDays <
                                                                          1 ||
                                                                      _numberOfDays >
                                                                          7
                                                                  ? Colors
                                                                      .redAccent
                                                                  : Colors
                                                                      .grey),
                                                        )),
                                                    SizedBox(height: 15),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      child: Container(
                                                        color: Color(0xff333D55)
                                                            .withOpacity(0.02),
                                                        child:
                                                            SfDateRangePicker(
                                                          confirmText:
                                                              "Aceptar",
                                                          cancelText:
                                                              "Cancelar",
                                                          onCancel: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          onSubmit:
                                                              (Object value) {
                                                            if (value
                                                                is PickerDateRange) {
                                                              setState(() {
                                                                _startDate = value
                                                                    .startDate;
                                                                _endDate = value
                                                                    .endDate;
                                                                numberOfDays =
                                                                    true;
                                                                _numberOfDays = _endDate
                                                                        .difference(
                                                                            _startDate)
                                                                        .inDays +
                                                                    1;
                                                                end_date = _endDate
                                                                    .toString();
                                                              });
                                                              switch (
                                                                  _numberOfDays) {
                                                                case 0:
                                                                  _maxOfDays =
                                                                      "El número de días debe ser mayor a 1";
                                                                  break;

                                                                case 1:
                                                                case 2:
                                                                case 3:
                                                                case 4:
                                                                case 5:
                                                                case 6:
                                                                case 7:
                                                                  _maxOfDays =
                                                                      "Número de días: $_numberOfDays";
                                                                  _formattedDate2(
                                                                      _startDate,
                                                                      _endDate);
                                                                  Navigator.pop(
                                                                      context);
                                                                  break;
                                                                default:
                                                                  _maxOfDays =
                                                                      "Los días máximos de reserva son de: 7";
                                                                  break;
                                                              }
                                                              _sumPricePerDays(
                                                                  perWeekPriceCar,
                                                                  perDayPriceCar);
                                                            }
                                                          },
                                                          selectionMode:
                                                              DateRangePickerSelectionMode
                                                                  .range,
                                                          monthFormat: "MMM",
                                                          minDate:
                                                              DateTime.now(),
                                                          showActionButtons:
                                                              true,
                                                          backgroundColor:
                                                              Color(0xff333D55)
                                                                  .withOpacity(
                                                                      0.04),
                                                          viewSpacing: 15.0,
                                                          selectionColor:
                                                              Color(0xff333D55),
                                                          rangeSelectionColor:
                                                              Color(0xff333D55)
                                                                  .withOpacity(
                                                                      0.2),
                                                          startRangeSelectionColor:
                                                              Color(0xff333D55),
                                                          endRangeSelectionColor:
                                                              Color(0xff333D55),
                                                          headerStyle:
                                                              DateRangePickerHeaderStyle(
                                                            textAlign: TextAlign
                                                                .center,
                                                            textStyle: TextStyle(
                                                                color: Color(
                                                                    0xff333D55),
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      })
                                },
                              ),
                              SizedBox(height: 15),
                              Visibility(
                                  visible: numberOfDays,
                                  child: FadeInUp(
                                    child: Text(
                                      _maxOfDays,
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          color: _numberOfDays < 1 ||
                                                  _numberOfDays > 7
                                              ? Colors.redAccent
                                              : Colors.black),
                                    ),
                                  )),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile(
                                      activeColor: Color(0xff333D55),
                                      title: Text("Recoger"),
                                      value: "recoge",
                                      groupValue: gender,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value.toString();
                                          _locationDelivery.text = "Recoger";
                                          deliveryCar = false;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile(
                                      activeColor: Color(0xff333D55),
                                      title: Text("Entrega"),
                                      value: "entrega",
                                      groupValue: gender,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value.toString();
                                          _locationDelivery.text = "";
                                          deliveryCar = true;
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content:
                                                  _buildTextLocationDlivery(),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              deliveryCar
                                  ? Container()
                                  : Text(
                                      "Recoger en local",
                                      style: TextStyle(
                                        fontSize: 17.0,
                                      ),
                                    ),
                              SizedBox(
                                height: 25.0,
                              ),
                              Divider(),
                              SizedBox(
                                height: 25.0,
                              ),
                              InkWell(
                                onTap: (_numberOfDays < 1 || _numberOfDays > 7)
                                    ? null
                                    : () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          behavior: SnackBarBehavior.fixed,
                                          content: Text('Registrando...'),
                                          duration: Duration(seconds: 4),
                                        ));

                                        Future.delayed(Duration(seconds: 6),
                                            () {
                                          saveBooking();
                                        });
                                      },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        (_numberOfDays < 1 || _numberOfDays > 7)
                                            ? Colors.grey
                                            : Color(0xff333D55),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Reserva Ahora",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              // fontSize: 16,
                                            ),
                                          ),
                                          Icon(
                                            FeatherIcons.chevronRight,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        validation: () => null)
                  ],
                ),
              )
            ],
          ),
        ));
      },
    );
  }

  void _showConductorAuth() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Conductor autorizado (opcional)"),
                Text(
                  "Nota: Solo puedes seleccionar a 2",
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ],
            ),
            content: Container(
              child: StatefulBuilder(builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder(
                      future: ConductorAuthService.fetchAllByUser(selectedUser),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                              Color(0xff333D55),
                            ),
                          );
                        } else {
                          List<ConductorAutorizado> _drivers = snapshot.data;
                          if (_drivers.length == 0) {
                            return Text(
                              "Este usuario no tiene conductores autorizados.",
                              style: TextStyle(color: Colors.grey),
                            );
                          } else {
                            return Container(
                              child: Wrap(
                                children: _drivers
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: FilterChip(
                                          backgroundColor: Colors.white,
                                          side: BorderSide(color: Colors.grey),
                                          label: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text("${e.nombre_aux} ",
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: (_filters
                                                            .contains(e.id))
                                                        ? Colors.white
                                                        : Colors.black)),
                                          ),
                                          selected: _filters.contains(e.id),
                                          selectedColor: Color(0xff333D55),
                                          checkmarkColor: Colors.white,
                                          onSelected: (bool selected) {
                                            if (this.mounted) {
                                              setState(() {
                                                if (_filters.length < 2) {
                                                  if (selected) {
                                                    _filters.add(e.id);
                                                    selecterAuth1 = _filters[0];
                                                    if (_filters
                                                        .asMap()
                                                        .containsKey(1)) {
                                                      selecterAuth2 =
                                                          _filters[1];
                                                    } else {
                                                      print("no");
                                                    }
                                                  } else {
                                                    _filters.removeWhere(
                                                        (String id) {
                                                      return id == e.id;
                                                    });
                                                  }
                                                } else {
                                                  _filters
                                                      .removeWhere((String id) {
                                                    return id == e.id;
                                                  });
                                                }
                                              });
                                            }
                                            //selecterAuth2 = _filters[1];
                                            if (_filters.length == 2) {
                                              selecterAuth1 = _filters[0];
                                              selecterAuth2 = _filters[1];
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () => showMaterialModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              color: Colors.white,
                              child: buildDriverForm(context),
                            );
                          },
                        ),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 25.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Color(0xff333D55))),
                            child: Icon(FeatherIcons.userPlus)),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Divider(),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("$selecterAuth1 $selecterAuth1 ola ");
                            if (_filters.isNotEmpty) {
                              setState(() => _filters.clear());
                            }
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 25.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Color(0xff333D55))),
                              child: Text("No agregar")),
                        ),
                        VerticalDivider(),
                        GestureDetector(
                          onTap: _filters.isEmpty
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 25.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color(0xff333D55)),
                              child: Text(
                                "Agregar",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }

  Widget buildDriverForm(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        FeatherIcons.x,
                        color: Colors.grey,
                      )),
                ),
                Text(
                  "Conductor autorizado",
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffe9ecef).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Nombre completo",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(
                          FeatherIcons.user,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(15.0)),
                    controller: _nombreAux,
                  ),
                ),
                SizedBox(height: 15),
                MyDateTimePicker(
                  text: 'Fecha de nacimiento',
                  ctrl: _birthDate,
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'La fecha de nacimiento es requerida';
                    }
                    return null;
                  },
                  dateTime: _bornDate,
                  onChange: (date) {
                    setState(() {
                      _bornDate = date;
                      _dateAge = _bornDate.toString();
                    });
                  },
                ),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffe9ecef).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Dirección",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(
                          FeatherIcons.mapPin,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(15.0)),
                    controller: _direccionAux,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffe9ecef).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            FeatherIcons.creditCard,
                            color: Colors.grey,
                          ),
                          hintText: 'DPI/Pasaporte',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(15.0)),
                      controller: _dpiPassportAux,
                      validator: ((value) {
                        if (value.isEmpty) return "Campo vacío";
                        setState(() {
                          dpiPassAuth = value;
                        });
                        return null;
                      })),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xffe9ecef).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Teléfono",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(
                                FeatherIcons.phone,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(15.0)),
                          controller: _phone,
                        ),
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xffe9ecef).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextFormField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  FeatherIcons.creditCard,
                                  color: Colors.grey,
                                ),
                                hintText: 'Nit',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.all(15.0)),
                            controller: _nitAux,
                            validator: ((value) {
                              if (value.isEmpty) return "Campo vacío";
                              return null;
                            })),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffe9ecef).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: TextFormField(
                    maxLength: 13,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          FeatherIcons.creditCard,
                          color: Colors.grey,
                        ),
                        hintText: "Número de licencia",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(15.0)),
                    controller: _driveLicenceAux,
                    validator: ((value) {
                      if (value.isEmpty) return "Campo vacío";
                      if (value != _password)
                        return "No coincide la contraseña";
                      return null;
                    }),
                  ),
                ),
                SizedBox(height: 15),
                MyDateTimePicker(
                  maxNow: false,
                  text: 'Fecha de vencimiento',
                  ctrl: _driverLicenseExpires,
                  validator: (value) {
                    if (value.trim().isEmpty) {
                      return 'La fecha es requerida';
                    }
                    return null;
                  },
                  dateTime: _licenseDate,
                  onChange: (date) {
                    setState(() {
                      _licenseDate = date;
                      _driverLicenseExp = _licenseDate.toString();
                    });
                  },
                ),
                SizedBox(height: 15),
                Divider(),
                Text(
                  "Tipo de licencia",
                  style: TextStyle(fontSize: 19.0),
                ),
                SizedBox(height: 5),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 15.0,
                  children: licenseTypes
                      .map(
                        (item) => Container(
                          child: ChoiceChip(
                            backgroundColor: Colors.transparent,
                            shape: StadiumBorder(
                                side: BorderSide(color: Colors.grey)),
                            elevation: 0.0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 7.0),
                            label: Text('$item',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: (licenseType == item)
                                        ? Colors.white
                                        : Colors.black)),
                            onSelected: (value) {
                              setState(() {
                                licenseType = item.toString();
                              });
                            },
                            selected: licenseType == item,
                            selectedColor: Color(0xff333D55),
                          ),
                        ),
                      )
                      .toList(),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Color(0xff333D55)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Color(0xff333D55),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 40.0),
                        elevation: 0.0,
                        textStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    buildSaveAction(context)
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildSaveAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        register(context);
      },
      child: Text(
        "Guardar",
        style: TextStyle(color: Colors.white, fontSize: 15.0),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 40.0),
        ),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
        backgroundColor: MaterialStateProperty.all(Color(0xff333D55)),
      ),
    );
  }

  Future register(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.fixed,
      content: Text('Registrando...'),
      duration: Duration(seconds: 4),
    ));
    var url = "http://api-apex.ceandb.com/createConductorAux.php";
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(<String, dynamic>{
          "id_user": selectedUser,
          "nombre_aux": _nombreAux.text,
          "direccion_aux": _direccionAux.text,
          "telefono_aux": _phone.text,
          "fecha_nacimiento": _bornDate.toString(),
          "dpi_pass_aux": _dpiPassportAux.text,
          "licencia_aux": _driveLicenceAux.text,
          "licencia_vence_aux": _driverLicenseExp,
          "tipo_licenca_aux": licenseType,
          "nit_aux": _nitAux.text,
        }));

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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.fixed,
            content: Text('¡Registro creado correctamente!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ));
          setState(() {
            ConductorAuthService.fetchAllByUser(selectedUser);
          });
          Future.delayed(Duration(seconds: 1), (() {
            Navigator.pop(context);
            Navigator.pop(context);
          }));
          Future.delayed(Duration(seconds: 1), (() {
            _showConductorAuth();
          }));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.fixed,
            content: Text('¡Ha ocurrido un error, inténtelo de nuevo!'),
            backgroundColor: Colors.red[400],
            duration: Duration(seconds: 8),
          ));
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Algo salió mal.";
        }
      }
    } else {
      setState(() {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = "Error al conectar al servidor.";
      });
    }
  }

  Future saveBooking() async {
    var url = "http://api-apex.ceandb.com/bookingAdd.php";
    final response = await http.post(Uri.parse(url), body: {
      "id_user": selectedUser,
      "id_user_auth_one": selecterAuth1 ?? 43.toString(),
      "id_user_auth_dos": selecterAuth2 ?? 43.toString(),
      "booking_number": _generateRandomBookingNumber(),
      "name": "$_userName $_userLastName",
      "contact_number": contact_number,
      "email": emailU,
      "equipment_id": selectedCar,
      "start_date": _startDate.toString(),
      "end_date": end_date.toString(),
      "grand_total": total.toString(),
      "created_at": DateTime.now().toString(),
      "updated_at": DateTime.now().toString(),
      "location": _locationDelivery.text
    });
    print("body ${response.body}");
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);

      if (jsondata["status"] == false) {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = jsondata["message"];
        });
      } else {
        if (jsondata["status"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.fixed,
            content: Text('¡Registro creado correctamente!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ));
          Future.delayed(Duration(seconds: 4), () {
            Navigator.pop(context);
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => LoginView()));
          });

          setState(() {
            error = false;
            showprogress = false;
            _filters.clear();
            selectedCar = null;
            selectedUser = null;
            _locationDelivery.text = '';
            _startDate = null;
            end_date = null;
          });
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

  String _generateRandomBookingNumber() {
    var random = new Random();
    int min = 10;
    int max = 100000;
    int result = min + random.nextInt(max - min);

    return result.toString();
  }

  String _formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formattedDate2(DateTime date1, DateTime date2) {
    String _startDate = "";
    String _endDate = "";

    _startDate = DateFormat.yMd("es").format(date1);
    _endDate = DateFormat.yMd("es").format(date2);

    return days = "$_startDate - $_endDate";
  }

  Widget _buildTextLocationDlivery() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Indíquenos su dirección de entrega",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffe9ecef).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: TextField(
                    controller: _locationDelivery,
                    onChanged: (v) {
                      setState(() {
                        locationDelivery = v;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: 'Escriba aquí',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.all(15.0)),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          showLocationDelivery = true;
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Color(0xff333D55)),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xff333D55)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 20.0),
                        elevation: 0.0,
                        textStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('Aceptar'),
                      onPressed: () {
                        setState(() {
                          showLocationDelivery = true;
                          locationDelivery = _locationDelivery.text;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff333D55),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 20.0),
                        elevation: 0.0,
                        textStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  String _sumPricePerDays(String weekPrice, String dayPrice) {
    setState(() {
      if (_numberOfDays == 7 || _numberOfDays > 7) {
        total = weekPrice;
      } else {
        double sum = double.parse(dayPrice ?? "0") * _numberOfDays;
        total = sum.toString();
      }
    });

    return total;
  }
}
