import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
// ignore: depend_on_referenced_packages
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
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    final text = '${indexPage + 1} of $pages';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: TextStyle(
            color: Colors.brown
          )
        ),
        iconTheme: IconThemeData(color: Colors.brown),
        backgroundColor: Color.fromARGB(255, 216, 171, 113),
        actions: pages >= 2
            ? [
                Center(child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.brown
                  )
                  )
                ),
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 32),
                  onPressed: () {
                    final page = indexPage == 0 ? pages : indexPage - 1;
                    controller.setPage(page);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, size: 32),
                  onPressed: () {
                    final page = indexPage == pages - 1 ? 0 : indexPage + 1;
                    controller.setPage(page);
                  },
                ),
              ]
            : null,
      ),
      body: PDFView(
        filePath: widget.file.path,
        onRender: (pages) => setState(()=>this.pages = pages!),
        onViewCreated: (controller)=>
            setState(() =>this.controller = controller),
          onPageChanged: (indexPage, _)=>
            setState(()=> this.indexPage = indexPage!),
      )
    );
  }
}
/*Scaffold(
      body: SfPdfViewer.file(
              File('storage/emulated/0/Download/flutter-succinctly.pdf')));*/