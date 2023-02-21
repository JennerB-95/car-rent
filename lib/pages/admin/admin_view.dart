import 'package:car_rental/pages/admin/create_report_view.dart';
import 'package:car_rental/services/report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/report.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  String adminId;

  @override
  void initState() {
    getAdminData();
    super.initState();
  }

  Future getAdminData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      adminId = prefs.getString("user_id");
    });
  }

  bool showForm = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Reportes",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: adminId,
        backgroundColor: Color(0xff333D55),
        onPressed: () => PersistentNavBarNavigator.pushNewScreen(context,
            screen: CreateReportView(), withNavBar: true),
        label: Row(
          children: [
            Icon(
              FeatherIcons.plus,
              color: Colors.white,
            ),
            VerticalDivider(
              width: 7.0,
            ),
            Text("Agregar")
          ],
        ),
      ),
      body: Body(),
    );
  }

  Widget Body() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: FutureBuilder(
          future: ReportsService.fetchAll(),
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
              List<Report> _reports = snapshot.data;
              if (_reports.length == 0) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FeatherIcons.clipboard,
                        color: Colors.grey,
                      ),
                      VerticalDivider(
                        width: 5.0,
                      ),
                      Text(
                        "Tu lista de reportes está vacía.",
                        style: TextStyle(fontSize: 17.0, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              } else {}
              return Column(
                children: _reports.map((e) => Text(e.entity)).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
