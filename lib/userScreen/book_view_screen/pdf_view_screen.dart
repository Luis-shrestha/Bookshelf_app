import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import '../../../utility/constant/constant.dart' as constant;

class PdfViewScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;
  const PdfViewScreen({super.key, required this.pdfUrl, required this.title});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {

  PDFDocument? document;

  void initialisePdf() async{
    document = await PDFDocument.fromURL(widget.pdfUrl);
    setState(() {

    });
  }
  @override
  void initState(){
    super.initState();
    initialisePdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constant.kBackGroundColor,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: document != null? PDFViewer(
        document: document!,
      ): const Center(child: CircularProgressIndicator(),),
    );
  }
}
