//NOW IT IS NOT USED

import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> signIn() async{
    if(await _googleSignIn.isSignedIn()){
      return _googleSignIn.currentUser; 
    }
    return await _googleSignIn.signIn();
  }

  static Future signOut() => _googleSignIn.signOut();
} 