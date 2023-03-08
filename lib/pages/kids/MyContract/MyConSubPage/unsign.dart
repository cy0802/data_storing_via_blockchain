

//(帶簽署)


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
  //late bool user2_have_check;
  //late bool user1_have_check;
  @override
  Widget build(BuildContext context) {

    final tmp = Provider.of<GoogleSignInProvider>(context);
    email= tmp.user.email;

    return StreamBuilder<List<User>>(
      stream: readUsers(email),
      builder: (context, snapshot){
        
        if (snapshot.hasError){
          return Text('Something went Wrong! ${snapshot.error}');

        } else if(snapshot.hasData){
          final users = snapshot.data!;
          return ListView(
            children: users.map(buildUser).toList(),
          );

        } else if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        } else {
          return Text('no data');
        }
      }
      
    );
    
  }
  
  Stream<List<User>> readUsers(String email) => FirebaseFirestore.instance
      .collection('user').doc(email).collection('contract')
      .snapshots()
      .map((snapshot)=>
              snapshot.docs.map((doc)=> User.fromJson(doc.data())).toList());
  
  Widget buildUser(User user) => 
    Card(
      child: ListTile(
        leading: Icon(Icons.upload),
        title: Text(user.contractname),
        subtitle: Text(user.name),
        onTap: ()async{
          //找資料
          DocumentSnapshot snap1 = await FirebaseFirestore.instance.collection("user").doc(email).collection("contract").doc(user.contractname).get();
          String anotherEmail1 = snap1['another_email'];
          DocumentSnapshot snap2 = await FirebaseFirestore.instance.collection("user").doc(anotherEmail1).collection("contract").doc(user.contractname).get();
          bool user2_have_check = snap2['have_checked'];
          bool user1_have_check = user.have_checked;
          String user2Time = snap2['time'];
          

          if(user.have_checked && user2_have_check){
            if(user.order=="first"){
              Show_data1(context, user.contractname, user.name, user.time, user2Time);
            }else{
              Show_data4(context, user.contractname, user.name, user.time);
            }
            
          } else if (user.have_checked){
            Show_data2(context, user.contractname, user.name, user.time);
          } else {
            Show_data3(context, user.contractname, user.name, user.time);
          }
            
        },
      ),
      
    );
    /*hi() {
      if(user1_have_check && user2_have_check){
        return Icon(Icons.upload); 
      } else if (user1_have_check){
        return Icon(Icons.flaky_rounded); 
      } else {
        return Icon(Icons.drive_file_rename_outline_rounded); 
      }
    }*/
}


void Show_data1(BuildContext context, String contractname, String name, String user1time, String user2time) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => WaitUpload(contractname: contractname, name: name, user1time: user1time, user2time: user2time)));
void Show_data2(BuildContext context, String contractname, String name, String time) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => WaitToBeSigned(contractname: contractname, name: name, time: time)));
void Show_data3(BuildContext context, String contractname, String name, String time) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => WaitToSign(contractname: contractname, name: name, time: time)));
void Show_data4(BuildContext context, String contractname, String name, String time) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => ShowInfo(contractname: contractname, name: name, time: time)));
