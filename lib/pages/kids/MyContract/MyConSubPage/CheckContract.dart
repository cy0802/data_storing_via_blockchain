import 'package:flutter/material.dart';

class CheckContract extends StatefulWidget {
  const CheckContract({super.key});

  @override
  State<CheckContract> createState() => _CheckContractState();
}
final TextEditingController controller1 = TextEditingController();

class _CheckContractState extends State<CheckContract> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 249, 207, 116),
        iconTheme: IconThemeData(color: Colors.brown),
        title: Text(
          'check your contract',
          style: TextStyle(
            color: Colors.brown,
          )
        ),
        centerTitle: true,
      ),
      body: Form(
        child: Column(
          children: <Widget>[
            Spacer(flex: 1),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Center(
                child: Text(
                  "Put your contract's key here",
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 20,
                  ),
                ),
              )
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: TextFormField(
                controller: controller1,
                decoration: const InputDecoration(
                  hintText: 'key',
                  fillColor: Color.fromARGB(255, 227, 188, 122),
                  filled: true,
                  contentPadding: EdgeInsets.all(12.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 219, 164, 106), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 142, 100, 38), width: 2.0),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 175, 110, 53),
              ),
              child: Text(
                'search',
              ),
              onPressed: () {  },
            ),
            Spacer(flex: 15),
          ],
          
        ),
      )
    );
  }
}