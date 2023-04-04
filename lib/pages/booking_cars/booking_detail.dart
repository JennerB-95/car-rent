import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:math' as math;
import '../../models/my_booking.dart';
import '../search/pdf.dart';
import 'package:http/http.dart' as http;

class BookingDetail extends StatefulWidget {
  final String id;
  final MisReservas data;
  const BookingDetail({@required this.id, @required this.data});

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  String _dropdownValue = "Reserva";
  bool isCreditCard = false;
  TextEditingController creditCardNo = TextEditingController();
  String creditCard;
  TextEditingController _descuento = TextEditingController();
  int descuento;
  String totalDescuento;
  String errormsg;
  bool error, showprogress;
  TextEditingController _recargo = TextEditingController();
  int recargo;
  String totalRecargo;
  String grand_total;
  File voucher;
  final _imagePicker = ImagePicker();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff333D55),
        onPressed: () {
          if (voucher?.path != null) {
            setState(() => loading = true);

            updateBooking();
          }

          Printing.layoutPdf(
            // [onLayout] will be called multiple times
            // when the user changes the printer or printer settings
            onLayout: (PdfPageFormat format) {
              // Any valid Pdf document can be returned here as a list of int
              return buildPdf(
                  format,
                  widget.id,
                  widget.data,
                  _numberOfDaysString(
                      DateTime.parse(widget.data.end_date),
                      DateTime.parse(
                        widget.data.start_date,
                      )),
                  widget.data.grand_total,
                  totalDescuento,
                  totalRecargo,
                  grand_total,
                  _dropdownValue,
                  creditCard);
            },
          );
          /* PersistentNavBarNavigator.pushNewScreen(context,
              screen: PdfPreviewPage(
                reserva: widget.data,
              ),
              withNavBar: true);*/
        },
        child: loading
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Icon(
                MdiIcons.textBoxMultiple,
                color: Colors.white,
              ),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              FeatherIcons.chevronLeft,
              color: Colors.grey,
            )),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Reserva No. ${widget.data.id}",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Body(),
    );
  }

  Widget Body() {
    return SingleChildScrollView(
      child: FadeInUp(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.network(
                    "https://rentcarapex.ceandb.com/assets/img/equipments/thumbnail-images/" +
                        widget.data.thumbnail_image.toString(),
                    height:
                        MediaQuery.of(context).size.width > 500 ? 80.0 : 140,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          backgroundColor: Colors.white,
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            Color(0xff333D55),
                          ),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                  VerticalDivider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data.title,
                        style: TextStyle(
                            fontSize: 19.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Text(
                            "SALIDA",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          VerticalDivider(),
                          Text(_formattedDate(
                              DateTime.parse(widget.data.start_date)))
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Text(
                            "DEVOLUCIÓN",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          VerticalDivider(),
                          Text(_formattedDate(
                              DateTime.parse(widget.data.end_date)))
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Text(
                            "DIAS:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          VerticalDivider(),
                          Text(_numberOfDaysString(
                              DateTime.parse(widget.data.end_date),
                              DateTime.parse(widget.data.start_date)))
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "DATOS DEL ARRENDATARIO",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Text(
                  "Nombre:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                VerticalDivider(),
                Text(widget.data.name ?? "")
              ],
            ),
            Row(
              children: [
                Text(
                  "Fecha de nacimiento:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                VerticalDivider(),
                Text(_formattedDate(
                    DateTime.parse(widget.data.nacimiento ?? "2020-02-03")))
              ],
            ),
            Row(
              children: [
                Text(
                  "Edad:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                VerticalDivider(),
                Text("${widget.data.yearsOld.toString()} años")
              ],
            ),
            Row(
              children: [
                Text(
                  "Dirección:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                VerticalDivider(),
                Text(widget.data.address ?? "")
              ],
            ),
            Row(
              children: [
                Text(
                  "Dpi/Pasaporte:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                VerticalDivider(),
                Text(widget.data.dpi_pass ?? "")
              ],
            ),
            Row(
              children: [
                Text(
                  "Nit:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                VerticalDivider(),
                Text(widget.data.nit ?? " ")
              ],
            ),
            Row(
              children: [
                Text(
                  "Teléfono:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                VerticalDivider(),
                Text(widget.data.phone ?? "")
              ],
            ),
            Row(
              children: [
                Text(
                  "Licencia No:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                VerticalDivider(),
                Text(widget.data.licencia ?? "")
              ],
            ),
            Row(
              children: [
                Text(
                  "Licencia vence:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                VerticalDivider(),
                Text(widget.data.licencia_vence ?? "")
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Divider(),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "IDENTIFICACIÓN DEL ARRENDATARIO",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                widget.data.dpiFront != ""
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          "https://rentcarapex.ceandb.com/assets/img/equipments/dpi-licenses/${widget.data.dpiFront.toString()}",
                          height: MediaQuery.of(context).size.width > 500
                              ? 300
                              : 200.0,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                backgroundColor: Colors.white,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                  Color(0xff333D55),
                                ),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      )
                    : Icon(MdiIcons.cameraOff,
                        color: Colors.grey,
                        size: MediaQuery.of(context).size.width > 500
                            ? 90
                            : 55.0),
                widget.data.dpiBack != ""
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          "https://rentcarapex.ceandb.com/assets/img/equipments/dpi-licenses/${widget.data.dpiBack.toString()}",
                          height: MediaQuery.of(context).size.width > 500
                              ? 300
                              : 200.0,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                backgroundColor: Colors.white,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                  Color(0xff333D55),
                                ),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      )
                    : Icon(MdiIcons.cameraOff,
                        color: Colors.grey,
                        size: MediaQuery.of(context).size.width > 500
                            ? 90
                            : 55.0),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Divider(),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "LICENCIA DE CONDUCIR DEL ARRENDATARIO",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                widget.data.dpiFront != ""
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          "https://rentcarapex.ceandb.com/assets/img/equipments/dpi-licenses/${widget.data.licenseFront.toString()}",
                          height: MediaQuery.of(context).size.width > 500
                              ? 300
                              : 200.0,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                backgroundColor: Colors.white,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                  Color(0xff333D55),
                                ),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      )
                    : Icon(MdiIcons.cameraOff,
                        color: Colors.grey,
                        size: MediaQuery.of(context).size.width > 500
                            ? 90
                            : 55.0),
                widget.data.dpiBack != ""
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          "https://rentcarapex.ceandb.com/assets/img/equipments/dpi-licenses/${widget.data.licenseBack.toString()}",
                          height: MediaQuery.of(context).size.width > 500
                              ? 300
                              : 200.0,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                backgroundColor: Colors.white,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                  Color(0xff333D55),
                                ),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      )
                    : Icon(MdiIcons.cameraOff,
                        color: Colors.grey,
                        size: MediaQuery.of(context).size.width > 500
                            ? 90
                            : 55.0),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Divider(),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "CONDUCTORES AUTORIZADOS  ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if ((widget.data.id_user_auth_one == "43" ||
                    widget.data.id_user_auth_one == null) &&
                (widget.data.id_user_auth_dos == "43" ||
                    widget.data.id_user_auth_dos == null))
              Text(
                "Esta reserva no tiene conductores autorizados",
                style: TextStyle(color: Colors.grey),
              ),
            if (widget.data.id_user_auth_one != "43")
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CONDUCTOR 1 ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          "Nombre:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(widget.data.name_auth_1 ?? "")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Fecha de nacimiento:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(_formattedDate(DateTime.parse(
                            widget.data.nacimiento_auth_1 ?? "2020-02-03")))
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Edad:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text("${widget.data.yearsOldAuth1.toString()} años")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Dirección:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(widget.data.direccion_auth_1 ?? "")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Dpi/Pasaporte:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(widget.data.dpi_auth_1 ?? "")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Nit:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(widget.data.nit_auth_1 ?? " ")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Teléfono:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(widget.data.telefono_auth_1 ?? "")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Licencia No:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(widget.data.licencia_auth_1 ?? "")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Licencia vence:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(_formattedDate(DateTime.parse(
                            widget.data.licencia_vence_auth_1 ?? "2020-02-03")))
                      ],
                    ),
                  ],
                ),
              ),
            if (widget.data.id_user_auth_dos != "43")
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CONDUCTOR 2 ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          "Nombre:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(widget.data.name_auth_2 ?? "")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Fecha de nacimiento:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(_formattedDate(DateTime.parse(
                            widget.data.nacimiento_auth_2 ?? "2020-02-03")))
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Edad:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text("${widget.data.yearsOldAuth2.toString()} años")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Dirección:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(widget.data.direccion_auth_2 ?? "")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Dpi/Pasaporte:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(widget.data.dpi_auth_2 ?? "")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Nit:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(widget.data.nit_auth_2 ?? " ")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Teléfono:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(widget.data.telefono_auth_2 ?? "")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Licencia No:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(widget.data.licencia_auth_2 ?? "")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Licencia vence:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(),
                        Text(_formattedDate(DateTime.parse(
                            widget.data.licencia_vence_auth_2 ?? "2020-02-03")))
                      ],
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "AGREGAR METODO DE PAGO",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                DropdownButton<String>(
                  value: _dropdownValue,
                  items: <String>[
                    "Reserva",
                    "Efectivo",
                    "Transferencia",
                    "Depósito",
                    "Tarjeta crédito/débito"
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      child: Text('$value'),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      _dropdownValue = newValue;
                    });
                    if (_dropdownValue == "Tarjeta crédito/débito") {
                      setState(() {
                        isCreditCard = true;
                      });
                    } else {
                      isCreditCard = false;
                    }
                  },
                  underline: Container(
                    height: 0,
                  ),
                ),
                VerticalDivider(),
                if (isCreditCard)
                  Expanded(
                    child: FadeInUp(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                            color: Color(0xffe9ecef).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: ((value) {
                            setState(() {
                              creditCard = value;
                            });
                          }),
                          decoration: InputDecoration(
                              hintText: 'No. tarjeta',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(18.0)),
                          controller: creditCardNo,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "SUBIR VOUCHER O BOLETA DE PAGO",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GestureDetector(
                onTap: () async {
                  try {
                    var image = await _imagePicker.pickImage(
                        source: ImageSource.camera);

                    setState(() => voucher = File(image.path));
                  } catch (e) {
                    print(e);
                  }
                },
                child: _voucher()),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            SizedBox(
              height: 10.0,
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Descuento",
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xffe9ecef).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: TextField(
                              maxLength: 3,
                              keyboardType: TextInputType.number,
                              onChanged: ((value) {
                                if (value == "") {
                                  setState(() {
                                    totalDescuento = null;
                                  });
                                }
                                setState(() {
                                  if (value != "") {
                                    descuento = int.parse(value);
                                  }
                                  _descuentoCalculate(descuento.toString());
                                  sumGrandTotal();
                                });
                              }),
                              decoration: InputDecoration(
                                  hintText: ' ',
                                  counterText: "",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: Icon(
                                    FeatherIcons.percent,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          totalDescuento = 0.toString();
                                          grand_total = widget.data.grand_total;
                                          _descuento.text = '';
                                        });
                                      },
                                      icon: Icon(
                                        MdiIcons.eraser,
                                        color: Colors.grey,
                                      )),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.all(18.0)),
                              controller: _descuento,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recargo",
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xffe9ecef).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              onChanged: ((value) {
                                if (value == "") {
                                  setState(() {
                                    totalRecargo = null;
                                  });
                                }
                                setState(() {
                                  if (value != "") {
                                    recargo = int.parse(value);
                                  }
                                  _recargoCalculate(recargo.toString());
                                  sumGrandTotal();
                                });
                              }),
                              decoration: InputDecoration(
                                  counterText: "",
                                  hintText: ' ',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: Icon(
                                    FeatherIcons.percent,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          totalRecargo = 0.toString();
                                          _recargo.text = '';
                                        });
                                        grand_total = widget.data.grand_total;
                                      },
                                      icon: Icon(
                                        MdiIcons.eraser,
                                        color: Colors.grey,
                                      )),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.all(18.0)),
                              controller: _recargo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 35.0,
            ),
            Divider(),
            SizedBox(
              height: 35.0,
            ),
            Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "PRECIO:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  VerticalDivider(),
                  Text("Q ${widget.data.grand_total}")
                ],
              ),
            ),
            Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RECARGO:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  VerticalDivider(),
                  Text(
                      "+ Q${double.parse(totalRecargo ?? 0.toString()).toStringAsFixed(2) ?? ""}")
                ],
              ),
            ),
            Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DESCUENTO:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  VerticalDivider(),
                  Text(
                      "- Q${double.parse(totalDescuento ?? 0.toString()).toStringAsFixed(2) ?? ""}")
                ],
              ),
            ),
            Container(
              width: 200,
              child: Divider(),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 35.0),
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TOTAL:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  VerticalDivider(),
                  Text("Q ${grand_total ?? widget.data.grand_total}")
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future updateBooking() async {
    var url = Uri.parse("http://api-apex.ceandb.com/updateReservation.php");

    var request = await http.MultipartRequest('POST', url);

    request.fields.addAll({
      "id": widget.data.id,
    });

    // add voucher to fields
    if (voucher != null) {
      request.files
          .add(await http.MultipartFile.fromPath('voucher', voucher?.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.transform(utf8.decoder).join();
      print("reponse data $responseData");
      var data = jsonDecode(responseData);

      if (data["status"] == false) {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = data["message"];
        });
      } else {
        if (data["status"] == true) {
          setState(() {
            error = false;
            showprogress = false;

            loading = false;
          });
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

  String _formattedDate(DateTime date) {
    String dateBooking = "";
    dateBooking = DateFormat('dd/MM/yyyy').format(date);
    return dateBooking;
  }

  String _descuentoCalculate(String descuento) {
    double totalDiscount;
    double precioBooking = double.parse(widget.data.grand_total);

    totalDiscount = (double.parse(descuento) / 100) * precioBooking;

    totalDescuento = totalDiscount.toString();
    return totalDescuento;
  }

  String _recargoCalculate(String recargo) {
    double totalrecargo;
    double precioBooking = double.parse(widget.data.grand_total);

    totalrecargo = (double.parse(recargo) / 100) * precioBooking;

    totalRecargo = totalrecargo.toString();
    return totalRecargo;
  }

  String _numberOfDaysString(DateTime day1, DateTime day2) {
    String days;
    days = (day1.difference(day2).inDays + 1).toString();
    return days;
  }

  String sumGrandTotal() {
    grand_total = (double.parse(widget.data.grand_total) +
            double.parse(totalRecargo ?? "0") -
            double.parse(totalDescuento ?? "0"))
        .toString();

    return grand_total;
  }

  Widget _voucher() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        padding: EdgeInsets.all(voucher == null ? 20 : 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color(0xffe9ecef).withOpacity(0.7),
        ),
        child: voucher == null
            ? Icon(MdiIcons.camera, color: Color(0xff333D55), size: 55.0)
            : Row(
                children: [
                  Image.file(
                    File(voucher.path),
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MdiIcons.cameraRetake,
                        size: 55.0,
                        color: Color(0xff333D55),
                      ),
                      InkWell(
                          onTap: () => setState(() => voucher = null),
                          child: Icon(
                            MdiIcons.trashCan,
                            size: 55.0,
                            color: Colors.redAccent,
                          ))
                    ],
                  )
                ],
              ));
  }
}
