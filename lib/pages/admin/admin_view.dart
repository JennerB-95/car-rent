import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:animate_do/animate_do.dart';
import 'package:car_rental/services/report_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/report.dart';
import '../../snackbar.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  String adminId;
  Future<List<Report>> _futureReport;

  TextEditingController _entity = TextEditingController();
  TextEditingController _observation = TextEditingController();
  TextEditingController _date = TextEditingController();
  var _dateTime = DateTime.now();
  final _imagePicker = ImagePicker();
  File photo;
  String _dateHour;
  bool loading = false;

  Future uploadImage(BuildContext context, String imagePath, String idAdmin,
      String empresa, String observacion, String fechaHora) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.fixed,
      content: Text('Registrando...'),
      duration: Duration(seconds: 4),
    ));
    var url = Uri.parse(
        'http://api-apex.ceandb.com/createReport.php'); // Reemplaza "yourserver.com" con la URL de tu servidor
    var request = await http.MultipartRequest('POST', url);
    request.fields.addAll({
      'id_admin': idAdmin,
      'empresa': empresa,
      'observacion': observacion,
      'fecha_hora': DateTime.now().toString(),
    });

    if (photo != null) {
      request.files
          .add(await http.MultipartFile.fromPath('fotografia', imagePath));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.transform(utf8.decoder).join();
      var data = jsonDecode(responseData);
      if (data['status']) {
        showSnackBar(context, Icons.check_circle,
            "¡Reporte creado correctamente!", Colors.green);
        setState(() => loading = false);

        setState(() {
          ReportsService.fetchAll();
          _entity.text = '';
          _observation.text = '';
          photo = null;
        });

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        setState(() => loading = false);

        showSnackBar(context, Icons.check_circle, "¡No se ha podido guardar!",
            ThemeData.light().errorColor);
      }
    } else {
      // Ha habido un error al realizar la solicitud HTTP
    }
    ReportsService.fetchAll();
  }

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
          "Reportes del día",
          style: TextStyle(color: Colors.black),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: adminId,
        backgroundColor: Color(0xff333D55),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Container(
              color: Colors.white,
              child: showReportForm(),
            );
          },
        ),
        child: Icon(
          FeatherIcons.plus,
          color: Colors.white,
        ),
      ),
      body: Body(),
    );
  }

  Widget showReportForm() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return FadeInUp(
          child: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: 10.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SafeArea(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              _entity.text = '';
                              _observation.text = '';
                            });
                          },
                          icon:
                              Icon(Icons.close, color: Colors.grey, size: 27.0),
                        ),
                      ),
                    ),
                    Text(
                      "Crear reporte",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
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
                        maxLines: 7,
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
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  heroTag: adminId,
                  backgroundColor: Color(0xff333D55),
                  onPressed: () {
                    setState(() => loading = true);

                    uploadImage(context, photo?.path, adminId, _entity.text,
                        _observation.text, _dateHour);
                  },
                  child: loading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Icon(
                          FeatherIcons.save,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ],
        ),
      ));
    });
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
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FeatherIcons.clipboard,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Tu lista de reportes está vacía.",
                          style: TextStyle(fontSize: 17.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SingleChildScrollView(
                    child: Column(
                  children: _reports
                      .map((report) => Card(
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: report.fotografia != ""
                                        ? Image.network(
                                            "https://rentcarapex.ceandb.com/assets/img/equipments/reports/${report.fotografia.toString()}",
                                            height: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    500
                                                ? 300
                                                : 80.0,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    backgroundColor:
                                                        Colors.white,
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                            Color>(
                                                      Color(0xff333D55),
                                                    ),
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Icon(MdiIcons.cameraOff,
                                            color: Colors.grey,
                                            size: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    500
                                                ? 90
                                                : 55.0),
                                  ),
                                  VerticalDivider(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.domain,
                                              color: Colors.grey,
                                              size: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      500
                                                  ? 75
                                                  : 30,
                                            ),
                                            VerticalDivider(),
                                            Text(
                                              report.entity ?? "",
                                              softWrap: false,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              MdiIcons.noteEdit,
                                              size: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      500
                                                  ? 75
                                                  : 30,
                                              color: Colors.grey,
                                            ),
                                            VerticalDivider(),
                                            Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      500
                                                  ? 260
                                                  : 230, // ancho fijo del contenedor
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Text(
                                                    report.observation ?? "",
                                                    softWrap: true,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              MdiIcons.calendar,
                                              size: MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      500
                                                  ? 75
                                                  : 30,
                                              color: Colors.grey,
                                            ),
                                            VerticalDivider(),
                                            Text(
                                              _formattedDate(DateTime.parse(
                                                report.date ?? "2000-01-01",
                                              )),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ));
              }
            }
          },
        ),
      ),
    );
  }

  String _formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Widget _profileImage() {
    return Container(
        padding: EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color(0xffe9ecef).withOpacity(0.7),
        ),
        child: photo == null
            ? Icon(MdiIcons.camera, color: Color(0xff333D55), size: 55.0)
            : Container(
                child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: new FileImage(File(photo.path)))));
  }
}
