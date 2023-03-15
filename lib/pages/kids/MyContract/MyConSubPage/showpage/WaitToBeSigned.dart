import 'dart:io';
import 'package:data_storing_via_blockchain/Classes/usermodel.dart';
import 'package:data_storing_via_blockchain/pages/kids/NormalContract/ShowFile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class WaitToBeSigned extends StatefulWidget {
  final Map<String, dynamic>data;

  const WaitToBeSigned({
    super.key,
    required this.data,
  });

  @override
  State<WaitToBeSigned> createState() => _WaitToBeSignedState(data: data);
}

class _WaitToBeSignedState extends State<WaitToBeSigned> {
  late String contractname;
  late String name;
  late String time;
  late String path;
  final Map<String, dynamic>data;

  _WaitToBeSignedState({required this.data});

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
            padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
            child: Text(
              "簽署時間 : ",
              style: TextStyle(
                fontSize: 20,
              ) 
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(30, 0, 10, 20),
            child: Text(
              time,
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
          const Spacer(flex: 19),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
            alignment:Alignment.bottomCenter,
            child: Text(
              "等待對方同意",
              style: TextStyle(
                fontSize: 26,
              ),
            ),
          ),
          const Spacer(flex: 1),
          
        ],
      )
    );
  }
}

void openPDF(BuildContext context, File file) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => PDFViewPage(file: file)));