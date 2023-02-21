import 'package:flutter/material.dart';


class UnSignCon extends StatefulWidget {
  const UnSignCon({super.key});

  @override
  State<UnSignCon> createState() => _UnSignConState();
}

class _UnSignConState extends State<UnSignCon> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
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
        );
  }
}