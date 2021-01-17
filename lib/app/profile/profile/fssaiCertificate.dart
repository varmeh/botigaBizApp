import 'package:flutter/material.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import '../../../widget/index.dart' show BotigaAppBar;

class FssaiCertificate extends StatelessWidget {
  final String pdfPath;
  FssaiCertificate(this.pdfPath);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BotigaAppBar('FSSAI Certificate name'),
      body: Container(
        child: PDF.network(
          this.pdfPath,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }
}
