import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import '../../../widget/index.dart' show BotigaAppBar;

class FssaiCertificate extends StatelessWidget {
  final PDFDocument document;
  FssaiCertificate(this.document);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BotigaAppBar('FSSAI Certificate name'),
      body: Container(
        child: PDFViewer(
          document: document,
          showIndicator: true,
          showNavigation: true,
          showPicker: true,
        ),
      ),
    );
  }
}
