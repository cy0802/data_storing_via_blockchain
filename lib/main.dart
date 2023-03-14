
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:data_storing_via_blockchain/pages/LoginHome.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/RecordedCon.dart';
import 'package:data_storing_via_blockchain/pages/kids/NormalContract/NormCont.dart';
import 'package:data_storing_via_blockchain/pages/kids/Setting.dart';
import 'package:data_storing_via_blockchain/pages/kids/StdCon.dart';
import 'package:data_storing_via_blockchain/pages/kids/check.dart';
import 'package:data_storing_via_blockchain/pages/home.dart';
import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:data_storing_via_blockchain/pages/SignUp.dart';


//..........................................................我是分隔線.........................................................

// used to send notification 
Future<void> _backgroundHandler(RemoteMessage message) async{
  print('Handling a background message ${message.messageId}');
}

//initialize firebase
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  runApp(MyAPP());
}

class MyAPP extends StatefulWidget {
  const MyAPP({super.key});

  @override
  State<MyAPP> createState() => _MyAPPState();
}

class _MyAPPState extends State<MyAPP> with WidgetsBindingObserver{
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      _logout();
    }
  }
  void _logout() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    }
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GoogleSignInProvider(),
      builder: (context, child){
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/LoginHome',
            routes: {
              '/LoginHome' : (context) => const HomePage(),
              '/SignUp': (context) => const SignUpWidget(),
              '/home': (context) => const Home(),
              '/NormCon': (context) => const NormCon(),
              '/StdCon': (context) => const StdCon(),
              '/check': (context) => const CheckContract(),
              '/RecordedCon' : (context) => const History(),
              '/Setting' : (context) => const Setting(),
            }
        );
      }
    );
  }
}
