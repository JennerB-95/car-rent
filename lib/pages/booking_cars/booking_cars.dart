import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:car_rental/models/conductor_auth.dart';
import 'package:car_rental/models/equipment.dart';
import 'package:car_rental/services/conductor_auth_service.dart';
import 'package:car_rental/services/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../core.dart';
import 'package:http/http.dart' as http;

enum SingingCharacter { pick_up, delivery }

class BookingCarsPage extends StatefulWidget {
  final Equipment car;

  const BookingCarsPage({Key key, @required this.car}) : super(key: key);

  @override
  State<BookingCarsPage> createState() => _BookingCarsPageState();
}

class _BookingCarsPageState extends State<BookingCarsPage> {
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

  List<String> _filters = [];

  Future register() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.fixed,
      content: Text('Registrando...'),
      duration: Duration(seconds: 4),
    ));
    var url = "http://api-apex.ceandb.com/createConductorAux.php";
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(<String, dynamic>{
          "id_user": uid,
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
            content: Text('??Registro creado correctamente!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ));
          ConductorAuthService.fetchAll();

          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => LoginView()));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.fixed,
            content: Text('??Ha ocurrido un error, int??ntelo de nuevo!'),
            backgroundColor: Colors.red[400],
            duration: Duration(seconds: 8),
          ));
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Algo sali?? mal.";
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

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      total = widget.car.per_day_price;
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

    return;
  }

  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  var _startDate = DateTime.now();
  var _endDate = DateTime.now();

  String start_date;
  String end_date;

  Future saveBooking() async {
    var url = "http://api-apex.ceandb.com/bookingAdd.php";
    final response = await http.post(Uri.parse(url), body: {
      "id_user": uid,
      "booking_number": _generateRandomBookingNumber(),
      "name": "$first_name $last_name",
      "contact_number": contact_number,
      "email": emailU,
      "equipment_id": widget.car.equipment_id.toString(),
      "start_date": _startDate.toString(),
      "end_date": end_date.toString(),
      "grand_total": total,
      "created_at": DateTime.now().toString(),
      "updated_at": DateTime.now().toString(),
      "location": _locationDelivery.text
    });
    print("body ${response.body}");
    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: BookingList(), withNavBar: true);
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
          PersistentNavBarNavigator.pushNewScreen(context,
              withNavBar: true, screen: BookingList());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: SafeArea(
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
      bottomNavigationBar: buildFooter(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            FeatherIcons.chevronLeft,
            color: Colors.black,
            size: 35.0,
          ),
        ),
        title: Text(
          "${widget.car.title} ${widget.car.name}",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xffF8F8F8),
      ),
    );
  }

  Widget buildBody() {
    return FadeInUp(
      child: Container(
        decoration: BoxDecoration(color: Color(0xffF8F8F8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(13.0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    "Precio",
                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                  color: Color(0xff333D55),
                ),
                Container(
                  padding: EdgeInsets.all(13.0),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    "Q${total}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17.0,
                        color: Color(0xff333D55),
                        fontWeight: FontWeight.bold),
                  ),
                  color: Color(0xffBEBEBE),
                )
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(left: 16.0),
                  decoration: BoxDecoration(
                      color: Color(0xffE7E7ED),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    "Q${widget.car.per_day_price}/D??a",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xff333D55),
                    ),
                  ),
                ),
                VerticalDivider(),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Q${widget.car.per_week_price}/Semana",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xff333D55),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xffE7E7ED),
                      borderRadius: BorderRadius.circular(10.0)),
                )
              ],
            ),
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
                  Divider(),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Color(0xffe9ecef).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10.0)),
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
                              builder: (BuildContext context, setState) {
                                return Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Seleccione la fecha",
                                          style: TextStyle(fontSize: 18.0),
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
                                                  color: _numberOfDays < 1 ||
                                                          _numberOfDays > 7
                                                      ? Colors.redAccent
                                                      : Colors.grey),
                                            )),
                                        SizedBox(height: 15),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Container(
                                            color: Color(0xff333D55)
                                                .withOpacity(0.02),
                                            child: SfDateRangePicker(
                                              confirmText: "Aceptar",
                                              cancelText: "Cancelar",
                                              onCancel: () =>
                                                  Navigator.pop(context),
                                              onSubmit: (Object value) {
                                                if (value is PickerDateRange) {
                                                  setState(() {
                                                    _startDate =
                                                        value.startDate;
                                                    _endDate = value.endDate;
                                                    numberOfDays = true;
                                                    _numberOfDays = _endDate
                                                            .difference(
                                                                _startDate)
                                                            .inDays +
                                                        1;
                                                    end_date =
                                                        _endDate.toString();
                                                  });
                                                  switch (_numberOfDays) {
                                                    case 0:
                                                      _maxOfDays =
                                                          "El n??mero de d??as debe ser mayor a 1";
                                                      break;

                                                    case 1:
                                                    case 2:
                                                    case 3:
                                                    case 4:
                                                    case 5:
                                                    case 6:
                                                    case 7:
                                                      _maxOfDays =
                                                          "N??mero de d??as: $_numberOfDays";
                                                      _formattedDate(
                                                          _startDate, _endDate);
                                                      Navigator.pop(context);
                                                      break;
                                                    default:
                                                      _maxOfDays =
                                                          "Los d??as m??ximos de reserva son de: 7";
                                                      break;
                                                  }
                                                  _sumPricePerDays();
                                                }
                                              },
                                              selectionMode:
                                                  DateRangePickerSelectionMode
                                                      .range,
                                              monthFormat: "MMM",
                                              minDate: DateTime.now(),
                                              showActionButtons: true,
                                              backgroundColor: Color(0xff333D55)
                                                  .withOpacity(0.04),
                                              viewSpacing: 15.0,
                                              selectionColor: Color(0xff333D55),
                                              rangeSelectionColor:
                                                  Color(0xff333D55)
                                                      .withOpacity(0.2),
                                              startRangeSelectionColor:
                                                  Color(0xff333D55),
                                              endRangeSelectionColor:
                                                  Color(0xff333D55),
                                              headerStyle:
                                                  DateRangePickerHeaderStyle(
                                                textAlign: TextAlign.center,
                                                textStyle: TextStyle(
                                                    color: Color(0xff333D55),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w400),
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
                              color: _numberOfDays < 1 || _numberOfDays > 7
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
                              deliveryCar = true;
                            });

                            showModalBottomSheet<void>(
                              context: context,
                              backgroundColor: Colors.white,
                              builder: (BuildContext context) {
                                return SafeArea(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height,
                                    color: Colors.white,
                                    child: _buildTextLocationDlivery(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 15),
                  Text(
                    'Conductores autorizados (opcional)',
                    style: TextStyle(fontSize: 17.0, color: Colors.grey),
                  ),
                  Text(
                    'Nota: Solo puedes seleccionar a 2.',
                    style: TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  Divider(),
                  FutureBuilder(
                    future: ConductorAuthService.fetchAll(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      } else {
                        List<ConductorAutorizado> _drivers = snapshot.data;
                        if (_drivers.length == 0) {
                          return Text(
                            "No tienes conductores autorizados registrados.",
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
                                                  color:
                                                      (_filters.contains(e.id))
                                                          ? Colors.white
                                                          : Colors.black)),
                                        ),
                                        selected: _filters.contains(e.id),
                                        selectedColor: Color(0xff333D55),
                                        checkmarkColor: Colors.white,
                                        onSelected: (bool selected) {
                                          setState(() {
                                            if (_filters.length < 2) {
                                              if (selected) {
                                                _filters.add(e.id);
                                              } else {
                                                _filters
                                                    .removeWhere((String id) {
                                                  return id == e.id;
                                                });
                                              }
                                            } else {
                                              _filters.removeWhere((String id) {
                                                return id == e.id;
                                              });
                                            }
                                          });
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
                  SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            color: Colors.white,
                            child: buildDriverForm(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formattedDate(DateTime date1, DateTime date2) {
    String _startDate = "";
    String _endDate = "";

    _startDate = DateFormat.yMd("es").format(date1);
    _endDate = DateFormat.yMd("es").format(date2);

    return days = "$_startDate - $_endDate";
  }

  Widget _buildTextLocationDlivery() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 90.0,
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
                            hintText: 'Escriba aqu??',
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
                                vertical: 14, horizontal: 40.0),
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
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: Color(0xff333D55),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 40.0),
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
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            FeatherIcons.x,
                            color: Colors.grey,
                          )),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Ind??quenos su direcci??n de entrega",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _sumPricePerDays() {
    setState(() {
      if (_numberOfDays == 7 || _numberOfDays > 7) {
        total = widget.car.per_week_price;
      } else {
        double sum = double.parse(widget.car.per_day_price) * _numberOfDays;
        total = sum.toString();
      }
    });

    return total;
  }

  Widget buildDriverForm() {
    return StatefulBuilder(builder: (context, setState) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                      hintText: "Direcci??n",
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
                    keyboardType: TextInputType.number,
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
                      if (value.isEmpty) return "Campo vac??o";
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
                            hintText: "Tel??fono",
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
                          keyboardType: TextInputType.number,
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
                            if (value.isEmpty) return "Campo vac??o";
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
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        FeatherIcons.creditCard,
                        color: Colors.grey,
                      ),
                      hintText: "N??mero de licencia",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(15.0)),
                  controller: _driveLicenceAux,
                  validator: ((value) {
                    if (value.isEmpty) return "Campo vac??o";
                    if (value != _password) return "No coincide la contrase??a";
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
                  buildSaveAction()
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildSaveAction() {
    return TextButton(
      onPressed: () => register(),
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

  Widget buildFooter() {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            "https://rentcarapex.ceandb.com/assets/img/equipments/thumbnail-images/" +
                widget.car.thumbnail_image.toString(),
            height: 130.0,
          ),
          InkWell(
            onTap: (_numberOfDays < 1 || _numberOfDays > 7)
                ? null
                : () => saveBooking(),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: (_numberOfDays < 1 || _numberOfDays > 7)
                    ? Colors.grey
                    : Color(0xff333D55),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
                  child: Row(
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
          ),
        ],
      ),
    );
  }
}
