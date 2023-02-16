import 'package:flutter/material.dart';

class CheckContract extends StatefulWidget {
  const CheckContract({super.key});

  @override
  State<CheckContract> createState() => _CheckContractState();
}

class _CheckContractState extends State<CheckContract> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('check your contract'),
        centerTitle: true,
      ),
      body: Form(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(10, 20, 0, 20),
              child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'key',
                fillColor: Color.fromARGB(255, 195, 236, 237),
                filled: true,
                contentPadding: EdgeInsets.all(12.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 116, 238, 240), width: 2.0),
                ),
              ),
            ),
            ),
            ElevatedButton(
              child: Text(
                'search',
              ),
              onPressed: () {  },
            )
          ],
          
        )
        
      )
    );
  }
}