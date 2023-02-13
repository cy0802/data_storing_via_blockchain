import 'package:data_storing_via_blockchain/pages/NormCon.dart';
import 'package:data_storing_via_blockchain/pages/StdCon.dart';
import 'package:data_storing_via_blockchain/pages/home.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => const Home(),
      '/NormCon': (context) => const NormCon(),
      '/StdCon': (context) => const StdCon(),
    }
  ));
}