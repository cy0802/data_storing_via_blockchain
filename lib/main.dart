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
  String filename = "none";
  bool valid = false;
  final _formKey = GlobalKey<FormState>();
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
          Container( // upload button
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 3),
            child: ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ["jpg", "png", "pdf", "jpeg"],
                  );
                  if(result != null) {
                    setState(() {
                      result.files.forEach((element) {
                        print(element.size);
                        filename = element.name;
                        // em... if the document didn't cheat me
                        // element.bytes will contain the byte data of the file
                      });
                    });
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
                    // remember to set valid to true
                  },
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 3),
            child: ElevatedButton(
              onPressed: (){
                if(_formKey.currentState!.validate() && valid == true){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  // TODO: upload to IPFS, generate private keys
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

