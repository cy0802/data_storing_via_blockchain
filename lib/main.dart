import 'package:data_storing_via_blockchain/pages/LoginHome.dart';
import 'package:data_storing_via_blockchain/pages/NormCon.dart';
import 'package:data_storing_via_blockchain/pages/RecordedCon.dart';
import 'package:data_storing_via_blockchain/pages/StdCon.dart';
import 'package:data_storing_via_blockchain/pages/check.dart';
import 'package:data_storing_via_blockchain/pages/home.dart';
import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:data_storing_via_blockchain/widget/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyAPP());
}
class MyAPP extends StatelessWidget {
  const MyAPP({super.key});
  static final String title = 'MainPage';

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
        }
      ),
    );
  }
}