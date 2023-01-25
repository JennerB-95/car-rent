import 'dart:convert';

import 'package:car_rental/core.dart';
import 'package:car_rental/shared/widgets/images_widget2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String errormsg;
  bool error, showprogress;
  String email, password, username;

  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConfirm = TextEditingController();

  Future register() async {
    var url = "http://api-apex.ceandb.com/register.php";
    final response = await http.post(Uri.parse(url),
        body: jsonEncode(<String, String>{
          "username": _username.text,
          "email": _email.text,
          "password": _password.text,
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
  void initState() {
    username = "";
    email = "";
    password = "";
    errormsg = "";
    error = false;
    showprogress = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            height: 300,
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeader(),
                    buildLoginForm(),
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

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
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
          SizedBox(height: 0),
          ImagesWidget2(
            heightImages: 250,
            images: [
              "assets/images/welcome/logotipo.jpg",
            ],
          ),
          SizedBox(height: 0),
          SizedBox(height: 13),
        ],
      ),
    );
  }

  Widget buildLoginForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 20),
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Usuario",
            style: TextStyle(color: Color(0xFFF9B234), fontSize: 18),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Ingresa tu usuario",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF9B234)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF9B234)),
              ),
            ),
            controller: _username,
          ),
          SizedBox(height: 15),
          Text(
            "Correo",
            style: TextStyle(color: Color(0xFFF9B234), fontSize: 18),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Ingresa tu correo",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF9B234)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF9B234)),
              ),
            ),
            controller: _email,
          ),
          SizedBox(height: 15),
          Text(
            "Contraseña",
            style: TextStyle(color: Color(0xFFF9B234), fontSize: 18),
          ),
          TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "********",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF9B234)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF9B234)),
                ),
              ),
              controller: _password,
              validator: ((value) {
                if (value.isEmpty) return "Campo vacío";
                return null;
              })),
          SizedBox(height: 15),
          Text(
            "Confirma tu Contraseña",
            style: TextStyle(color: Color(0xFFF9B234), fontSize: 18),
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "********",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF9B234)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF9B234)),
              ),
            ),
            controller: _passwordConfirm,
            validator: ((value) {
              if (value.isEmpty) return "Campo vacío";
              if (value != _password) return "No coincide la contraseña";
              return null;
            }),
          ),
          // SizedBox(height: 23),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Text(
          //     "Al registrarme, acepto los términos y condiciones de la aplicación APEX Renta de Vehículos.",
          //     style: TextStyle(fontSize: 16),
          //   ),
          // ),
          SizedBox(height: 15),
          Container(
            //show error message here
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.all(10),
            child: error ? errmsg(errormsg) : Container(),
            //if error == true then show error message
            //else set empty container as child
          ),
          SizedBox(height: 10),
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
            color: kPrimaryColor,
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
                    color: kPrimaryColor,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
