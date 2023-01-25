import 'dart:convert';

import 'package:car_rental/core.dart';
import 'package:car_rental/shared/widgets/images_widget2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  String _dateAge;
  String _driverLicenseExp;
  String errormsg;
  bool error, showprogress;
  bool showPassword = true;

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
              context, MaterialPageRoute(builder: (context) => LoginView()));
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
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: buildFooter(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildLoginForm(),
                SizedBox(
                  height: 15.0,
                ),
                buildRegisterAction(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          Text(
            "Registro",
            style: TextStyle(color: Color(0xff333D55), fontSize: 23),
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
              ),
              VerticalDivider(),
              Expanded(
                child: Container(
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
              )
            ],
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
                  hintText: "Nombre de usuario",
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
          SizedBox(height: 15),
          Row(
            children: [
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
                      controller: nit,
                      validator: ((value) {
                        if (value.isEmpty) return "Campo vacío";
                        return null;
                      })),
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
              )
            ],
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
                if (value != password) return "No coincide la contraseña";
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
        ],
      ),
    );
  }

  Widget buildLoginAction() {
    return GestureDetector(
      onTap: () => register(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 27),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xff333D55),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Registrar",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                height: 40,
                width: 40,
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xff333D55),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget buildFooter() {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 18),
      decoration: BoxDecoration(color: Colors.white),
      child: buildLoginAction(),
    );
  }

  Widget _suffixIcon() =>
      Icon(showPassword ? FeatherIcons.eye : FeatherIcons.eyeOff);

  void _changeShowPasswordState() {
    setState(() => showPassword = !showPassword);
  }
}
