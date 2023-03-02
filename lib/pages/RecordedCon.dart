import 'package:data_storing_via_blockchain/pages/MyConSubPage/signed.dart';
import 'package:data_storing_via_blockchain/pages/MyConSubPage/unsign.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History contract'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '待簽署', icon: Icon(Icons.border_color)),
              Tab(text: '已簽署', icon: Icon(Icons.assignment_turned_in)),
            ],
          )
        ),
        body: const TabBarView(
          children: [UnSignCon(), SignedCon()],
        )
      ),
    );
  }
} 