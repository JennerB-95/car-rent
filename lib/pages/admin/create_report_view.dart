import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/date_time_picker.dart';
import 'package:http/http.dart' as http;
import "package:async/async.dart";

import 'package:path/path.dart';

import 'dart:io';

import '../../services/report_service.dart';
import '../../snackbar.dart';
import 'admin_view.dart';

class CreateReportView extends StatefulWidget {
  const CreateReportView({Key key}) : super(key: key);

  @override
  State<CreateReportView> createState() => _CreateReportViewState();
}

class _CreateReportViewState extends State<CreateReportView> {
  String adminId;
  TextEditingController _entity = TextEditingController();
  TextEditingController _observation = TextEditingController();
  TextEditingController _date = TextEditingController();
  var _dateTime = DateTime.now();
  final _imagePicker = ImagePicker();
  File photo;
  String _dateHour;
  bool loading = false;
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

  Future<void> uploadImage(
      BuildContext context,
      String imagePath,
      String idAdmin,
      String empresa,
      String observacion,
      String fechaHora) async {

    var url = Uri.parse(
        'http://api-apex.ceandb.com/createReport.php'); // Reemplaza "yourserver.com" con la URL de tu servidor
    var request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'id_admin': idAdmin,
      'empresa': empresa,
      'observacion': observacion,
      'fecha_hora': fechaHora,
    });
    request.files
        .add(await http.MultipartFile.fromPath('fotografia', imagePath));
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.transform(utf8.decoder).join();
      var data = jsonDecode(responseData);
      if (data['status']) {
        showSnackBar(context, Icons.check_circle,
            "Reporte creado correctamente!", Colors.green);
        setState(() => loading = false);
        setState(() {
          ReportsService.fetchAll();
        });
        Navigator.pop(context);
      } else {
        showSnackBar(context, Icons.check_circle,
            "Reporte creado correctamente!", ThemeData.light().errorColor);
        setState(() => loading = false);
      }
    } else {
      // Ha habido un error al realizar la solicitud HTTP
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Crear reporte",
          style: TextStyle(color: Colors.black),
        ), 
        elevation: 0.0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              FeatherIcons.chevronLeft,
              color: Colors.grey,
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: adminId,
        backgroundColor: Color(0xff333D55),
        onPressed: photo?.path != null
            ? () async {
                await uploadImage(context, photo?.path, adminId, _entity.text,
                    _observation.text, _dateHour);
              }
            : null,
        child: loading
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Icon(
                FeatherIcons.save,
                color: Colors.white,
              ),
      ),
      body: Body(),
    );
  }

  Widget Body() {
    return FadeInUp(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffe9ecef).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Empresa",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(
                        MdiIcons.domain,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(15.0)),
                  controller: _entity,
                ),
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
                      hintText: "Observación",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(
                        MdiIcons.noteEdit,
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(15.0)),
                  controller: _observation,
                ),
              ),
              SizedBox(height: 15),
              MyDateTimePicker(
                text: 'Fecha ',
                ctrl: _date,
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'La fecha es requerida';
                  }
                  return null;
                },
                dateTime: _dateTime,
                onChange: (date) {
                  setState(() {
                    _dateTime = date;
                    _date.text = _dateTime.toString();
                    _dateHour = _dateTime.toString();
                  });
                },
              ),
              SizedBox(
                height: 25.0,
              ),
              GestureDetector(
                  onTap: () async {
                    try {
                      var image = await _imagePicker.pickImage(
                          source: ImageSource.camera);

                      setState(() => photo = File(image.path));
                      print("photo ${photo}");
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: _profileImage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileImage() {
    if (photo == null) {
      return Container(
          padding: EdgeInsets.all(25.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Color(0xffe9ecef).withOpacity(0.7),
          ),
          child: Icon(MdiIcons.camera, color: Color(0xff333D55), size: 55.0));
    } else {
      return Container(
          child: CircleAvatar(
              radius: 50.0, backgroundImage: new FileImage(File(photo.path))));
    }
  }
}
