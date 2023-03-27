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

  late User user;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    initialization();
  }
  void initialization() async{
    user = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          //colorFilter: ColorFilter.mode(Color.fromARGB(255, 0, 0, 0), BlendMode.dstATop),
          image: AssetImage("assets/brown.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(142, 255, 214, 157),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.brown),
          centerTitle: true,
          title: Text(
            '與你相鏈',
            style: SafeGoogleFont(
              letterSpacing: 2,
              'Twinkle Star',
              color: Color.fromARGB(255, 81, 57, 49),
              fontSize: 25,
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
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildHeader(context, user),
                buildItem(context),
              ],
            )
          )
        ),
        body: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Column(
            children: [
              const Spacer(flex: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const Text(
                        'Upload Contract',
                        style: TextStyle(
                          color: Color.fromARGB(255, 129, 84, 52),
                          fontSize: 22.0,
                          fontFamily: 'Fradoka',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 249, 207, 116),
                              Color.fromARGB(231, 239, 157, 63),
                            ],
                          )
                        ),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 115, vertical: 100),
                          ),
                          icon: const Icon(
                            size: 40.0,
                            Icons.add_to_home_screen,
                            color: Color.fromARGB(255, 183, 108, 47),
                          ),
                          label: const Text(''),
                          onPressed: () {
                            Navigator.pushNamed(context, '/NormCon');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(flex: 2),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 249, 207, 116),
                      Color.fromARGB(231, 239, 157, 63),
                    ],
                  )
                ),
                child: TextButton(
                    child: const Text(
                      'My Contract',
                        style: TextStyle(
                          color: Color.fromARGB(255, 137, 81, 35),
                          fontSize: 18.5
                        )
                      ),
                    style: TextButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/RecordedCon');
                    }
                  ),
              ),
              const Spacer(flex: 2),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 249, 207, 116),
                      Color.fromARGB(231, 239, 157, 63),
                    ],
                  )
                ),
                child: TextButton(
                  child: const Text(
                    'Check Your Contract',
                    style: TextStyle(
                      color: Color.fromARGB(255, 133, 79, 34),
                      fontSize: 18.5
                    )
                  ),
                  style: TextButton.styleFrom(
                    padding:
                      const EdgeInsets.symmetric(horizontal: 55, vertical: 18),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/check');
                  }
                ),
              ),
              const Spacer(flex: 11),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildHeader(BuildContext context, User user) => 
  Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 249, 207, 116),
        Color.fromARGB(231, 239, 157, 63),
      ],
    )
  ),
  padding: EdgeInsets.only(
    top: 24 + MediaQuery.of(context).padding.top,
    bottom: 24,
  ),
  child: Column(
    children: [
      CircleAvatar(
        radius: 52,
        backgroundImage: NetworkImage(user.photoURL!),
      ),
      SizedBox(height: 12),
      Text(
        user.displayName!,
        style: TextStyle(fontSize: 28, color: Colors.brown),
      ),
      SizedBox(height: 6),
      Text(
        user.email!,
        style: TextStyle(fontSize: 16, color: Colors.brown),
      ),
    ],
  )
);
Widget buildItem(BuildContext context) => 
Container(
  padding: const EdgeInsets.all(24),
  child: Wrap(
    runSpacing: 16,
    children: [
      ListTile(
        title: const Text('test'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: const Text('test'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    ],
  ),
);
