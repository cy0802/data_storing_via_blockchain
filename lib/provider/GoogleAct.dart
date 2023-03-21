import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    // Login

    try{
      
      final googleUser = await googleSignIn.signIn();
      if(googleUser == null) return null;

      _user = googleUser;

      //print(user.email);

      //傳到firebase
      await FirebaseMessaging.instance.getToken().then((token) async {
        await FirebaseFirestore.instance.collection("user").doc(user.email).set({'token' : token });
      }
      );
      
      //將現在用戶email存起來

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      
    } catch(e){
      print(e.toString());
    }
    
    notifyListeners(); 
  }

  Future googleLogout() async {
    // Log out
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
