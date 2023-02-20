import 'package:data_storing_via_blockchain/button/HoverButton2.dart';
import 'package:data_storing_via_blockchain/button/Hover_Button1.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 105, 94, 179),
        title: const Text('Data Storing via Blockchain'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: const <Widget>[
                  SizedBox(height: 200.0),
                  Text(
                    '合約上鏈',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: 'Fradoka',
                    ),
                  ),
                  SizedBox(height: 4.0),
                  HovBut1(),
                ],
              ),
              const SizedBox(width: 50.0),
              Column(
                children: const <Widget>[
                  SizedBox(height: 200.0),
                  Text(
                    '定型化契約',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    ),
                  SizedBox(height: 4.0),
                  HovBut2(),
                ],
                ),
            ],
          ),
          const SizedBox(height: 10.0),
          Container(
            child: ElevatedButton(
              child: const Text(
                '檢查合約',
                style: TextStyle(
                  color: Colors.white,
                )
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:const Color.fromARGB(255, 62, 161, 243),
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              ),
              onPressed: (){
                Navigator.pushNamed(context, '/check');
              }
            ),
          ),
        ],
      ),  
    );
  }
}