import 'dart:io';
import 'package:data_storing_via_blockchain/function/local_folder.dart';
import 'package:data_storing_via_blockchain/pages/kids/NormalContract/ShowFile.dart';
import 'package:flutter/material.dart';


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
  late String totalPath;
  late File file;
  late String path1;
  final Map<String, dynamic>data;
  bool isLoading = false;
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
    path1 = await appDocPath;
    totalPath = '$path1/$path';
    file = File(totalPath);
  }

  @override
  Widget build(BuildContext context) {
    print(contractname);
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
            alignment:Alignment.topLeft,
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
              openPDF(context, file);
              setState(() {
                isLoading = false;
              });
            }, 
          ),
          const Spacer(flex: 19),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
            alignment:Alignment.bottomCenter,
            child: Text(
              "Wait for agreement",
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