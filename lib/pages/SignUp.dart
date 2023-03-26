import 'package:data_storing_via_blockchain/font/utils.dart';
import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      backgroundColor: Color.fromARGB(56, 148, 80, 7),

      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Color.fromARGB(45, 0, 0, 0), BlendMode.dstATop),
            image: AssetImage("assets/image-1-bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(flex: 5),
            const Center(
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/image-1.png'),
                radius: 100,
              ),
            ),
            const Spacer(flex: 5),
            Center(
              child: Text(
                'Welcome Back!',
                style: SafeGoogleFont (
                  'Twinkle Star',
                  fontSize: 40*ffem,
                  decorationThickness: 1000,
                  height: 1.28*ffem/fem,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            const Divider(
              thickness: 3,
              color: Colors.brown,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Want to store your contract?',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ), 
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft, 
              child: Text(
                'Login to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                  ),
              ),
            ),
            const Spacer(flex: 4),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon( Icons.mail_outlined, color: Colors.red,),
              label: const Text('Sign Up With Gmail'),
              onPressed: () async {
                final provider = 
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                await provider.googleLogin();
                // ignore: prefer_const_constructors
                final snackBar = SnackBar(
                  content: const Text(
                    'Sign In Successfully !',
                    textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar); 
                  },
            ),
            const Spacer(flex: 1),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
              label: const Text('Sign Up With Google'),
              onPressed: () async {
                final provider = 
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                await provider.googleLogin();
                // ignore: prefer_const_constructors
                final snackBar = SnackBar(
                  content: const Text(
                    'Sign In Successfully !',
                    textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar); 
                  },
            ),
            const SizedBox(height: 40),
            RichText(
              text: const TextSpan(
                text: 'Don’t have a google account?  ',
                children: [
                  TextSpan(
                    text: 'Sign up',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ]
              ),
            ),
            const Spacer(flex: 4),
          ],
          )
      ),
    );
  }
}