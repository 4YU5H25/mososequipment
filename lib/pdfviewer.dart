import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatelessWidget {
  PdfViewerPage(this.filePath);
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Report'),
      ),
      // body: PDFView(
      //   filePath: filePath,
      //   fitPolicy: FitPolicy.WIDTH,

      // ),
      body: SfPdfViewer.file(File(filePath)),
    );
  }
}
