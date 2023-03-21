import 'package:path_provider/path_provider.dart';

Future<String> get appDocPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}