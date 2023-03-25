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

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(email)
            .collection('contract')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went Wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
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
                        leading: const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 209, 208, 208),
                        ),
                        title: Expanded(
                          child: Text(data['contractname'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 20,
                              )),
                        ),
                        subtitle: Text(data['name']),
                        trailing: hi(user1state),
                        onTap: () async {
                          DocumentSnapshot snap = await FirebaseFirestore
                              .instance
                              .collection("user")
                              .doc(anotherEmail1)
                              .collection("contract")
                              .doc(data['contractname'])
                              .get();
                          if (user1state == "等待對方同意") {
                            Show_data2(context, data);
                          } else if (user1state == "需同意") {
                            Show_data3(context, data);
                          } else if (user1state == "等待上鏈") {
                            Show_data1(context, data, email, snap['time']);
                          } else {
                            Show_data4(context, data);
                          }
                        }));
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Text('no data');
          }
        });
  }
}

void Show_data1(BuildContext context, Map<String, dynamic> data, String email,
        String time) =>
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

hi(String user1state) {
  if (user1state == "等待上鏈") {
    return const Text(
      '等待上鏈',
      style: TextStyle(
        color: Color.fromARGB(255, 53, 137, 56),
      ),
    );
  } else if (user1state == "等待對方同意") {
    return const Text(
      '等待對方同意',
      style: TextStyle(
        color: Colors.blue,
      ),
    );
  } else if (user1state == "等待對方上鏈") {
    return const Text(
      '等待對方上鏈',
      style: TextStyle(
        color: Color.fromARGB(255, 53, 137, 56),
      ),
    );
  } else {
    return const Text(
      '需同意',
      style: TextStyle(
        color: Colors.blue,
      ),
    );
  }
}
