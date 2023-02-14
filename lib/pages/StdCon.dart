// standard contract
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class StdCon extends StatelessWidget {
  const StdCon({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = "Data Storing via Blockchain";
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
    );
  }
}