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
        backgroundColor: Colors.grey[600],
        title: const Text('Data Storing via Blockchain'),
        centerTitle: true,
      ),
      body: Row(
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
            )
          
        ],
      )
    );
  }
}