// normal contract 

//import 'package:data_storing_via_blockchain/api/google_auth_api.dart';
//import 'package:data_storing_via_blockchain/server/SendEmail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ipfs/flutter_ipfs.dart';
import 'package:flutter_ipfs/src/service/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:mailer/mailer.dart';
//import 'package:mailer/smtp_server.dart';


class NormCon extends StatelessWidget{
  const NormCon ({super.key});
  @override
  Widget build(BuildContext context){
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


  String filename = "none";
  String cid = "";
  bool valid = false;
  FilePickerResult? file;
  final _formKey = GlobalKey<FormState>();
  String val ='';


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children:  [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: const Text("allowed filetype: jpeg, jpg, png, pdf"),
          ),
          const SizedBox(height: 3.0),
          Container( // upload button
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
                    if(file == null){
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
                  } catch(e) {
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
          Container( // filename
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10, bottom: 20),
            child: Text("selected file: $filename"),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(13, 10, 13, 20),
            child: TextFormField(
              validator: (value){
                if(value == null || value.isEmpty || !value.contains("@")){
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
                    validator: (value){
                        val = value!;
                      
                      if(value == null || value.isEmpty || !value.contains("@")){
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
                ElevatedButton(
                  child: const Text("validate email"),
                  onPressed: () async {
                    //sendEmail();
                    // TODO: send email to this person
                    // remember to add some conditions to set valid to true
                    
                    if(_formKey.currentState!.validate() ){
                      String? encodeQueryParameters(Map<String, String> params) {
                        return params.entries
                            .map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                            .join('&');
                      }

                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: '$val',
                        query: encodeQueryParameters(<String, String>{'subject': '寄送信件測試', 'body': '您好, 寄送信件測試。'}),
                      );
                      launchUrl(emailLaunchUri);
                    }
                    
                    setState(() {
                      valid = true;
                    });
                  },
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 3),
            child: ElevatedButton(
              onPressed: () async {
                if(_formKey.currentState!.validate() && valid == true){
                  // upload to IPFS
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => const ProgressDialog(
                      status: 'Uploading to IPFS',
                    ),
                  );
                  cid = await FlutterIpfs().uploadToIpfs(file!.files.single.path!);
                  debugPrint(cid);
                  Navigator.pop(context);
                  // TODO: call functions on the ethereum
                }
              },
              child: const Text("submit"),
            )
          ),
        ],
      ),
    );
  }




}
  /*Future sendEmail() async{

  final user = await GoogleAuthApi.signIn();

  if(user == null) return;

  final email = user.email;
  final auth = await user.authentication;
  final token = auth.accessToken!;

  print('Authenticated: $email');

  final smtpServer = gmailRelaySaslXoauth2(email, token);
  final message = Message()
   ..from = Address(email, 'ian')
   ..recipients = ['ian52759@gmail.com']
   ..subject = 'Hello Johannes'
   ..text = 'This is a test email!';

  try{
    await send(message, smtpServer);
    //showSnackBar('Sent email successfully!');
  } on MailerException catch (e){
    print(e);
    return null;
  }
}*/

  /*

void showSnackBar(String text){
  final snackBar = SnackBar(
    content: Text(
      text,
      style: TextStyle(fontSize: 20),
    ),
    backgroundColor: Colors.green,
  );

  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}*/

