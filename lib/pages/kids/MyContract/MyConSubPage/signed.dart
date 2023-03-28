import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_storing_via_blockchain/Classes/userpreserve.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/showpage/Showpic.dart';
import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    final user = FirebaseAuth.instance.currentUser!;
    String email= user.email!;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/check');
        },
        backgroundColor: Color.fromARGB(255, 147, 116, 62),
        child: const Icon(Icons.search),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search,color: Color.fromARGB(255, 170, 111, 23)),
                  hintText: 'Contract',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 170, 111, 23)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color.fromARGB(255, 173, 81, 0),width: 2.2)),
                ),
                onChanged: (val){
                  setState(() {
                    name = val;
                  });
                }
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(3, 0, 3, 10),
              alignment: Alignment.center,
              color: Color.fromARGB(255, 252, 209, 144),
              width: 600.0,
              height: 48.0,
              child: const Text(
                'Contract Information',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 20,
                )
              ),
              
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
              .collection('user').doc(email).collection('contractPreserve')
              .snapshots(),
              builder: (context, snapshot){
                if (snapshot.hasError){
                  return Text('Something went Wrong! ${snapshot.error}');
          
                } else if(snapshot.hasData){
                  int length = snapshot.data!.docs.length;
                  if(length == 0){
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(height: 150),
                          Text(
                            textAlign: TextAlign.center,
                            'No contract',
                            style: TextStyle(
                              fontSize: 18
                            )
                          ),
                        ],
                      )
                    );
                  }else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length, 
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        String cid = data['pic_cid'];
                          if(name.isEmpty) {
                            
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Color.fromARGB(255, 209, 208, 208),
                                  backgroundImage: NetworkImage('https://ipfs.io/ipfs/$cid'),
                                ),
                                title: Text(
                                  data['contractname'],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 20,
                                  )
                                ),
                                subtitle: Text(data['name']),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: ()async{
                                  Show_pic(context, data);
                                }
                              )
                            );
                          }
                          if(data['contractname'].toString().toLowerCase().startsWith(name.toLowerCase())){
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Color.fromARGB(255, 209, 208, 208),
                                  backgroundImage: NetworkImage('https://ipfs.io/ipfs/$cid'),
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
                                  Show_pic(context, data);
                                }
                              )
                            );
                          }
                          return Container();
                          
                      },
                   );
                  }
                } else if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Text('no data');
                }
              }
            ),
          ],
        ),
      ),
    );  
  }
}
void Show_pic(BuildContext context, Map<String, dynamic> data) =>
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ShowPic(data : data)));
  