import 'package:flutter/material.dart';

//import 'firebase_options.dart';


class StdCon extends StatefulWidget {
  const StdCon({super.key});

  @override
  State<StdCon> createState() => _StdConState();
}

class _StdConState extends State<StdCon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plugin example app'),
        actions: <Widget>[
          CircleAvatar(
            //backgroundImage: AssetImage('assets/Old_Nike_logo.jpg'),
            radius: 20,
          ),
        ],
      ),
      //body: MessagingWidget(),
    );
  }
}