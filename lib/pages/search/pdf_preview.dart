import 'package:car_rental/pages/search/pdf_export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../models/my_booking.dart';
import '../booking_cars/util/util.dart';

class PdfPreviewPage extends StatefulWidget {
  final MisReservas reserva;
  const PdfPreviewPage({@required this.reserva});

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  PrintingInfo printingInfo;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: generatePdf,
      ),
    );
  }
}
