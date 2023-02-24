// normal contract 
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'package:flutter_ipfs/src/service/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:web3dart/web3dart.dart';
import 'package:data_storing_via_blockchain/pages/protectedInfo.dart';
import 'package:http/http.dart';


class NormCon extends StatelessWidget{
  const NormCon ({super.key});
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
  String filename = "none";
  String cid = "";
  bool valid = false;
  FilePickerResult? file;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  String filePath = "";
  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/tmpData.json';
    debugPrint(filePath);
    return File('$path/tmpData.json');
  }
  Future<File> writeFile(String json) async {
    final file = await _localFile;
    return file.writeAsString(json);
  }
  Future<int> readFile() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      debugPrint(contents);

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children:  [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: const Text("allowed filetype: jpeg, jpg, png, pdf"),
          ),
          const SizedBox(height: 3.0),
          Container( // upload button
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
                    if(file == null){
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
                  } catch(e) {
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
          Container( // filename
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10, bottom: 20),
            child: Text("selected file: $filename"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 20),
            child: TextFormField(
              controller: controller1,
              validator: (value){
                if(value == null || value.isEmpty || !value.contains("@")){
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
                    controller: controller2,
                    validator: (value){
                      if(value == null || value.isEmpty || !value.contains("@")){
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
                ElevatedButton(
                  child: const Text("validate email"),
                  onPressed: (){
                    // TODO: send email to this person
                    // remember to add some conditions to set valid to true
                    setState(() {
                      valid = true;
                    });
                  },
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 3),
            child: ElevatedButton(
              onPressed: () async {
                if(_formKey.currentState!.validate() && valid == true){
                  // upload file to IPFS
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => const ProgressDialog(
                      status: 'Contract Uploading to IPFS',
                    ),
                  );
                  var cidOfContract = await FlutterIpfs().uploadToIpfs(file!.files.single.path!);
                  debugPrint("cidOfContract: $cidOfContract");
                  Navigator.pop(context);

                  var email1 = controller1.text;
                  var email2 = controller2.text;
                  debugPrint(email1);
                  debugPrint(email2);
                  var data = "{'email1': '$email1', 'email2': '$email2', 'cidOfContract': '$cidOfContract'}";
                  writeFile(data);
                  //readFile();
                  debugPrint(filePath);
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => const ProgressDialog(
                      status: 'Json File Uploading to IPFS',
                    ),
                  );
                  var cidOfJson = await FlutterIpfs().uploadToIpfs(filePath);
                  debugPrint("cidOfJson: $cidOfJson");
                  Navigator.pop(context);

                  // TODO: call functions on the ethereum
                }
              },
              child: const Text("submit"),
            )
          ),
        ],
      ),
    );
  }
}