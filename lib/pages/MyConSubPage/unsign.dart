

//(帶簽署)


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_storing_via_blockchain/Classes/user.dart';
import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnSignCon extends StatefulWidget {
  const UnSignCon({super.key});

  @override
  State<UnSignCon> createState() => _UnSignConState();
}

class _UnSignConState extends State<UnSignCon> {
  
  @override
  Widget build(BuildContext context) {

    final tmp = Provider.of<GoogleSignInProvider>(context);
    String email= tmp.user.email;

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
        leading: CircleAvatar(),
        title: Text(user.contractname),
        subtitle: Text(user.name),
        onTap: (){
            
        },
      ),
    );
}
