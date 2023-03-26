
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/signed.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/unsign.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> 
with SingleTickerProviderStateMixin{
  late TabController controller;

  @override
  void initState(){
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }
  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int result = 0;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 244, 159, 40),
          ],
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.brown),
          title: const Text(
            'History contract',
            style: TextStyle(
              color: Colors.brown,
            )
          ),
          bottom: TabBar(
            controller: controller,
            labelColor: Colors.brown,
            indicatorColor: Colors.brown,
            unselectedLabelColor: Color.fromARGB(255, 173, 113, 89),
            tabs: [
              Tab(text: 'wait to be uploaded', 
              icon: Icon(Icons.border_color)),
              Tab(text: 'uploaded', icon: Icon(Icons.assignment_turned_in)),
            ],
          )
        ),
        
        body: TabBarView(
          controller: controller,
          children: [
            UnSignCon(),
            SignedCon()
          ],
        )
      ),
    );
  }
} 