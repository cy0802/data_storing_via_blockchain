import 'dart:io';
import 'package:data_storing_via_blockchain/Classes/usermodel.dart';
import 'package:data_storing_via_blockchain/pages/kids/NormalContract/ShowFile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ShowInfo extends StatefulWidget {
  final String contractname;
  final String name;
  final String time;

  const ShowInfo({
    super.key,
    required this.contractname,
    required this.name,
    required this.time
  });

  @override
  State<ShowInfo> createState() => _ShowInfoState(contractname: contractname, name: name, time: time);
}

class _ShowInfoState extends State<ShowInfo> {
  final String contractname;
  final String name;
  final String time;

  _ShowInfoState({required this.contractname,
    required this.name, required this.time});
  
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
                child: Text(
                  "簽署時間 : ",
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
              //應該有點問題
              final userProvider = Provider.of<UserProvider>(context);
              final userModel = userProvider.userModel;
              openPDF(context, userModel.file as File);

            }, 
          ),
          const Spacer(flex: 19),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
            alignment:Alignment.bottomCenter,
            child: Text(
              "等待對方上傳",
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