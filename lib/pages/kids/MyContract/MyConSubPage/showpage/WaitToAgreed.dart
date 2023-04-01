import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_storing_via_blockchain/function/local_folder.dart';
import 'package:data_storing_via_blockchain/pages/kids/NormalContract/ShowFile.dart';
import 'package:dio/dio.dart'hide Response;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

//-------------------------------------------------------------divider--------------------------------------------------------------------

//need to agree
class WaitToSign extends StatefulWidget {
  final Map<String, dynamic>data;
  const WaitToSign({
    super.key,
    required this.data,
  });

  @override
  State<WaitToSign> createState() => _WaitToSignState(data: data);
}

class _WaitToSignState extends State<WaitToSign> {

  late String contractname;
  late String name;
  late String time;
  late String path;
  late String totalPath;
  late File file;
  late String email;
  late DocumentReference<Map<String, dynamic>> docuser1;
  late DocumentReference<Map<String, dynamic>> docuser2;
  bool isChecked = false;

  final Map<String, dynamic>data;
  bool isLoading = false;
  _WaitToSignState({required this.data});
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialization();
  }

  void initialization()async{
    contractname = data['contractname'];
    name = data['name'];
    time = data['time'];
    path = data['path'];
    final ref = FirebaseStorage.instance.ref().child(path);
    final urlDownload = await ref.getDownloadURL();
    final path1 = await appDocPath;
    totalPath = '$path1/$path';
    await Dio().download(urlDownload, totalPath);
    file = File(totalPath);
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => PDFViewPage(file: file)));
  
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    email= user.email!;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.brown),
        backgroundColor: Color.fromARGB(255, 223, 154, 90),
        title: const Text(
          'Contract Information',
          style: TextStyle(
            color: Colors.black,
          )
        ),
        centerTitle: true,
        actions: []
      ),
      body: isLoading? 
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Color.fromARGB(255, 213, 162, 110),
                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 180, 111, 32))),
              Text(
                'Showing Picture',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 23,
                ),
              )
            ],
          ),
        )
        :  Column(
        children: [
          Container(
            alignment:Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(10, 30, 0, 10),
            child: Text(
              "Contract's Name : ",
              style: TextStyle(
                fontSize: 20,
              ) 
            ),
          ),
          Container(
            alignment:Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(35, 0, 35, 30),
            child: Text(
              contractname,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            alignment:Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
            child: Text(
              "Both Signers : ",
              style: TextStyle(
                fontSize: 20,
              ) 
            ),
          ),
          Container(
            alignment:Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(35, 0, 35, 30),
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
            child: Text(
              "Signed Time : ",
              style: TextStyle(
                fontSize: 20,
              ) 
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(35, 0, 35, 30),
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
          ElevatedButton.icon(
            label: const Text(''),
            icon: const Icon(
              size: 30.0,
              Icons.content_paste_search,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 167, 118, 100),
              padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 10),
            ),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              Future.delayed(const Duration(milliseconds: 2000), () {
                setState(() {
                  isLoading = false;
                });
                openPDF(context, file);
              });
            }, 
          ),
          CheckboxListTile(
            title: Text(
              'I Confirm the correctness of the contract'
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Color.fromARGB(255, 209, 134, 53),
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
                      color: Color.fromARGB(255, 167, 118, 100),
                    ),
                //padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
                child: TextButton(
                  
                  child: Text(
                    "consent",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () async{
                    final docuser1 = await FirebaseFirestore.instance.collection("user").doc(email).collection("contract").doc(contractname);
                    DocumentSnapshot snap = await docuser1.get();
                    String email2 = snap['another_email'];
                    final docuser2 = await FirebaseFirestore.instance.collection("user").doc(email2).collection("contract").doc(contractname);
                    if(isChecked){
                      docuser1.update({
                        'order': "wait for uploaded",
                        'time': await getTime(),
                      });
                      docuser2.update({
                        'order': "upload",
                      });
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
              SizedBox(width: 40),
              Container(
                decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 167, 118, 100),
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
                  onPressed: ()async { 
                    show_dialog(context);
                  }
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
      content: Text("Want to discard this contract?\nif yes, please refill in the form"),
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
            final docuser1 = await FirebaseFirestore.instance.collection("user").doc(email).collection("contract").doc(contractname);
            DocumentSnapshot snap = await docuser1.get();
            String email2 = snap['another_email'];
            final docuser2 = await FirebaseFirestore.instance.collection("user").doc(email2).collection("contract").doc(contractname);
            final ref = FirebaseStorage.instance.ref().child(path);
            ref.delete();
            docuser1.delete();
            docuser2.delete();
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

// CupertinoAlertDialog(
//                       title: Text("Think Twice"),
//                       content: Text("Want to discard this contract?")
//                     );

