import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_storing_via_blockchain/Classes/userpreserve.dart';
import 'package:data_storing_via_blockchain/function/local_folder.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/signed.dart';
import 'package:data_storing_via_blockchain/pages/kids/NormalContract/ShowFile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'package:data_storing_via_blockchain/pages/generateNFT.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WaitUpload extends StatefulWidget {
  final Map<String, dynamic> data;
  final String email;
  final String time;

  const WaitUpload(
      {super.key, required this.data, required this.email, required this.time});

  @override
  State<WaitUpload> createState() =>
      _WaitUploadState(data: data, email: email, time: time);
}

class _WaitUploadState extends State<WaitUpload> {
  late String contractname;
  late String name;
  late String user1time;
  late String emailuser2;
  late String path;
  late String totalPath;
  late File file;
  late String path1;
  late DocumentReference<Map<String, dynamic>> doc1;
  late DocumentReference<Map<String, dynamic>> doc2;

  bool isChecked = false;

  final Map<String, dynamic> data;
  final String email;
  final String time;
  _WaitUploadState(
      {required this.data, required this.email, required this.time});

  void openPDF(BuildContext context, File file) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => PDFViewPage(file: file)));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  void initialization() async {
    contractname = data['contractname'];
    name = data['name'];
    user1time = data['time'];
    emailuser2 = data['another_email'];
    path = data['path'];
    path1 = await appDocPath;
    totalPath = '$path1/$path';
    file = File(totalPath);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 185, 185, 185),
          title: const Text('Contract information',
              style: TextStyle(
                color: Colors.black,
              )),
          centerTitle: true,
          actions: [],
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(10, 30, 0, 10),
              child: Text("Contract's name : ",
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(40, 0, 10, 30),
              child: Text(
                contractname,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Text("Both Signer : ",
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(40, 0, 10, 30),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Text("My Signed Time : ",
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(40, 0, 10, 30),
              child: Text(
                user1time,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Text("His/Her Signed Time : ",
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.fromLTRB(40, 0, 10, 30),
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
              alignment: Alignment.topLeft,
              child: Text(
                "View Contract : ",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 96, 121, 219),
                    ),
              child: TextButton.icon(
                label: const Text(''),
                icon: const Icon(
                  size: 30.0,
                  Icons.content_paste_search,
                  color: Colors.white,
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 107, 92, 203),
                  padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 10),
                ),
                onPressed: () async {
                  openPDF(context, file);
                }, 
              ),
            ),
            CheckboxListTile(
              title: Text('I agree to upload the contract to blockchain'),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Color.fromARGB(255, 74, 125, 245),
              checkColor: Colors.white,
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
            const Spacer(flex: 19),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 96, 121, 219),
                    ),
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                      child: Text(
                        "Upload to Blockchain",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () async {
                        if (isChecked) {
                          var cidOfContract =
                              await FlutterIpfs().uploadToIpfs(totalPath);

                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => const ProgressDialog(
                              status: 'Contract Uploading to IPFS',
                            ),
                          );

                          debugPrint("cidOfContract: $cidOfContract");
                          String jsonPath = "";
                          String cidOfNFTImg = "";
                          await generateNFT(cidOfContract, email, emailuser2)
                              .then((s) {
                            setState(() {
                              jsonPath = s[0];
                              cidOfNFTImg = s[1];
                              //debugPrint("##jsonPath: $jsonPath");
                              //debugPrint("##cidOfNFTImg: $cidOfNFTImg");
                            });
                          }).catchError((error) {
                            debugPrint(error);
                          });
                          //debugPrint("###jsonPath: $jsonPath");
                          //debugPrint("###cidOfNFTImg: $cidOfNFTImg");
                          String transactionHash = "";
                          await mint(jsonPath).then((s) {
                            transactionHash = s;
                            //debugPrint("##transactionHash: $transactionHash");
                          }).catchError((error) {
                            debugPrint(error);
                          });
                          //debugPrint("###transactionHash: $transactionHash");
                          String ult_time = await getTime();
                          await FirebaseFirestore.instance
                              .collection("user")
                              .doc(email)
                              .collection("contractPreserve")
                              .doc(contractname)
                              .set(UserPreserve(
                                name: name,
                                contractname: contractname,
                                another_email: emailuser2,
                                key: transactionHash,
                                time: ult_time,
                                pic_cid: cidOfNFTImg,
                              ).toJson());

                          await FirebaseFirestore.instance
                              .collection("user")
                              .doc(emailuser2)
                              .collection("contractPreserve")
                              .doc(contractname)
                              .set(UserPreserve(
                                name: name,
                                contractname: contractname,
                                another_email: email,
                                key: transactionHash,
                                time: ult_time,
                                pic_cid: cidOfNFTImg,
                              ).toJson());
                          final doc2 = FirebaseFirestore.instance
                            .collection("user")
                            .doc(emailuser2)
                            .collection("contract")
                            .doc(contractname);
                          final doc1 = FirebaseFirestore.instance
                            .collection("user")
                            .doc(email)
                            .collection("contract")
                            .doc(contractname);
                          final ref = FirebaseStorage.instance.ref().child(path);
                          await ref.delete();
                          doc1.delete();
                          doc2.delete();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          //TODO: switch to other page after successful transaction
                          //please detect if error occur or not
                        }
                      }),
                ),
                SizedBox(width: 40),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromARGB(255, 96, 121, 219),
                  ),
                //padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 3),
                    ),
                  child: Text(
                    "reject",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () => show_dialog(context)
                ),
              ),
            ],
          ),
          const Spacer(flex: 3),
        ],
      )
    );
  }
  show_dialog(BuildContext context){
  showDialog(
    context: context, 
    builder: (BuildContext context) =>  CupertinoAlertDialog(
      title: Text("Think Twice"),
      content: Text("Want to discard this contract?"),
      actions: [
        CupertinoDialogAction(
          child: Text(
            'No'
          ),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        CupertinoDialogAction(
          child: Text(
            'Yes'
          ),
          onPressed: ()async{
            final doc2 = FirebaseFirestore.instance
            .collection("user")
            .doc(emailuser2)
            .collection("contract")
            .doc(contractname);
          final doc1 = FirebaseFirestore.instance
            .collection("user")
            .doc(email)
            .collection("contract")
            .doc(contractname);
            final ref = FirebaseStorage.instance.ref().child(path);
            ref.delete();
            doc1.delete();
            doc2.delete();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        )
      ],
    )
  );
}
}
Future<String> getTime() async{
  Response response =  await get(Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Taipei')) ;
    Map data = jsonDecode(response.body);
    print(data);
    String datetime = data['datetime'];
    String offset = data['utc_offset'].substring(1,3);
    //print(datetime);
    //print(offset);

    //create DateTime object
    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: int.parse(offset)));
    String time = DateFormat.yMEd().add_jms().format(now);
    return time;
}
