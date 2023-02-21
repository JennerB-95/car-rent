import 'package:car_rental/models/my_booking.dart';
import 'package:car_rental/services/my_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isAdmin = false;
  String uid,
      username,
      first_name,
      last_name,
      contact_number,
      emailU,
      dpiPasaporte,
      licencia,
      tipoLicencia,
      fechaNacimiento,
      nit;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
      first_name = prefs.getString("first_name");
      last_name = prefs.getString("last_name");
      contact_number = prefs.getString("contact_number");
      emailU = prefs.getString("email");
      dpiPasaporte = prefs.getString("dpiPasaporte");
      licencia = prefs.getString("licencia");
      tipoLicencia = prefs.getString("tipoLicencia");
      nit = prefs.getString("nit");
      fechaNacimiento = prefs.getString("fecha_nacimiento");

      isAdmin = prefs.getBool("is_admin");
    });

    print("fecha de naciniento $fechaNacimiento");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(),
              buildBody(),
              buildActionButton(),
              SizedBox(height: 25),
              Divider(
                thickness: 1,
                indent: 15,
                endIndent: 15,
              ),
            ],
          ),
        ),
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.7),
                      child: Text(
                        "$first_name $last_name",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                  "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(7)),
          child: Column(
            children: [
              ItemListMenu(
                icon: LineIcons.envelope,
                name: "Correo electrónico",
                data: "${emailU ?? "Sin información. "}",
              ),
              Divider(),
              ItemListMenu(
                icon: LineIcons.phone,
                name: "Teléfono",
                data: "${contact_number ?? "Sin información."}",
              ),
              Divider(),
              FutureBuilder(
                  future: MisReservasService.fetchAll(),
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
                      return ItemListMenu(
                        icon: LineIcons.calendar,
                        name: "Historial de reservas ",
                        data: "${_misReservas.length}",
                      );
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton.icon(
        onPressed: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('¿Deseas cerrar sesión?',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff333D55))),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancelar',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff333D55))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xff333D55))),
                    child: Text('Aceptar',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                    onPressed: () {
                      prefs.clear();
                      Navigator.pop(context);
                      _confirmLogOut();
                    },
                  ),
                ],
              );
            },
          );
          ;
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff333D55),
          padding: const EdgeInsets.symmetric(vertical: 12),
          elevation: 0.2,
          textStyle: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: Icon(
          LineIcons.alternateSignOut,
          size: 27,
        ),
        label: Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: Text("Cerrar sesión"),
        ),
      ),
    );
  }

  void _confirmLogOut() {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 6, bottom: 6),
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Color(0xff333D55),
                  ),
                ),
              ),
              new Text(
                "Cerrando sesión...",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF3C4E5D),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
            ],
          ),
        ));
      },
    );
    new Future.delayed(new Duration(milliseconds: 2000), () {
      Phoenix.rebirth(context);
    });
  }
}
