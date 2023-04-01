import 'package:data_storing_via_blockchain/pages/homepage.dart';
import 'package:data_storing_via_blockchain/pages/SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData){
            return Home();
          } else if(snapshot.hasError){
            return Center(child: Text('Something Went Wrong!'));
          } else {
            return SignUpWidget();
          }
        }
      ),
    );
  }
} 