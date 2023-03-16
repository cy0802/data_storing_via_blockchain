import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_storing_via_blockchain/pages/kids/NormalContract/ShowFile.dart';
import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  bool isChecked = false;
  final Map<String, dynamic>data;
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
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => PDFViewPage(file: file)));
  
  @override
  Widget build(BuildContext context) {
    
    final tmp = Provider.of<GoogleSignInProvider>(context, listen: false);
    String email= tmp.user.email;

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
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 20, 10, 15),
                  child: Text(
                    contractname,
                    style: TextStyle(
                      fontSize: 20,
                    ),
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
                child: Text(
                  "同意時間 : ",
                  style: TextStyle(
                    fontSize: 20,
                  ) 
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 5, 10, 20),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
            alignment: Alignment.topLeft,
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
              '您已確認並同意上鏈此份合約'
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
                "請完成同意",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onPressed: () async{
                final docuser = await FirebaseFirestore.instance.collection("user").doc(email).collection("contract").doc(contractname);
                if(isChecked){
                  docuser.update({
                    'have_checked': true,
                    'time': await getTime(),
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          const Spacer(flex: 1),
          
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