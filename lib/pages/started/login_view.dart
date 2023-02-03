import 'dart:convert';

import 'package:car_rental/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core.dart';
import 'package:http/http.dart' as http;

import '../../shared/widgets/images_widget2.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String errormsg;
  bool error, showprogress;
  String email, password;

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  void initState() {
    email = "";
    password = "";
    errormsg = "";
    error = false;
    showprogress = false;
    super.initState();
  }

  Future login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var url = "http://api-apex.ceandb.com/login.php";
    var response = await http.post(Uri.parse(url), body: {
      "email": _email.text,
      "password": _password.text,
    });

    print(response.statusCode);
    if (response.statusCode == 200) {
      print("responses ${response.body}");
      var jsondata = json.decode(response.body);

      if (jsondata["error"]) {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = jsondata["message"];
        });
      } else {
        if (jsondata["success"]) {
          setState(() {
            error = false;
            showprogress = false;
          });

          setState(() {
            String uid = jsondata["id"];
            String username = jsondata["username"];
            String first_name = jsondata["first_name"];
            String last_name = jsondata["last_name"];
            String contact_number = jsondata["contact_number"];
            String email = jsondata["email"];
            String dpiPasaporte = jsondata["Dpi_Pasaporte"];
            String licencia = jsondata["Licencia"];
            String tipoLicencia = jsondata["Tipo_Licencia"];
            String nit = jsondata["Nit"];
            sharedPreferences.setString('session', uid);
            sharedPreferences.setString('user_id', uid);
            sharedPreferences.setString('username', username ?? " ");
            sharedPreferences.setString('first_name', first_name ?? " ");
            sharedPreferences.setString('last_name', last_name ?? " ");
            sharedPreferences.setString(
                'contact_number', contact_number ?? " 0");
            sharedPreferences.setString('email', email ?? " ");
            sharedPreferences.setString('dpiPasaporte', dpiPasaporte ?? " ");
            sharedPreferences.setString('licencia', tipoLicencia ?? " ");
            sharedPreferences.setString('tipoLicencia', licencia ?? " ");
            sharedPreferences.setString('nit', nit ?? " ");
          });
          Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false,
              arguments: {"data": jsondata});
        } else {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Something went wrong.";
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.fixed,
            content: Text('¡Ha ocurrido un error, inténtelo de nuevo!'),
            backgroundColor: Colors.red[400],
            duration: Duration(seconds: 8),
          ));
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
      body: Stack(
        children: [
          Container(
            color: Color(0xffF8F8F8),
            height: 270,
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildLogo(),
                    buildLoginForm(),
                    SizedBox(height: 5.0),
                    buildLoginAction(),
                    buildRegisterAction(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLogo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImagesWidget2(
            heightImages: 250,
            images: [
              "assets/images/welcome/logotipo.jpg",
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLoginForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Iniciar sesión",
            style: TextStyle(color: Color(0xff333D55), fontSize: 23),
          ),
          SizedBox(height: 35),
          Container(
            decoration: BoxDecoration(
                color: Color(0xffe9ecef).withOpacity(0.7),
                borderRadius: BorderRadius.circular(10.0)),
            child: TextField(
              onChanged: ((value) {
                setState(() {
                  email = value;
                });
              }),
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
                  contentPadding: EdgeInsets.all(18.0)),
              controller: _email,
            ),
          ),
          SizedBox(height: 35),
          Container(
            decoration: BoxDecoration(
                color: Color(0xffe9ecef).withOpacity(0.7),
                borderRadius: BorderRadius.circular(10.0)),
            child: TextField(
              onChanged: ((value) {
                setState(() {
                  password = value;
                });
              }),
              obscureText: true,
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Contraseña',
                  prefixIcon: Icon(
                    FeatherIcons.lock,
                    color: Colors.grey,
                  ),
                  contentPadding: EdgeInsets.all(18.0)),
              controller: _password,
            ),
          ),
          SizedBox(height: 15),
          Container(
            //show error message here
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(10),
            child: error ? errmsg(errormsg) : Container(),
            //if error == true then show error message
            //else set empty container as child
          ),
        ],
      ),
    );
  }

  Widget buildLoginAction() {
    return GestureDetector(
      onTap: () => showSuccessDialog(),
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
                  "Ingresar",
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

  showSuccessDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Iniciando sesión..."),
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
      login();
    });
  }

  Widget buildRegisterAction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: EdgeInsets.only(bottom: 17),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¿No tienes una cuenta?",
              style: TextStyle(fontSize: 17),
            ),
            TextButton(
                onPressed: () => Navigator.pushNamed(context, "/register"),
                child: Text(
                  "Regístrate",
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                )),
          ],
        ),
      ),
    );
  }

  Widget errmsg(String text) {
    //error message widget.
    return Container(
      padding: EdgeInsets.all(15.00),
      margin: EdgeInsets.only(bottom: 10.00),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.red,
          border: Border.all(color: Colors.red[300], width: 2)),
      child: Row(children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 6.00),
          child: Icon(Icons.info, color: Colors.white),
        ), // icon for error message

        Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
        //show error message text
      ]),
    );
  }
}
