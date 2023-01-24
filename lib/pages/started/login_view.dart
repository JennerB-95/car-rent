import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../core.dart';
import 'package:http/http.dart' as http;

import '../../shared/widgets/images_widget2.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String _email = '';
  String _password = '';

  login() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainView()));
    /*print("response $_email $_password");

    var url = "http://basededatos.ceandb.com/login.php";
    var response = await http.post(Uri.parse(url), body: {
      "email": _email,
      "password": _password,
    });
    print(response.statusCode);
    var data = json.decode(response.body);
    if (data == "Success") {
      Fluttertoast.showToast(
        msg: 'Inicio de sesión correctamente!',
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainView()));
    } else {
      Fluttertoast.showToast(
        msg: 'Correo y contraseña inválidos!',
      );
    }
    return data;**/
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
                    SizedBox(height: 45.0),
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
                  _email = value;
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
              controller: email,
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
                  _password = value;
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
              controller: password,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginAction() {
    return GestureDetector(
      onTap: () => login(),
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
                onPressed: () => Get.toNamed(Routes.REGISTER),
                child: Text(
                  "Regístrate",
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                )),
          ],
        ),
      ),
    );
  }
}
