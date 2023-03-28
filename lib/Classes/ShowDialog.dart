import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void show_dialog(BuildContext context, String email) =>  showDialog(
  context: context,
  builder: (BuildContext context) => SimpleDialog(
    
    children: <Widget>[
      SizedBox(height: 10),
      Center(
        child: Text(
          email,
          style: TextStyle(
            fontSize: 20,
          ),
        )
      ),
      SizedBox(height: 10),
      Divider(color: Colors.grey[500]),
      SimpleDialogOption(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        onPressed: () {
          Navigator.pushNamed(context, '/Setting');
        },
        child: Row(
          children: [
            Icon(Icons.settings),
            SizedBox(width: 15),
            Text('Setting', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
      SimpleDialogOption(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        child: Row(
          children: [
            Icon(Icons.logout),
            SizedBox(width: 15),
            Text('Logout', style: TextStyle(fontSize: 16)),
          ],
        ),
        onPressed: () {
          Navigator.pop(context, '');
          final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.googleLogout();
        },
      ),
    ],
  ), 
);