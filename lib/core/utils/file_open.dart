import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<File> getFileFromUrl(String url, {name}) async {
  var fileName = 'testonline';
  if (name != null) {
    fileName = name;
  }
  try {
    var data = await http.get(Uri.parse(url));
    var bytes = data.bodyBytes;
    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/$fileName.pdf");
    print(dir.path);
    File urlFile = await file.writeAsBytes(bytes);
    return urlFile;
  } catch (e) {
    throw Exception("Error opening url file");
  }
}

// open file
void openFile(File file) async {
  try {
    final result = await OpenFile.open(file.path);
    print(result.message);
  } catch (e) {
    print(e);
  }
}
