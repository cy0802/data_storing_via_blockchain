// normal contract
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:data_storing_via_blockchain/pages/RecordedCon.dart';

//傳通知
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; //so weird
import 'package:http/http.dart' as http;

// 用來用immutable的
import 'package:flutter/foundation.dart'; 

//上傳資料
import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';


//..........................................................我是分隔線...........................................................


class NormCon extends StatelessWidget {
  const NormCon({super.key});
  @override
  Widget build(BuildContext context) {
    const appTitle = "Data Storing via Blockchain";
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: const MyForm(),
    );
  }
}
 
class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {

  //send notofication 
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late final int FLAG_IMMUTABLE;
  
  TextEditingController email_1 = TextEditingController();  
  TextEditingController email_2 = TextEditingController();

  //upload contract
  String filename = "none";
  String cid = "";
  bool valid = false;
  FilePickerResult? file;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    requestPermission();
    initInfo();
  }

  // purpose : receive notification in foreground, 
  initInfo(){
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    //the function does not work
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: (String? payload) async {
      try{
        if(payload != null && payload.isNotEmpty){
          print(".......................onBackgroundMessage.......................");
          print("fdfdffdfdfdfdff");
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return History();
          }
          ));
        } else {
          print(".......................onBackgroundMessage.......................");
          print("fdfdffdfdfdfdff");
          
        }
      }catch(e){
        print(e.toString());
      }
      return;
    });

    //some problems here I can not address
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      print(".......................onMessage.......................");
      print("onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(), 
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(), 
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'hi', 
        'hi channel',
        'hi',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation, 
        priority: Priority.high, 
        playSound: true,
        additionalFlags: Int32List.fromList([FLAG_IMMUTABLE]),

      );

      NotificationDetails PlatformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const IOSNotificationDetails()
      );
      await flutterLocalNotificationsPlugin.show(
        0, 
        message.notification?.title,
        message.notification?.body, 
        PlatformChannelSpecifics,
        payload: message.data['body']);
    });
  }

  //initialization
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User granted permission');
    } else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  //API send message
  void sendPushMessage(String token, String title, String body)async{
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAARCD6qcU:APA91bFaf-FagTZePoWGBGoFRHE1Nu0-8Og_N_IDYdEU6PkZt5YCjSs3pCVzlfg7zgtfJsz36NE6HLNTlYY-XEtrkzhFkLZR1n4qrb-ofJtZzHas28qL1DJS6LOwyJYZwdFSgJgDDxb7',
        },
        body: jsonEncode(
          <String, dynamic>{

            'priority': 'high',
            //到指定頁面
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'title': title,
              'body': body,
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channel_id": "hi"
            },
            "to": token,
          },
        ),
      );
    } catch(e){
      if(kDebugMode){
        print("error push notification");
      }
    }
  }
  


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: const Text("allowed filetype: jpeg, jpg, png, pdf"),
          ),
          const SizedBox(height: 3.0),
          Container(
            // upload button
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 3),
            child: ElevatedButton(
              onPressed: () async {
                // file picker
                try {
                  final FilePicker picker = FilePicker.platform;
                  file = await picker.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ["jpg", "png", "pdf", "jpeg"],
                  );
                  if (file == null) {
                    Fluttertoast.showToast(
                      msg: 'No File Selected',
                    );
                    return;
                  } else {
                    setState(() {
                      filename = file!.files[0].name;
                    });
                  }
                  debugPrint("successfully select file");
                } catch (e) {
                  debugPrint('Error at file picker: $e');
                  SnackBar(
                    content: Text(
                      'Error at file picker: $e',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                  return;
                }
              },
              child: const Text("upload contract"),
            ),
          ),
          Container(
            // filename
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10, bottom: 20),
            child: Text("selected file: $filename"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 20),
            child: TextFormField(
              controller: email_1,
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains("@")) {
                  return "invalid email";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: '輸入您的電子郵件',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 30),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: email_2,
                    validator: (value) {

                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return "invalid email";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: '輸入對方的電子郵件',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(10, 0, 0, 3),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (valid == true) {
                      // upload to IPFS
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => const ProgressDialog(
                          status: 'Uploading to IPFS',
                        ),
                      );
                      cid = await FlutterIpfs()
                          .uploadToIpfs(file!.files.single.path!);
                      debugPrint(cid);
                      Navigator.pop(context);
                      // TODO: call functions on the ethereum

                    } else {
                      String email_2Text = email_2.text;

                      // TODO: wait for consent
                      DocumentSnapshot snap =
                      await FirebaseFirestore.instance.collection("userTokens").doc(email_2Text).get();

                      String token = snap['token'];
                      //print(token);
                      sendPushMessage(token, "New contract!", "Log in and sign the contract");
                      
                      /*setState(() {
                        valid = true;
                      });*/
                    }
                  }
                },
                child: const Text("submit"),
              )),
        ],
      ),
    );
  }
}
