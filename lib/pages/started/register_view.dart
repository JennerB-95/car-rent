import 'dart:convert';

import 'package:car_rental/core.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../services/date_time_picker.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController username = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController dpiPassport = TextEditingController();
  TextEditingController driveLicence = TextEditingController();
  TextEditingController driveLicenceDate = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nit = TextEditingController();
  TextEditingController driverLicenseExpires = TextEditingController();
  TextEditingController phone = TextEditingController();

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

  Future register() async {
    var url = "http://api-apex.ceandb.com/register.php";
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(<String, String>{
          "username": username.text,
          "email": email.text,
          "password": password.text,
          "first_name": firstName.text,
          "last_name": lastName.text,
          "Dpi_Pasaporte": dpiPassport.text,
          "Fecha_Nacimiento": _dateAge,
          "contact_number": phone.text,
          "address": address.text,
          "Nit": nit.text,
          "Licencia": driveLicence.text,
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginView()));
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
  // buildLoginAction(),
  //buildRegisterAction(),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: buildLoginForm(),
        ),
      ),
    );
  }

  Widget buildLoginForm() {
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
            title: "Información personal",
            subtitle:
                "Por favor, llene la información en el formulario para poder empezar.",
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
                      controller: firstName,
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
                      controller: lastName,
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
                      controller: email,
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
                        controller: password,
                        validator: ((value) {
                          if (value.isEmpty) return "Campo vacío";
                          return null;
                        })),
                  ),
                  SizedBox(height: 15),
                  MyDateTimePicker(
                    text: 'Fecha de nacimiento',
                    ctrl: birthDate,
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
                      controller: address,
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
                      controller: username,
                    ),
                  ),
                ],
              ),
            ),
            validation: () {
              return;
            }),
        CoolStep(
            title: "Información personal",
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
                        controller: nit,
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
                      controller: phone,
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
                        controller: dpiPassport,
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
                      controller: driveLicence,
                      validator: ((value) {
                        if (value.isEmpty) return "Campo vacío";
                        if (value != password)
                          return "No coincide la contraseña";
                        return null;
                      }),
                    ),
                  ),
                  SizedBox(height: 15),
                  MyDateTimePicker(
                    text: 'Fecha de vencimiento',
                    ctrl: driverLicenseExpires,
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
                                    "${licenseType.runtimeType} $_isVisible ${licenseType == item}");
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
                  buildRegisterAction()
                ],
              ),
            ),
            validation: () {
              return;
            })
      ],
    ));
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

  Widget buildRegisterAction() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      margin: EdgeInsets.only(bottom: 17),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¿Ya tienes una cuenta?",
              style: TextStyle(fontSize: 17),
            ),
            TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Inicia sesión",
                  style: TextStyle(fontSize: 17),
                )),
          ],
        ),
      ),
    );
  }

  Widget _suffixIcon() =>
      Icon(showPassword ? FeatherIcons.eye : FeatherIcons.eyeOff);

  void _changeShowPasswordState() {
    setState(() => showPassword = !showPassword);
  }
}
