import 'package:path_provider/path_provider.dart';

//get local direactory path for user so as to open the file and check
Future<String> get appDocPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}