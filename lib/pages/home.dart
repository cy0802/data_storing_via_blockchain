import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 105, 94, 179),
          title: const Text('Data Storing via Blockchain'),
          actions: [
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogout();
              },
            )
          ]),
      body: Column(
        children: [
          const Spacer(flex: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text(
                    '合約上鏈',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: 'Fradoka',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 102, 184, 251),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 90),
                    ),
                    icon: const Icon(
                      Icons.add_to_home_screen,
                      color: Colors.white,
                    ),
                    label: const Text(''),
                    onPressed: () {
                      Navigator.pushNamed(context, '/NormCon');
                    },
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  const Text(
                    '定型化契約',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 102, 184, 251),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 90),
                    ),
                    icon: const Icon(
                      Icons.article_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(''),
                    onPressed: () {
                      Navigator.pushNamed(context, '/StdCon');
                    },
                  ),
                ],
              ),
            ],
          ),
          const Spacer(flex: 1),
          Container(
            child: ElevatedButton(
                child: const Text('檢查合約',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 62, 161, 243),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/check');
                }),
          ),
          const Spacer(flex: 1),
          Container(
            child: ElevatedButton(
<<<<<<< Updated upstream
                child: const Text('歷史合約',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 62, 161, 243),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/RecordedCon');
                }),
=======
              child: const Text(
                '我的合約',
                style: TextStyle(
                  color: Colors.white,
                )
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:const Color.fromARGB(255, 62, 161, 243),
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              ),
              onPressed: (){
                Navigator.pushNamed(context, '/RecordedCon');
              }
            ), 
>>>>>>> Stashed changes
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }
}
