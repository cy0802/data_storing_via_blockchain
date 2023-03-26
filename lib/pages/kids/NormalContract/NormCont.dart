// normal contract 
//小東西
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'dart:io';
//import 'package:data_storing_via_blockchain/pages/generateNFT.dart';
import 'package:data_storing_via_blockchain/font/utils.dart';
import 'package:data_storing_via_blockchain/function/local_folder.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/RecordedCon.dart';
import 'package:data_storing_via_blockchain/Classes/user.dart';
import 'package:data_storing_via_blockchain/pages/kids/NormalContract/ShowFile.dart';

//寄通知
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
//選資料
//import 'package:flutter_ipfs/flutter_ipfs.dart';
//import 'package:flutter_ipfs/src/service/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
//import 'package:provider/provider.dart';
//import 'package:web3dart/web3dart.dart';
//import 'package:data_storing_via_blockchain/pages/protectedInfo.dart';


//------------------------------------------------------------我是用來美觀的-------------------------------------------------------------------

class NormCon extends StatelessWidget {
  const NormCon({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Sign",
          style: TextStyle(
            letterSpacing: 2,
            fontSize: 22,
            //fontWeight: FontWeight.bold,
          )
        ),
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

  //變數
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String filename = "";
  String filePath = "";
  String cid = "";
  FilePickerResult? file;
  PlatformFile? pickedFile;
  late File result;
  final _formKey = GlobalKey<FormState>();
  
  //email controller
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  //name controller
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();

  Future<String> getTime() async{
  Response response =  await get(Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Taipei')) ;
    Map data = jsonDecode(response.body);
    print(data);
    String datetime = data['datetime'];
    String offset = data['utc_offset'].substring(1,3);
    //print(datetime);
    //print(offset);

    //create DateTime object
    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: int.parse(offset)));
    String time = DateFormat.yMEd().add_jms().format(now);
    return time;
}
 
  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    requestPermission();
    initInfo();
  }
  initInfo(){
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    //the function does not work
    flutterLocalNotificationsPlugin.initialize(initializationsSettings/*, onSelectNotificationAction: (String? payload) async {
      try{
        if(payload != null){
          print(".......................onBackgroundMessage.......................");
          print("fdfdffdfdfdfdff");
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return History();
          }
          ));
        } else {          
        }
      }catch(e){
        print(e.toString());
      }
      return;
    }*/);
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
        'hi',
        'hi',
        importance: Importance.max,
        styleInformation: bigTextStyleInformation, 
        priority: Priority.high, 
        playSound: true,

      );
      NotificationDetails PlatformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const IOSNotificationDetails(),
      );
      await flutterLocalNotificationsPlugin.show(
        0, 
        message.notification?.title,
        message.notification?.body, 
        PlatformChannelSpecifics,
        payload: message.data['body']);
    });
  }
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
  void sendPushMessage(String token, String title, String body)async{
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAqOwXa7E:APA91bEMcWU-zUiG7l8p4eEvuHGfmpFEpxGzl0DbLk-fbeXsd14005kPtvpDlvz1LhV0XM9Aj9ZkPaGwjCGXtO-ZGdmpKbItOMPkLynCW0OX2TbTa-Dfe0iVWwQ4AV5ArYziUXy00SCj',
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
  
  void openPDF(BuildContext context, File file) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => PDFViewPage(file: file)));
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Spacer(flex: 1),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: const Text("allowed filetype: pdf" /*"jpg", "png", "jpeg"*/ ),
          ),
          const SizedBox(height: 3.0),
          Container(
            // upload button
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(3, 3, 3, 3),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 102, 184, 251),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 130, vertical: 10),
                ),
                onPressed: () async {
                  // file picker

                  try {
                    final FilePicker picker = FilePicker.platform;
                    file = await picker.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: [/*"jpg", "png", "jpeg"*/ "pdf"],
                      withData: true,
                    );
                    if (file == null) {
                      Fluttertoast.showToast(
                        msg: 'No File Selected',
                      );
                      return;

                    } else {
                      filename = "";
                      pickedFile = file!.files.first;
                      String tmp = file!.files[0].name;
                      result = File(pickedFile!.path!);
                      debugPrint("***********${result.path}");
                      openPDF(context, result);
                      setState(() {
                        int size = tmp.length;
                        for(int i=0; i<size-4; i++){
                          filename += tmp[i];
                        }
                        //result = File(file!.files.single.path!);
                        //result = File(filePath);
                      });
                      debugPrint("successfully select file");
                    }
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
                child: const Text("Select Contract"),
              ),
            ),
          ),
          //Con
          Container(
            // filename
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10, bottom: 20),
            child: Text("selected file: $filename"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 20),
            child: TextFormField(
              controller: controller3,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'type your name',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 20),
            child: TextFormField(
              controller: controller4,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'type his/her name',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 20),
            child: TextFormField(
              controller: controller1,
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains("@")) {
                  return "invalid email";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'type your email',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 30),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller2,
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains("@")) {
                        return "invalid email";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'type his/her email',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(20, 0, 0, 3),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String time = await getTime();
                    //存一些資料在firestore，用來顯示在待簽署那裏，讓使用者清楚知道一些合約基本資訊
                    var name1 = controller3.text;
                    var name2 = controller4.text;
                    String name = '$name1, $name2';

                    var email1 = controller1.text;
                    var email2 = controller2.text;

                    final path = 'files/$email1+$email2/$filename';
                    final ref = FirebaseStorage.instance.ref().child(path);
                    await ref.putFile(result);
                    final urlDownload = await ref.getDownloadURL();
                    final path1 = await appDocPath;
                    final totalPath = '$path1/$path';
                    await Dio().download(urlDownload, totalPath);

                    await FirebaseFirestore.instance.collection("user").doc(email1)
                        .collection("contract")
                        .doc(filename)
                        .set(User(
                          name: name,
                          contractname: filename,
                          another_email: email2,
                          time: time,
                          order: "wait for agreement",
                          path: path,
                        ).toJson());
                    await FirebaseFirestore.instance.collection("user").doc(email2)
                        .collection("contract")
                        .doc(filename)
                        .set(User(
                          name: name,
                          contractname: filename,
                          another_email: email1,
                          time: "not sign yet",
                          order: "agree",
                          path: path,
                        ).toJson());

                    DocumentSnapshot snap =
                      await FirebaseFirestore.instance.collection("user").doc(email2).get();
                      String token = snap['token'];

                    sendPushMessage(token, "New contract!", "Log in and sign the contract");

                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => const History(),
                      ),
                    );
                  }
                },
                child: const Text("submit"),
              )
            ),
          const Spacer(flex: 9),
        ],
      ),
    );
  }
}




