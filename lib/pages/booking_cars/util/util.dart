import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generatePdf(final PdfPageFormat format) async {
  final doc = pw.Document(title: 'Contrato');
  final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/welcome/logotipo.jpg'))
          .buffer
          .asUint8List());

  final pageTheme = await _myPageTheme(format);
  doc.addPage(pw.MultiPage(
      pageTheme: pageTheme,
      header: (context) => pw.Image(logoImage,
          alignment: pw.Alignment.topLeft, fit: pw.BoxFit.contain, width: 100),
      build: (context) => [
            pw.Container(
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                  pw.Paragraph(
                    text:
                        "Conste por el presente documento el contrato de ALQUILER del vehículo de Placa Nº que celebran de una parte el Sr(a)._______________________________________ identificado con el número de DPI _______________, quien señala lugar para recibir notificaciones y citaciones la dirección descrita que para los efectos del presente contrato se le denominará EL ARRENDATARIO, sujeto a los términos y condiciones siguientes:",
                  ),
                ]))
          ]));
  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  return const pw.PageTheme(
    textDirection: pw.TextDirection.ltr,
    orientation: pw.PageOrientation.portrait,
  );
}

Future<void> saveAsFile(final BuildContext context, final LayoutCallback build,
    final PdfPageFormat pageFormat) async {
  final bytes = await build(pageFormat);
  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print('save as file ${file.path}...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document printed successfully')));
}

void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document shared successfully')));
}
