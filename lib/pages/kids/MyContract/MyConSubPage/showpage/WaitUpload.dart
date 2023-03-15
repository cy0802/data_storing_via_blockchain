import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_storing_via_blockchain/Classes/userpreserve.dart';
import 'package:data_storing_via_blockchain/pages/kids/NormalContract/ShowFile.dart';
import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'package:provider/provider.dart';

class WaitUpload extends StatefulWidget {

  final Map<String, dynamic>data;
  final String email;
  final String user2time;

  const WaitUpload({
    super.key,
    required this.data,
    required this.email, required this.user2time,
  });

  @override
  State<WaitUpload> createState() => _WaitUploadState(data: data, email: email, user2time: user2time);
}

class _WaitUploadState extends State<WaitUpload> {

  late String contractname;
  late String name;
  late String user1time;
  late String user2time;
  late String emailuser2;
  late String path;
  bool isChecked = false;

  final Map<String, dynamic>data;
  final String email;
  _WaitUploadState({ required this.data, required this.email, required this.user2time});

  void openPDF(BuildContext context, File file) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => PDFViewPage(file: file)));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  void initialization()async{
    contractname = data['contractname'];
    name = data['name'];
    user1time = data['time'];
    emailuser2 = data['another_email'];
    path = data['path'];
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: const Text(
          'Contract information',
          style: TextStyle(
            color: Colors.black,
          )
        ),
        centerTitle: true,
        actions: [],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 20, 0, 15),
                child: Text(
                  "合約名稱 : ",
                  style: TextStyle(
                    fontSize: 20,
                  ) 
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 20, 10, 15),
                child: Text(
                  contractname,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
                child: Text(
                  "雙方合約人 : ",
                  style: TextStyle(
                    fontSize: 20,
                  ) 
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 10, 20),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(10, 0, 0, 15),
            child: Text(
              "自身簽署時間 : ",
              style: TextStyle(
                fontSize: 20,
              ) 
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(30, 0, 10, 20),
            child: Text(
              user1time,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(10, 10, 0, 15),
            child: Text(
              "對方最後簽署時間 : ",
              style: TextStyle(
                fontSize: 20,
              ) 
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(30, 0, 10, 20),
            child: Text(
              user2time,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
            alignment:Alignment.topLeft,
            child: Text(
              "檢視檔案 : ",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          ElevatedButton(
            child: Text(
              '檢視合約',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 107, 92, 203),
              padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 10),
            ),
            onPressed: () async {
              var result = File(path);
              openPDF(context, result);
            }, 
          ),
          CheckboxListTile(
            title: Text(
              '閱畢無誤且同意上鏈'
            ),
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
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
            alignment:Alignment.bottomCenter,
            
            child: ElevatedButton(
              child: Text(
                "上鏈",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onPressed: () async{
                if(isChecked){
  
                  //var cidOfContract = await FlutterIpfs().uploadToIpfs(path);
                  
                  await FirebaseFirestore.instance
                        .collection("user")
                        .doc(email)
                        .collection("contractPreserve")
                        .doc(contractname)
                        .set(UserPreserve(
                          name: name,
                          contractname: contractname,
                          another_email: emailuser2,
                          key: "12",
                          time: user1time,
                          pic_cid: "123",
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
                          key: "23",
                          time: user2time,
                          pic_cid: "123",
                        ).toJson());

                  /*showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => const ProgressDialog(
                        status: 'Contract Uploading to IPFS',
                      ),
                    );

                  debugPrint("cidOfContract: $cidOfContract");
                  String jsonPath = "";
                    generateNFT(cidOfContract, email, emailuser2).then((s) {
                      setState(() {
                        jsonPath = s;
                      });
                      mint(jsonPath);
                    });*/

                  FirebaseFirestore.instance.collection("user").doc(email).collection("contract").doc(contractname).delete();
                  FirebaseFirestore.instance.collection("user").doc(emailuser2).collection("contract").doc(contractname).delete();
                  
                  Navigator.of(context).pop();
                }
              }
            ),
          ),
          const Spacer(flex: 1),
        ],
      )
    );
  }
}