// normal contract 
//小東西
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'dart:io';
import 'package:data_storing_via_blockchain/Classes/usermodel.dart';
//import 'package:data_storing_via_blockchain/pages/generateNFT.dart';
import 'package:flutter/material.dart';
import 'package:data_storing_via_blockchain/pages/kids/MyContract/RecordedCon.dart';
import 'package:data_storing_via_blockchain/Classes/user.dart';
import 'package:data_storing_via_blockchain/pages/kids/NormalContract/ShowFile.dart';
//import 'package:permission_handler/permission_handler.dart';
//寄通知
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
//選資料
//import 'package:flutter_ipfs/flutter_ipfs.dart';
//import 'package:flutter_ipfs/src/service/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
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
        title: const Text("簽署"),
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
  //static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  String filename = "";
  String filePath = "";
  String cid = "";
  FilePickerResult? file;
  var result;
  final _formKey = GlobalKey<FormState>();
  
  //email controller
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  //name controller
  final TextEditingController controller3 = TextEditingController();
  final TextEditingController controller4 = TextEditingController();

  
  //函式
  /*Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = '$path/tmpData.json';
    debugPrint(filePath);
    return File('$path/tmpData.json');
  }

  Future<File> writeFile(String json) async {
    final file = await _localFile;
    return file.writeAsString(json);
  }

  Future<int> readFile() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      debugPrint(contents);

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }*/

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
    //initInfo();
  }
  /*initInfo(){
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    //the function does not work
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onDidReceiveNotificationResponse: (payload) async {
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
    });
    some problems here I can not address
    */ /*FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
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
        importance: Importance.max,
        styleInformation: bigTextStyleInformation, 
        priority: Priority.high, 
        playSound: true,

      );
      NotificationDetails PlatformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails()
      );
      await flutterLocalNotificationsPlugin.show(
        0, 
        message.notification?.title,
        message.notification?.body, 
        PlatformChannelSpecifics,
        payload: message.data['body']);
    });
  }*/
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
            child: const Text("allowed filetype: jpeg, jpg, png, pdf"),
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
                      allowedExtensions: ["jpg", "png", "pdf", "jpeg"],
                      withData: true,
                    );
                    if (file == null) {
                      Fluttertoast.showToast(
                        msg: 'No File Selected',
                      );
                      return;

                    } else {
                      //here
                      Directory appDocDir = await getApplicationDocumentsDirectory();
                      String appDocPath = appDocDir.path;
                      String tmp = file!.files[0].name;
                      //debugPrint("*********$appDoc")
                      String filePath = "$appDocPath/$tmp";
                      var localFile = File(filePath);
                      bool t = (file!.files.first.bytes == null);
                      //debugPrint("********$t");
                      localFile.writeAsBytes(file!.files.first.bytes as Uint8List);
                      //debugPrint("********$appDocPath/$tmp");
                      //debugPrint("*******${file!.files}");

                      setState(() {
                        int size = tmp.length;
                        for(int i=0; i<size-4; i++){
                          filename += tmp[i];
                        }
                        print(size);
                        print(tmp);
                        print(filename);
                        result = File(file!.files.single.path!);
                        /*final userModel = UserModel(file: result);
                        final userProvider = Provider.of<UserProvider>(context, listen: false);
                        userProvider.setUserModel(userModel);*/
                        openPDF(context, result);
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
                hintText: '輸入您的名字',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 20),
            child: TextFormField(
              controller: controller4,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: '輸入對方的名字',
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
                    controller: controller2,
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
              margin: const EdgeInsets.fromLTRB(20, 0, 0, 3),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String time = await getTime();
                    //存一些資料在firestore，用來顯示在帶簽署那裏，讓使用者清楚知道一些合約基本資訊
                    var name1 = controller3.text;
                    var name2 = controller4.text;
                    String name = '$name1, $name2';

                    var email1 = controller1.text;
                    var email2 = controller2.text;

                    var cidOfContract = file!.files.single.path!;

                    await FirebaseFirestore.instance
                        .collection("user")
                        .doc(email1)
                        .collection("contract")
                        .doc(filename)
                        .set(User(
                          name: name,
                          contractname: filename,
                          another_email: email2,
                          have_checked: true,
                          time: time,
                          order: "first",
                          path: cidOfContract,
                        ).toJson());
                    await FirebaseFirestore.instance
                        .collection("user")
                        .doc(email2)
                        .collection("contract")
                        .doc(filename)
                        .set(User(
                          name: name,
                          contractname: filename,
                          another_email: email1,
                          have_checked: false,
                          time: "not sign yet",
                          order: "second",
                          path: cidOfContract,
                        ).toJson());

                    DocumentSnapshot snap =
                      await FirebaseFirestore.instance.collection("user").doc(email2).get();
                      String token = snap['token'];
                      //print(token);
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




