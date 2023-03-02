import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class PDFViewPage extends StatefulWidget {

  final File file;

  const PDFViewPage({
    super.key, 
    required this.file,
  });

  @override
  State<PDFViewPage> createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: PDFView(
        filePath: widget.file.path,
      )
    );
  }
}
/*Scaffold(
      body: SfPdfViewer.file(
              File('storage/emulated/0/Download/flutter-succinctly.pdf')));*/