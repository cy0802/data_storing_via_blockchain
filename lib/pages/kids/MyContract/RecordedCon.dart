
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('History contract'),
        bottom: TabBar(
          controller: controller,
          tabs: [
            Tab(text: 'wait for upload', icon: Icon(Icons.border_color)),
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
    );
  }
} 