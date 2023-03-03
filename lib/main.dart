
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
import 'package:data_storing_via_blockchain/pages/kids/MyContract/MyConSubPage/ShowPage.dart';

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

class MyAPP extends StatelessWidget {
  const MyAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/LoginHome',
        routes: {
          '/home': (context) => const Home(),
          '/NormCon': (context) => const NormCon(),
          '/StdCon': (context) => const StdCon(),
          '/check': (context) => const CheckContract(),
          '/SignUp': (context) => const SignUpWidget(),
          '/LoginHome' : (context) => const HomePage(),
          '/RecordedCon' : (context) => const History(),
          '/Setting' : (context) => const Setting(),
          '/ShowPage' : (context) => const showData(),
          
        }
      ),
    );
  }
}
