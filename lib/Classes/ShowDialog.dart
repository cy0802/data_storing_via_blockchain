import 'package:data_storing_via_blockchain/provider/GoogleAct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void show_dialog(BuildContext context, String email) =>  showDialog(
  context: context,
  builder: (BuildContext context) => SimpleDialog(
    
    children: <Widget>[
      Center(
        child: Text(
          email,
          style: TextStyle(
            fontSize: 20,
          ),
        )
      ),
      Divider(color: Colors.grey[500]),
      SimpleDialogOption(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        onPressed: () => Navigator.pop(context, 'Cancel'),
        child: const Text('Instruction', style: TextStyle(fontSize: 16)),
      ),

      SimpleDialogOption(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        onPressed: () {
          Navigator.pushNamed(context, '/Setting');
        },
        child: const Text('Setting', style: TextStyle(fontSize: 16)),
      ),
      
      SimpleDialogOption(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        child: const Text('Logout', style: TextStyle(fontSize: 16)),
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