import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(199, 0, 0, 0),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(flex: 3),
            const FlutterLogo(size: 120),
            const Spacer(flex: 3),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Want to store your contract?',
                style: TextStyle(
                  color: Color.fromARGB(255, 220, 220, 220),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Login to your account to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 213, 213, 213),
                  ),
              ),
            ),
            const Spacer(flex: 3),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
              label: const Text('Sign Up With Google'),
              onPressed: () {
                final provider = 
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              },
            ),
            const SizedBox(height: 40),
            RichText(
              text: const TextSpan(
                text: 'Already have an account? ',
                children: [
                  TextSpan(
                    text: 'Log in',
                    style: TextStyle(decoration: TextDecoration.underline),
                  )
                ]
              ),
            ),
            const Spacer(flex: 2),
          ],
          )
      ),
    );
  }
}