// normal contract

import 'package:flutter/material.dart';
import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NormCon extends StatelessWidget {
  const NormCon({super.key});
  @override
  Widget build(BuildContext context) {
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
  String filename = "none";
  String cid = "";
  bool valid = false;
  FilePickerResult? file;
  final _formKey = GlobalKey<FormState>();
  String val = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: const Text("allowed filetype: jpeg, jpg, png, pdf"),
          ),
          const SizedBox(height: 3.0),
          Container(
            // upload button
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 3),
            child: ElevatedButton(
              onPressed: () async {
                // file picker
                try {
                  final FilePicker picker = FilePicker.platform;
                  file = await picker.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ["jpg", "png", "pdf", "jpeg"],
                  );
                  if (file == null) {
                    Fluttertoast.showToast(
                      msg: 'No File Selected',
                    );
                    return;
                  } else {
                    setState(() {
                      filename = file!.files[0].name;
                    });
                  }
                  debugPrint("successfully select file");
                } catch (e) {
                  debugPrint('Error at file picker: $e');
                  SnackBar(
                    content: Text(
                      'Error at file picker: $e',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                  return;
                }
              },
              child: const Text("upload contract"),
            ),
          ),
          Container(
            // filename
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10, bottom: 20),
            child: Text("selected file: $filename"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 20),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains("@")) {
                  return "invalid email";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: '輸入您的電子郵件',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 30),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      val = value!;

                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return "invalid email";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: '輸入對方的電子郵件',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 3),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (valid == true) {
                      // upload to IPFS
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => const ProgressDialog(
                          status: 'Uploading to IPFS',
                        ),
                      );
                      cid = await FlutterIpfs()
                          .uploadToIpfs(file!.files.single.path!);
                      debugPrint(cid);
                      Navigator.pop(context);
                      // TODO: call functions on the ethereum
                    } else {
                      // TODO: wait for consent
                      setState(() {
                        valid = true;
                      });
                    }
                  }
                },
                child: const Text("submit"),
              )),
        ],
      ),
    );
  }
}
