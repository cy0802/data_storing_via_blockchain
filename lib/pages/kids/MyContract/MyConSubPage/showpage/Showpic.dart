import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowPic extends StatefulWidget {
  final Map<String, dynamic> data;

  const ShowPic({super.key, required this.data});

  @override
  State<ShowPic> createState() => _ShowPicState(data: data);
}

class _ShowPicState extends State<ShowPic> {
  final Map<String, dynamic> data;
  late String contractname;
  late String name;
  late String time;
  late String key;
  late String cid;
  _ShowPicState({required this.data});

  @override
  void initState(){
    super.initState();
    initialization();
  }

  void initialization() {
    contractname = data['contractname'];
    name = data['name'];
    time = data['time'];
    key = data['key'];
    cid = data['pic_cid'];
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title : Text(
          
          'Contract detail'
        ),
        backgroundColor: Color.fromARGB(255, 188, 146, 255),
      ),
      body: SingleChildScrollView (
        child: Column(
          children: [
            Container(
            alignment:Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(10, 30, 0, 10),
            child: Text(
              "Contract's name : ",
              style: TextStyle(
                fontSize: 20,
              ) 
            ),
          ),
          Container(
            alignment:Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(35, 0, 35, 30),
            child: Text(
              contractname,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            alignment:Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
            child: Text(
              "Both Signer : ",
              style: TextStyle(
                fontSize: 20,
              ) 
            ),
          ),
          Container(
            alignment:Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(40, 0, 10, 30),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
            child: Text(
              "Uploaded Time : ",
              style: TextStyle(
                fontSize: 20,
              ) 
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(40, 0, 10, 30),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
            child: Text(
              "Contract's key : ",
              style: TextStyle(
                fontSize: 20,
              ) 
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(18, 0, 18, 5),
            child: SelectableText(
              key,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0,  0, 0, 30),
            child: Text(
              "(This key allows you to view your contract)\n",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: 217),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Text(
              "Scroll down",
              style: TextStyle(
                fontSize: 22,
              ) 
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Text(
              "and View your own NFT image",
              style: TextStyle(
                fontSize: 22,
              ) 
            ),
          ),
          Container(
            
            alignment: Alignment.center,
            child: Icon(Icons.expand_more)
          
          ),
          SizedBox(height: 70),
          Container(
            child: Image.network(
              'https://ipfs.io/ipfs/$cid',
              fit: BoxFit.cover
            ),
            //constraints: new BoxConstraints.expand(),
          ),
            
          ],
        ),
      ),
    );
  }
}