import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_storing_via_blockchain/Classes/userpreserve.dart';
import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignedCon extends StatefulWidget {
  const SignedCon({super.key});

  @override
  State<SignedCon> createState() => _SignedConState();
}

class _SignedConState extends State<SignedCon> {
  final controller = TextEditingController();
  String name = "";

  @override
  Widget build(BuildContext context) {
    final tmp = Provider.of<GoogleSignInProvider>(context);
    String email= tmp.user.email;

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Contract',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (val){
                setState(() {
                  name = val;
                });
              }
            ),
          ),
          Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    alignment: Alignment.center,
                    color: Colors.grey[400],
                    width: 48.0,
                    height: 48.0,
                    child: const Text(
                      'Contract Name',
                      style: TextStyle(
                        fontSize: 16,
                      )
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(1, 0, 0, 0),
                    alignment: Alignment.center,
                    color: Colors.grey[400],
                    width: 48.0,
                    height: 48.0,
                    child: const Text(
                      'Key',
                      style: TextStyle(
                        fontSize: 16,
                      )
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(1, 0, 0, 0),
                    alignment: Alignment.center,
                    color: Colors.grey[400],
                    width: 48.0,
                    height: 48.0,
                    child: const Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 16,
                      )
                    ),
                  ),
                ),
              ]
            ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
            .collection('user').doc(email).collection('contractPreserve')
            .snapshots(),
            builder: (context, snapshot){
              if (snapshot.hasError){
                return Text('Something went Wrong! ${snapshot.error}');
        
              } else if(snapshot.hasData){
                return 
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length, 
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      if(name.isEmpty) {
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
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: ()async{
                            }
                          )
                        );
                      }
                      if(data['contractname'].toString().toLowerCase().startsWith(name.toLowerCase())){
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
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: ()async{
                            }
                          )
                        );
                      }
                      return Container();
                    },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              } else {
                return Text('no data');
              }
            }
          ),
        ],
      ),
    );  
  }
  
  
}
  