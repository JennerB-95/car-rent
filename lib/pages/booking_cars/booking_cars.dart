import 'dart:convert';

import 'package:cool_stepper/cool_stepper.dart';
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
  TextEditingController _username = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _dpiPassport = TextEditingController();
  TextEditingController _driveLicence = TextEditingController();
  TextEditingController _driveLicenceDate = TextEditingController();
  TextEditingController _birthDate = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _nit = TextEditingController();
  TextEditingController _driverLicenseExpires = TextEditingController();
  TextEditingController _phone = TextEditingController();

  var _bornDate = DateTime.now();
  var _licenseDate = DateTime.now();
  bool _isVisible = false;
  String licenseType = "";
  String _dateAge;
  String _driverLicenseExp;
  String errormsg;
  bool error, showprogress;
  bool showPassword = true;
  var licenseTypes = ['A', 'B', "C", "M", "E"];
  int currentStep = 0;

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

  Future register() async {
    var url = "http://api-apex.ceandb.com/register.php";
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(<String, String>{
          "username": _username.text,
          "email": _email.text,
          "password": _password.text,
          "first_name": _firstName.text,
          "last_name": _lastName.text,
          "Dpi_Pasaporte": _dpiPassport.text,
          "Fecha_Nacimiento": _dateAge,
          "contact_number": _phone.text,
          "address": _address.text,
          "Nit": _nit.text,
          "Licencia": _driveLicence.text,
          "Vence": _driverLicenseExp,
          "Tipo_Licencia": licenseType
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
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => LoginView()));
          });
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
                return SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: buildDriverForm(),
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

  showSuccessDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Registrando..."),
                SizedBox(
                  height: 15.0,
                ),
                Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      Color(0xff333D55),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
      register();
    });
  }

  Widget buildDriverForm() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          child: CoolStepper(
        config: CoolStepperConfig(
            icon: Icon(
              FeatherIcons.userCheck,
            ),
            backText: "ANTERIOR",
            nextText: 'SIGUIENTE',
            stepText: 'PASO',
            ofText: 'DE',
            finalText: 'FINALIZAR'),
        onCompleted: () => showSuccessDialog(),
        steps: <CoolStep>[
          CoolStep(
              title: "Información conductor",
              subtitle:
                  "Por favor, llene la información en el formulario para poder registrar conductores autorizados.",
              content: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Registro",
                      style: TextStyle(color: Color(0xff333D55), fontSize: 23),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xffe9ecef).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Nombres",
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
                        controller: _firstName,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xffe9ecef).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Apellidos",
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
                        controller: _lastName,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xffe9ecef).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Correo electrónico',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              FeatherIcons.mail,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.all(15.0)),
                        controller: _email,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xffe9ecef).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextFormField(
                          obscureText: showPassword,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                FeatherIcons.lock,
                                color: Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: _changeShowPasswordState,
                                  icon: _suffixIcon()),
                              hintText: 'Contraseña',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(15.0)),
                          controller: _password,
                          validator: ((value) {
                            if (value.isEmpty) return "Campo vacío";
                            return null;
                          })),
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
                        controller: _address,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xffe9ecef).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Nombre de usuario. ej: usuario10",
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
                        controller: _username,
                      ),
                    ),
                  ],
                ),
              ),
              validation: () {
                return;
              }),
          CoolStep(
              title: "Información conductor",
              subtitle: "",
              content: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Información adicional",
                      style: TextStyle(color: Color(0xff333D55), fontSize: 23),
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
                              hintText: 'Nit',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(15.0)),
                          controller: _nit,
                          validator: ((value) {
                            if (value.isEmpty) return "Campo vacío";
                            return null;
                          })),
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
                    SizedBox(height: 15),
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
                          controller: _dpiPassport,
                          validator: ((value) {
                            if (value.isEmpty) return "Campo vacío";

                            return null;
                          })),
                    ),
                    SizedBox(height: 15),
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
                            hintText: "Número de licencia",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.all(15.0)),
                        controller: _driveLicence,
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
                    SizedBox(height: 25),
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
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              child: ChoiceChip(
                                backgroundColor: Colors.transparent,
                                shape: StadiumBorder(
                                    side: BorderSide(color: Colors.grey)),
                                elevation: 0.0,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.0, vertical: 10.0),
                                label: Text('$item',
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        color: (licenseType == item)
                                            ? Colors.white
                                            : Colors.black)),
                                onSelected: (value) {
                                  setState(() {
                                    licenseType = item.toString();
                                  });
                                  print(
                                      "$licenseType $_isVisible ${licenseType == item}");
                                },
                                selected: licenseType == item,
                                selectedColor: Color(0xff333D55),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    Divider(),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
              validation: () {
                return;
              })
        ],
      ));
    });
  }

  Widget _suffixIcon() =>
      Icon(showPassword ? FeatherIcons.eye : FeatherIcons.eyeOff);

  void _changeShowPasswordState() {
    setState(() => showPassword = !showPassword);
  }
}
