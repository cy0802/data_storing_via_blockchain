//(待簽署)

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_storing_via_blockchain/Classes/user.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/showpage/ShowConInfo.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/showpage/WaitToBeSigned.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/showpage/WaitToSign.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/showpage/WaitUpload.dart';
import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnSignCon extends StatefulWidget {
  const UnSignCon({super.key});

  @override
  State<UnSignCon> createState() => _UnSignConState();
}

class _UnSignConState extends State<UnSignCon> {
  late String email;

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!;
    email= user.email!;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(email)
              .collection('contract')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went Wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              int length = snapshot.data!.docs.length;
              if(length == 0){
                return Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    'Go to upload your own contract !',
                    style: TextStyle(
                      fontSize: 18
                      
                    )
                  )
                );
              }else {
                return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  String user1state = "";
                  var data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  user1state = data['order'];
                  String anotherEmail1 = data['another_email'];
    
                  return Card(
                      child: ListTile(
                          leading: state_icon(user1state),
                          title: Text(data['contractname'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 20,
                              )),
                          subtitle: Text(data['name']),
                          trailing: state_text(user1state),
                          onTap: () async {
                            DocumentSnapshot snap = await FirebaseFirestore
                                .instance
                                .collection("user")
                                .doc(anotherEmail1)
                                .collection("contract")
                                .doc(data['contractname'])
                                .get();
                            if (user1state == "wait for agreement") {
                              Show_data2(context, data);
                            } else if (user1state == "agree") {
                              Show_data3(context, data);
                            } else if (user1state == "upload") {
                              Show_data1(context, data, email, snap['time']);
                            } else {
                              Show_data4(context, data);
                            }
                          }));
                },
              );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Text('no data');
            }
          }),
    );
  }
}

void Show_data1(BuildContext context, Map<String, dynamic> data, String email,String time) =>
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            WaitUpload(data: data, email: email, time: time)));
void Show_data2(BuildContext context, Map<String, dynamic> data) =>
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => WaitToBeSigned(data: data)));
void Show_data3(BuildContext context, Map<String, dynamic> data) =>
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => WaitToSign(data: data)));
void Show_data4(BuildContext context, Map<String, dynamic> data) =>
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ShowInfo(data: data)));

state_text(String user1state) {
  if (user1state == "upload") {
    return const Text(
      'upload',
      style: TextStyle(
        color: Color.fromARGB(255, 53, 137, 56),
      ),
    );
  } else if (user1state == "wait for agreement") {
    return const Text(
      'wait for agreement',
      style: TextStyle(
        color: Colors.blue,
      ),
    );
  } else if (user1state == "wait for uploaded") {
    return const Text(
      'wait for uploaded',
      style: TextStyle(
        color: Color.fromARGB(255, 53, 137, 56),
      ),
    );
  } else {
    return const Text(
      'agree',
      style: TextStyle(
        color: Colors.blue,
      ),
    );
  }
}
state_icon(String user1state) {
  if (user1state == "upload") {
    return const Icon(Icons.upload, size: 40.0, color: Colors.brown);
  } else if (user1state == "wait for agreement") {
    return const Icon(Icons.history_rounded, size: 40.0, color: Colors.brown);
  } else if (user1state == "wait for uploaded") {
    return const Icon(Icons.outbox_rounded, size: 40.0, color: Colors.brown);
  } else {
    return const Icon(Icons.drive_file_rename_outline_rounded, size: 40.0, color: Colors.brown);
  }
}
