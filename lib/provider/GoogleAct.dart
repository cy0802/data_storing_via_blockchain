import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

//--------------------------------------------------------------- divider ------------------------------------------------------------------


// google signin
class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn(scopes:<String>["email"]);

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  // Login
  Future googleLogin() async {
    
    try{
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if(googleUser == null) return null;

      _user = googleUser;

      //up load user token to firebase in order to send notifications
      await FirebaseMessaging.instance.getToken().then((token) async {
        await FirebaseFirestore.instance.collection("user").doc(user.email).set({'token' : token });
      });
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
      
    } catch(e){
      print(e.toString());
    }
    
    notifyListeners(); 
  }

  // Log out
  Future googleLogout() async {
    
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
