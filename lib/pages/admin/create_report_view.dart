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
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              FeatherIcons.chevronLeft,
              color: Colors.grey,
            )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: adminId,
        backgroundColor: Color(0xff333D55),
        onPressed: () {},
        label: Row(
          children: [
            Icon(
              FeatherIcons.save,
              color: Colors.white,
            ),
            VerticalDivider(
              width: 7.0,
            ),
            Text("Guardar")
          ],
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
                          source: ImageSource.camera, imageQuality: 10);

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
              radius: 50.0, backgroundImage: new FileImage(photo)));
    }
  }

  Future addProduct(File imageFile) async {
// ignore: deprecated_member_use
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("http://10.0.2.2/foodsystem/uploadg.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    request.fields['id_admin'] = adminId;
    request.fields['empresa'] = _entity.text;
    request.fields['observacion'] = _observation.text;
    request.fields['fecha_hora'] = _date.text;

    var respond = await request.send();
    if (respond.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
  }
}
