import 'package:flutter/material.dart';

class SignedCon extends StatefulWidget {
  const SignedCon({super.key});

  @override
  State<SignedCon> createState() => _SignedConState();
}

class _SignedConState extends State<SignedCon> {
  get controller => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(20),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Contract',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.center,
                color: Colors.grey[400],
                width: 48.0,
                height: 48.0,
                child: const Text(
                  'Contract Name',
                  style: TextStyle(
                    fontSize: 16,
                  )
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.fromLTRB(1, 0, 0, 0),
                alignment: Alignment.center,
                color: Colors.grey[400],
                width: 48.0,
                height: 48.0,
                child: const Text(
                  'Key',
                  style: TextStyle(
                    fontSize: 16,
                  )
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.fromLTRB(1, 0, 0, 0),
                alignment: Alignment.center,
                color: Colors.grey[400],
                width: 48.0,
                height: 48.0,
                child: const Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 16,
                  )
                ),
              ),
            ),
          ]
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 30,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text('Username $index'),
                subtitle: Text('Email $index'),
                trailing: const Icon(Icons.arrow_forward),
              ),
            ),
          ),
        ),
      ],
    );
  }
}