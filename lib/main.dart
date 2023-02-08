import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}
class Home extends StatelessWidget{
  const Home ({super.key});
  @override
  Widget build(BuildContext context){
    const appTitle = "Data Storing via Blockchain";
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: const MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children:  [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if(result == null){
                    print("no file selected");
                  } else {
                    setState(() {
                      result.files.forEach((element) {
                        print(element.size);
                        // em... if the document didn't cheat me
                        // element.bytes will contain the byte data of the file
                      });
                    });
                  }
                },
                child: const Text("upload"),
            ),
          )
        ],
      ),
    );
  }
}

