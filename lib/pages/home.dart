import 'package:data_storing_via_blockchain/Classes/ShowDialog.dart';
import 'package:data_storing_via_blockchain/font/utils.dart';
import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    initialization();
  }
  void initialization() async{
    final currentUser = await FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await currentUser.reload();
    }
  }


  @override
  Widget build(BuildContext context) {
    
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black,
          onPressed: (){},
        ),
        centerTitle: true,
        title: Text(
          '與你相鏈',
          style: SafeGoogleFont(
            letterSpacing: 2,
            'Twinkle Star',
            color: Colors.black,
            fontSize: 22,
            //fontWeight: FontWeight.bold,
          )
        ), 
        actions: [
          TextButton(
            onPressed: ()=> show_dialog(context, user.email!),
            child: CircleAvatar(
              radius: 17,
              backgroundImage: NetworkImage(user.photoURL!),
          ),
            ) 
        ]
      ),
      body: Column(
        children: [
          const Spacer(flex: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text(
                    'upload contract',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontFamily: 'Fradoka',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 102, 184, 251),
                    ),
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 115, vertical: 100),
                      ),
                      icon: const Icon(
                        size: 40.0,
                        Icons.add_to_home_screen,
                        color: Colors.white,
                      ),
                      label: const Text(''),
                      onPressed: () {
                        Navigator.pushNamed(context, '/NormCon');
                      },
                    ),
                  ),
                ],
              ),
              // Column(
              //   children: <Widget>[
              //     const Text(
              //       '定型化契約',
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontSize: 18.0,
              //       ),
              //     ),
              //     const SizedBox(height: 20.0),
              //     ElevatedButton.icon(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: const Color.fromARGB(255, 102, 184, 251),
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 60, vertical: 90),
              //       ),
              //       icon: const Icon(
              //         Icons.article_rounded,
              //         color: Colors.white,
              //       ),
              //       label: const Text(''),
              //       onPressed: () {
              //         Navigator.pushNamed(context, '/StdCon');
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
          const Spacer(flex: 1),
          Container(
            child: ElevatedButton(
                child: const Text(
                  'check your contract',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 62, 161, 243),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 75, vertical: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/check');
                }),
          ),
          const Spacer(flex: 1),
          Container(
            child: ElevatedButton(
                child: const Text(
                  'My Contract',
                    style: TextStyle(
                      color: Colors.white,
                    )
                  ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 62, 161, 243),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/RecordedCon');
                }
              ),
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }
}
