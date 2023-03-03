// normal contract 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:typed_data';
import 'dart:math';
import 'dart:io';

import 'package:data_storing_via_blockchain/Classes/user.dart';
import 'package:data_storing_via_blockchain/pages/kids/NormalContract/ShowFile.dart';

import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'package:flutter_ipfs/src/service/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:path_provider/path_provider.dart';
import 'package:web3dart/web3dart.dart';
//import 'package:data_storing_via_blockchain/pages/protectedInfo.dart';
import 'package:http/http.dart';


//------------------------------------------------------------我是用來美觀的-------------------------------------------------------------------


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
  bool valid = true;
  FilePickerResult? file;
  File? result;
  final _formKey = GlobalKey<FormState>();
  //email controller
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  //name controller
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();

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
    controller3.dispose();
    controller4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children:  [
          const Spacer(flex: 1),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: const Text("allowed filetype: jpeg, jpg, png, pdf"),
          ),
          const SizedBox(height: 3.0),
          Container( // upload button
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(3, 3, 3, 3),
            child: Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 102, 184, 251),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 130, vertical: 10),
                  ),
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
                          result = File(file!.files.single.path as String);
                          openPDF(context, result!);
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
                  child: const Text("Select Contract"),
              ),
            ),
          ),
          //Con
          Container( // filename
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10, bottom: 20),
            child: Text("selected file: $filename"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 20),
            child: TextFormField(
              controller: controller3,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: '輸入您的名字',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 20),
            child: TextFormField(
              controller: controller4,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: '輸入對方的名字',
              ),
            ),
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
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 3),
            child: ElevatedButton(
              onPressed: () async {
                if(_formKey.currentState!.validate() && valid == true){

                  //存一些資料在firestore，用來顯示在帶簽署那裏，讓使用者清楚知道一些合約基本資訊
                  var name1 = controller3.text;
                  var name2 = controller4.text;
                  String name = '$name1, $name2';

                  var email1 = controller1.text;
                  var email2 = controller2.text;

                  await FirebaseFirestore.instance.collection("user").doc(email1).collection("contract").doc().set(
                    User(
                      name: name,
                      contractname: filename,
                      another_email: email2,
                      have_checked: true,
                    ).toJson()
                  );
                  await FirebaseFirestore.instance.collection("user").doc(email2).collection("contract").doc().set(
                    User(
                      name: name,
                      contractname: filename,
                      another_email: email1,
                      have_checked: false,
                    ).toJson()
                  );

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
                  /*var fromAddress = EthereumAddress.fromHex(walletAddress);
                  var toAddress = EthereumAddress.fromHex(contractAddress);
                  var value = EtherAmount.inWei(BigInt.from(1000000000000000000));
                  var gasPrice = EtherAmount.inWei(BigInt.from(20000000000));
                  var gasLimit = 21000;
                  var smartContract = DeployedContract(/* abi */, toAddress);
                  var calledFunction = ContractFunction(/* name */, /* parameters */);
                  var transaction = Transaction.callContract(
                    contract: ,
                    function: ,
                    parameters: ,
                    nonce: 0,
                    from: fromAddress,
                    value: value,
                    gasPrice: gasPrice,
                    maxGas: gasLimit,
                    //TODO: maybe data here?
                  );
                  var rng = Random.secure();
                  Credentials credentials = EthPrivateKey.createRandom(rng);
                  //var address = await credentials.extractAddress();
                  //debugPrint(address.hex);
                  var httpClient = Client();
                  var client = Web3Client(rpcEndPoint, httpClient);
                  var signature = await client.signTransaction(credentials, transaction);*/
                }
              },
              child: const Text("submit"),
            )
          ),
          const Spacer(flex: 9),
        ],
      ),
    );
  }
}

void openPDF(BuildContext context, File file)=>
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context)=>PDFViewPage(file: file))
  );