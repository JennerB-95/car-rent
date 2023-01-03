import 'dart:convert';

import 'package:car_rental/core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();

  Future register() async {
    var url = "http://basededatos.ceandb.com/register.php";
    final response = await http.post(Uri.parse(url), body: {
      "username": username.text,
      "email": email.text,
      "password": password.text,
    });
    print(response.statusCode);
    print(response.body);
    var data = jsonDecode(response.body ?? '[]');
    if (data == "Error") {
      Fluttertoast.showToast(
        msg: 'Usuario ya registrado!',
        textColor: Colors.red,
        fontSize: 25,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Registro realizado correctamente!',
        textColor: Colors.green,
        fontSize: 25,
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginView()));
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
          ImagesWidget(
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
            controller: username,
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
            controller: email,
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
              controller: password,
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
            controller: passwordConfirm,
            validator: ((value) {
              if (value.isEmpty) return "Campo vacío";
              if (value != password) return "No coincide la contraseña";
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
}
