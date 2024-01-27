import 'package:biomedicalfinal/pdfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewerPage extends StatelessWidget {
  PdfViewerPage(this.filePath);
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Report'),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}
