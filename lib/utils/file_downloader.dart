import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
Future<String?> downloadFile({link,name}) async {
  Get.snackbar("Opening file...", "Wait while we are opening file");
      var status = await Permission.storage.request();
    if (status.isGranted) {
   var response = await http.get(Uri.parse(link));
  if (response.statusCode == 200) {
    var filePath = '/storage/emulated/0/$name';
    var file = await File(filePath).writeAsBytes(response.bodyBytes);
   OpenFile.open(file.path);
    return file.path;
    } 
return "";
  
  } else {
    throw Exception('Failed to load image');
  }
}

