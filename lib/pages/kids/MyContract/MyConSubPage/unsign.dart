
//(待簽署)

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_storing_via_blockchain/Classes/user.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/showpage/ShowConInfo.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/showpage/WaitToBeSigned.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/showpage/WaitToSign.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/showpage/WaitUpload.dart';
import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class UnSignCon extends StatefulWidget {
  const UnSignCon({super.key});

  @override
  State<UnSignCon> createState() => _UnSignConState();
}

class _UnSignConState extends State<UnSignCon> {
  late String email;
  String userorder = "";
  bool user2HaveCheck = false;
  bool user1HaveCheck = false;
  String user2Time="";
  bool e = true;

  @override
  Widget build(BuildContext context) {

    final tmp = Provider.of<GoogleSignInProvider>(context);
    email= tmp.user.email;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
      .collection('user').doc(email).collection('contract')
      .snapshots(),
      builder: (context, snapshot){
        if (snapshot.hasError){
          return Text('Something went Wrong! ${snapshot.error}');
        
        } else if(snapshot.hasData){
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length, 
              itemBuilder: (context, index) {

                var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                userorder = data['order'];
                user1HaveCheck = data['have_checked'];
                String anotherEmail1 = data['another_email'];
                final snap =
                  FirebaseFirestore.instance.collection("user")
                  .doc(anotherEmail1)
                  .collection("contract")
                  .doc(data['contractname'])
                  .get().then(
                  (DocumentSnapshot doc) {
                    final datas = doc.data() as Map<String, dynamic>;
                    if(e){
                      setState(() {
                      user2Time = datas['time'];
                      user2HaveCheck = datas['have_checked'];
                      e = false;
                    });
                    }
                  },
                );

                return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 209, 208, 208),
                      ),
                      title: Text(
                        data['contractname'],
                        style: TextStyle(
                          fontSize: 20,
                        )
                      ),
                      subtitle: Text(data['name']),
                      trailing: hi(),
                      onTap: (){
                        print(user2Time);
                        if(data['have_checked'] && user2HaveCheck){
                          if(userorder=="first"){
                            Show_data1(context, data, email, user2Time);
                          }else{
                            Show_data4(context, data);
                          }
                        } else if (data['have_checked']){
                          Show_data2(context, data);
                        } else {
                          Show_data3(context, data);
                        }
      
                      }
                    )
                  );
              },
            );
        } else if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        } else {
          return Text('no data');
        }
      }
    );
  }
    hi() {
      if(userorder=="first"){
        if(user2HaveCheck){
          return Text(
            '等待上鏈',
            style: TextStyle(
              color: Color.fromARGB(255, 53, 137, 56),
            ),
          );
        } else {
          return Text(
            '等待對方同意',
            style: TextStyle(
              color: Colors.blue,
            ),
          );
        }
      } else {
        if(user1HaveCheck){
          return Text(
            '等待對方上鏈',
            style: TextStyle(
              color: Color.fromARGB(255, 53, 137, 56),
            ),
          );
        } else {
          return Text(
            '需同意',
            style: TextStyle(
              color: Colors.blue,
            ),
          );
        }
      }
    }
}


void Show_data1(BuildContext context, Map<String, dynamic>data, String email, String user2time) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => WaitUpload(data: data, user2time: user2time, email: email)));
void Show_data2(BuildContext context, Map<String, dynamic>data) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => WaitToBeSigned(data: data)));
void Show_data3(BuildContext context, Map<String, dynamic>data) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => WaitToSign(data: data)));
void Show_data4(BuildContext context, Map<String, dynamic>data) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => ShowInfo(data: data)));

