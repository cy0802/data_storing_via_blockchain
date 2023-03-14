import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_storing_via_blockchain/Classes/userpreserve.dart';
import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitUpload extends StatefulWidget {
  final String contractname;
  final String name;
  final String user1time;
  final String user2time;


  const WaitUpload({
    super.key,
    required this.contractname,
    required this.name,
 
    required this.user1time, 
    required this.user2time
  });

  @override
  State<WaitUpload> createState() => _WaitUploadState(contractname: contractname, name: name, user1time: user1time, user2time: user2time);
}

class _WaitUploadState extends State<WaitUpload> {
  final String contractname;
  final String name;
  final String user1time;
  final String user2time;
  _WaitUploadState({required this.user1time, required this.user2time, required this.contractname,
    required this.name, });

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final tmp = Provider.of<GoogleSignInProvider>(context);
    String email1 = tmp.user.email;
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
        actions: []
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
                  final doc1 = await FirebaseFirestore.instance.collection("user").doc(email1).collection("contract").doc(contractname);
                  DocumentSnapshot snap1 = await doc1.get();
                  String email2 = snap1['another_email'];
                  final doc2 = await FirebaseFirestore.instance.collection("user").doc(email2).collection("contract").doc(contractname);
                  await FirebaseFirestore.instance
                        .collection("user")
                        .doc(email1)
                        .collection("contractPreserve")
                        .doc(contractname)
                        .set(UserPreserve(
                          name: name,
                          contractname: contractname,
                          another_email: email2,
                          key: "12",
                          time: user1time,
                          pic_cid: "123",
                        ).toJson());
                  await FirebaseFirestore.instance
                        .collection("user")
                        .doc(email2)
                        .collection("contractPreserve")
                        .doc(contractname)
                        .set(UserPreserve(
                          name: name,
                          contractname: contractname,
                          another_email: email1,
                          key: "23",
                          time: user2time,
                          pic_cid: "123",
                        ).toJson());
                  
                  doc1.delete();
                  doc2.delete();
                  
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