import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../core.dart';
import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future login() async {
    var url = "http://basededatos.ceandb.com/login.php";
    var response = await http.post(Uri.parse(url), body: {
      "email": email.text,
      "password": password.text,
    });
    var data = json.decode(response.body);
    if (data == "Success") {
      Fluttertoast.showToast(
        msg: 'Inicio de sesión correctamente!',
        textColor: Colors.green,
        fontSize: 25,
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainView()));
    } else {
      Fluttertoast.showToast(
        msg: 'Correo y contraseña inválidos!',
        backgroundColor: Colors.red,
        textColor: Colors.red,
        fontSize: 25,
      );
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
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
                    buildLogo(),
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

  Widget buildLogo() {
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
          ImagesWidget(
            heightImages: 250,
            images: [
              "assets/images/welcome/logotipo.jpg",
            ],
          ),
          SizedBox(height: 13),
        ],
      ),
    );
  }

  Widget buildLoginForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 20),
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            controller: email,
          ),
          SizedBox(height: 15),
          Text(
            "Contraseña",
            style: TextStyle(color: Color(0xFFF9B234), fontSize: 18),
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "***********",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF9B234)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF9B234)),
              ),
            ),
            controller: password,
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () => Get.toNamed(Routes.FORGET_PASSWORD),
                child: Text(
                  "¿Perdiste tu contraseña?",
                  style: TextStyle(fontSize: 17, color: Color(0xFFF9B234)),
                )),
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
              "¿No tienes una cuenta?",
              style: TextStyle(fontSize: 17),
            ),
            TextButton(
                onPressed: () => Get.toNamed(Routes.REGISTER),
                child: Text(
                  "Regístrate",
                  style: TextStyle(fontSize: 17, color: Color(0xFFF9B234)),
                )),
          ],
        ),
      ),
    );
  }
}
