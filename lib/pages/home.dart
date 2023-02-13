import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        title: const Text('Data Storing via Blockchain'),
        centerTitle: true,
      ),
      body: Row(
        children: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
            Navigator.pushNamed(context, '/NormCon');
            },
            icon: const Icon(Icons.add_to_home_screen),
            label: const Text('合約上鏈'),
          ),
          const SizedBox(width: 10.0),
          ElevatedButton.icon(
            onPressed: () {
            Navigator.pushNamed(context, '/StdCon');
            },
            icon: const Icon(Icons.article_rounded),
            label: const Text('定型化契約'),
          ),
        ],
      )
    );
  }
}